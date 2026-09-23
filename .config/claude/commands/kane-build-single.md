---
description: Add kane-build configuration for a single Clojure project
---

I need to add kane-build configuration to this single Clojure project. Please:

1. **Verify project structure**: Confirm this is a single Clojure project with deps.edn
2. **Create bb.edn file**: Set up standard kane-build configuration with:
   - Kane-build dependency with proper git URL and SHA
   - Standard build tasks (clean, test, ci, install, deploy, repl)
   - Git hooks management tasks (shell-based - see below)
   - Proper requires and override-builtin configuration
3. **Use standard task structure**:
   ```clojure
   clean {:doc "Clean build artifacts"
          :task (fs/delete-tree "target")}
   
   test {:doc "Run tests" 
         :task (shell "clojure -X:test")  ; Use -X not -M for exec functions
         :depends [clean]}
   
   ci {:doc "CI pipeline: test + build JAR"
       :task (shell "clojure -T:build ci") 
       :depends [test]}
   ```
4. **Known constraints**:
   - Don't require `[kane.build.hooks :as hooks]` or call `(hooks/install-hooks!)` - it causes classpath errors. Define hooks tasks by shelling out: `(shell "bb" "--config" "../kane-build/bb.edn" "setup:hooks")`.
   - Use `-X:test`, not `-M:test` - the Hawk test runner is an exec function.

Arguments:
- $1: Git SHA for kane-build (optional - will use latest if not provided)

Follow the vertex-core project pattern as reference.