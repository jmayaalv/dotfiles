---
description: Generate a Clojure project using kane-broker and kane-bus architecture patterns
allowed-tools: Write, MultiEdit, Bash
argument-hint: <project-name> [domain-name]
---

Generate a complete Clojure project structure following kane-broker and kane-bus architectural patterns based on the trade module.

**Usage:**
- `$1` - Project name (required): The name of the project directory to create
- `$2` - Domain name (optional): The business domain (defaults to "order" if not provided)

**Architecture Features:**
- Kane-Bus CQRS commands with coeffects pattern
- Kane-Broker integration with auto-discovery and effect registration
- Database layer with HoneySQL and PostgreSQL migrations
- JMS integration with kane.io.jms for async messaging
- Effect system for external integrations
- Tagged literals for type safety (#money, #currency, #time)
- Parallel test patterns with exact SQL assertions
- Proper project structure with clear layering (api → command → db, effect)

**Generated Structure:**
```
project-name/
├── deps.edn                    # Dependencies and aliases
├── CLAUDE.md                   # Architecture docs and dev commands
├── src/edge/
│   └── domain/
│       ├── api.clj             # Public API layer
│       ├── command.clj         # CQRS commands
│       ├── db.clj              # Database queries
│       ├── jms.clj             # Message queue integration
│       └── effect/
│           └── sample.clj      # Sample effect
├── test/edge/test/
│   └── domain/
│       ├── api_test.clj
│       ├── command_test.clj
│       └── db_test.clj
└── resources/
    └── migrations/
        └── sample-migration.sql
```

**Dependencies Included:**
Core:
- kane/broker (2025.09.11), kane/clj-mq (2025.03.24) for CQRS architecture
- kane/readers (2025.08.26) for tagged literal support (#money, #currency, #time)
- HoneySQL (2.4.1011), next.jdbc (1.3.865) for database operations
- PostgreSQL driver, HikariCP for connection pooling
- Exoscale coax and lingo utilities, Joda Money for financial calculations

Dev dependencies (:dev alias):
- ActiveMQ broker, tools.namespace, criterium, clj-kondo

Test dependencies (:test alias):
- ActiveMQ broker, Metabase Hawk for parallel test execution
- Test containers for integration testing, matcher combinators
- Logback for logging

Create project directory and generate all architectural components with proper kane-broker patterns.

- dont generate any specific domain methods, focus on the architecture.
- Dont add any commands but add all the necesary namespaces and requests
- Dont add db statements
- Make sure the commands are registered using the nsamespace
