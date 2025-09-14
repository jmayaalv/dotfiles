#!/usr/bin/env bash
# Claude Code command: /kane-broker
# Analyzes projects for kane-broker architecture patterns and provides migration guidance

echo "# Kane-Broker Architecture Analysis & Migration Guide"
echo ""
echo "Analyzing current project and providing guidance for kane-broker architecture adoption..."
echo ""

# Project Analysis Guidelines for kane-broker architecture
cat << 'ANALYSIS_GUIDE'
## 🔍 Project Analysis Steps

### 1. Detect Project Type
```bash
if [ -f "project.clj" ]; then
    echo "✅ Leiningen project detected"
    PROJECT_TYPE="lein"
elif [ -f "deps.edn" ]; then
    echo "✅ deps.edn project detected"
    PROJECT_TYPE="deps"
else
    echo "❓ Unknown project type - check for build files"
fi
```

### 2. Check for Kane Dependencies
```bash
# For Leiningen projects
grep -E "\[kane/(broker|bus|clj-mq)" project.clj

# For deps.edn projects
grep -E "kane/(broker|bus|clj-mq)" deps.edn
```

### 3. Analyze Existing Architecture Patterns
```bash
# Find command-like patterns
find . -name "*.clj" -exec grep -l "defcommand\|handle-\|process-" {} \;

# Find effect/side-effect patterns
find . -name "*.clj" -exec grep -l "effect\|side-effect" {} \;

# Find spec usage
find . -name "*.clj" -exec grep -l "clojure.spec\|s/def" {} \;

# Find messaging patterns
find . -name "*.clj" -exec grep -l "jms\|queue\|publish\|consume" {} \;

# Find database patterns
find . -name "*.clj" -exec grep -l "jdbc\|sql\|database" {} \;
```

## 📋 Architecture Assessment Checklist

### Current Project Status
- [ ] Project type: □ Leiningen □ deps.edn □ Other: ________
- [ ] Has kane dependencies: □ Yes □ No
- [ ] Uses CQRS patterns: □ Yes □ Partial □ No
- [ ] Has effect system: □ Yes □ No
- [ ] Uses clojure.spec: □ Yes □ No
- [ ] Has messaging: □ Yes □ No
- [ ] Architecture docs: □ Yes □ No

### Current Architecture Type
- [ ] Web app (Ring/Compojure/Reitit)
- [ ] CLI application
- [ ] Microservice
- [ ] Library
- [ ] Monolith with multiple domains
- [ ] Other: ________________

### Existing Patterns Found
- [ ] Handler functions with side effects
- [ ] Multimethod dispatch
- [ ] Component/Mount/Integrant system
- [ ] Direct database calls
- [ ] HTTP client calls
- [ ] File I/O operations
- [ ] Message queue usage

### External Integrations
- [ ] Database: ________________
- [ ] Message queue: ____________
- [ ] External APIs: ____________
- [ ] File systems: ____________
- [ ] Other services: ___________

## 🚀 Migration Strategy by Project Type

### A. Leiningen Project Migration

#### Phase 1: Add Kane Dependencies
```clojure
;; Add to project.clj :dependencies
[kane/broker "2025.09.11"]
[kane/clj-mq "2025.03.24"]
[kane/readers "2025.08.26"]
[com.github.seancorfield/honeysql "2.4.1011"]
[com.github.seancorfield/next.jdbc "1.3.865"]
[camel-snake-kebab/camel-snake-kebab "0.4.0"]

;; Add profiles
:profiles {:dev {:dependencies [[org.clojure/tools.namespace "1.3.0"]
                                [org.apache.activemq/activemq-broker "6.1.5"]]
                 :source-paths ["env/dev"]}
           :test {:dependencies [[io.github.metabase/hawk "1.0.7"]]}}

:repl-options {:init-ns user :port 7888}
```

### B. deps.edn Project Migration

#### Phase 1: Add Kane Dependencies
```clojure
{:deps {kane/broker {:mvn/version "2025.09.11"}
        kane/clj-mq {:mvn/version "2025.03.24"}
        kane/readers {:mvn/version "2025.08.26"}
        com.github.seancorfield/honeysql {:mvn/version "2.4.1011"}
        com.github.seancorfield/next.jdbc {:mvn/version "1.3.865"}
        camel-snake-kebab/camel-snake-kebab {:mvn/version "0.4.0"}}

 :aliases {:dev {:extra-paths ["env/dev"]
                 :extra-deps {org.clojure/tools.namespace {:mvn/version "1.3.0"}
                              org.apache.activemq/activemq-broker {:mvn/version "6.1.5"}}}
           :test {:extra-paths ["test"]
                  :extra-deps {io.github.metabase/hawk {:mvn/version "1.0.7"}}}
           :nrepl {:extra-deps {nrepl/nrepl {:mvn/version "1.3.1"}}
                   :main-opts ["-m" "nrepl.cmdline" "--port" "7888"]}}}
```

## 🏗️ Implementation Roadmap

### Week 1: Foundation Setup
- [ ] Add kane dependencies to build file
- [ ] Create first command namespace: `domain.command`
- [ ] Set up broker in API namespace: `domain.api`
- [ ] Convert one simple operation to `defcommand`

**Example First Command:**
```clojure
(ns domain.command
  (:require [kane.bus.macro :refer [defcommand]]
            [kane.effect.helper :as effect]))

(defcommand simple-operation
  [{:keys [command coeffects]}]
  {:coeffects {:timestamp (fn [_] (java.time.Instant/now))}
   :id :domain/simple-operation!}
  (let [{:keys [timestamp]} coeffects]
    ;; Business logic here
    [:ok {:result "success" :timestamp timestamp} []]))
```

### Week 2: Core Patterns
- [ ] Implement coeffects pattern for dependencies
- [ ] Add effect system for database operations
- [ ] Create spec definitions: `domain.spec`
- [ ] Set up database layer: `domain.db`

**Database Effect Pattern:**
```clojure
(let [db-effects [(db/insert-entity entity)]
      effects [(effect/db db-effects)]]
  [:ok entity effects])
```

### Week 3: Integration & Messaging
- [ ] Add JMS messaging effects: `domain.jms`
- [ ] Implement external service effects: `domain.effect`
- [ ] Create comprehensive error handling
- [ ] Add structured logging

### Week 4: Documentation & Testing
- [ ] Generate C4 architecture documentation
- [ ] Create ADRs for architectural decisions
- [ ] Add comprehensive test coverage
- [ ] Update project README/CLAUDE.md

## 🎯 Key Architecture Patterns to Implement

### 1. CQRS Command Pattern
```clojure
(defcommand process-entity
  [{:keys [command coeffects]}]
  {:coeffects {:existing-entity (fn [{:keys [db command]}]
                                  (db/get-entity db (:entity/id command)))
               :timestamp (fn [{:keys [clock]}]
                           (java.time.Instant/now))}
   :id :domain/process-entity!}
  (let [{:keys [existing-entity timestamp]} coeffects]
    (cond
      existing-entity
      [:error (ex-info "Entity exists" {:entity/id (:entity/id command)})]

      :else
      (let [entity (assoc command :created-at timestamp)
            db-effects [(db/insert-entity entity)]
            jms-effects [(jms/entity-created entity)]
            effects [(effect/db db-effects) (effect/jms jms-effects)]]
        [:ok entity effects]))))
```

### 2. Broker Setup Pattern
```clojure
(defn- setup-broker [context]
  (let [broker (broker/create)
        registration-info (broker.util/register-namespace-commands
                           broker 'domain.command)]
    ;; Register custom effects
    (broker/register-effect! broker :external/api external-api-effect!)
    (log/info "Registered commands:" (:commands registration-info))
    broker))

(defn start! [context]
  {:pre [(s/valid? :domain/context context)]}
  (let [broker (setup-broker context)]
    {:broker broker}))
```

### 3. Effect System Pattern
```clojure
;; Database effects
(defn db-effect [statements]
  {:effect/type :db
   :statements statements})

;; JMS effects
(defn jms-effect [messages]
  {:effect/type :jms
   :messages messages})

;; External API effects
(defn api-effect [request]
  {:effect/type :external/api
   :request request})
```

## 🔧 Migration by Current Architecture

### Ring/Compojure Web Apps
```
Current: app/handler.clj with direct side effects
Target:  app/api.clj dispatching to commands

Steps:
1. Keep existing routes, change handlers to command dispatchers
2. Move business logic to defcommand functions
3. Replace direct DB/API calls with effects
4. Add coeffects for request context
```

### Component/Mount Systems
```
Current: system.clj managing components
Target:  broker as system component

Steps:
1. Add broker to system components
2. Convert service methods to commands
3. Use coeffects to access system state
4. Replace component calls with effects
```

### Traditional Clojure Apps
```
Current: core.clj with direct function calls
Target:  Full CQRS with kane-broker

Steps:
1. Identify all business operations
2. Create command namespace with defcommand
3. Add broker setup and registration
4. Replace all side effects with effect system
```

## 📊 Success Criteria

### Technical Metrics
- [ ] All business operations use defcommand
- [ ] No direct side effects in business logic
- [ ] All external calls use effect system
- [ ] Comprehensive test coverage (>85%)
- [ ] All commands have specs

### Architecture Quality
- [ ] Clear separation of concerns
- [ ] Immutable data structures throughout
- [ ] Explicit dependency management via coeffects
- [ ] Comprehensive error handling
- [ ] Complete C4 documentation

ANALYSIS_GUIDE

echo ""
echo "## 🎯 Next Steps"
echo ""
echo "1. Run the analysis commands above on your project"
echo "2. Fill out the architecture assessment checklist"
echo "3. Choose appropriate migration strategy based on project type"
echo "4. Follow the weekly implementation roadmap"
echo "5. Use the provided code patterns as templates"
echo ""
echo "💡 **Tip**: Start with one simple business operation and gradually"
echo "   expand the kane-broker patterns throughout your codebase."