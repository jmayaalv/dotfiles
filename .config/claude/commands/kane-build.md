---
description: Add kane-build configuration to a Clojure project
---

I need to add kane-build configuration to this Clojure project. Please:

1. **Analyze the project structure**: Check if this is a single project or monorepo
2. **Create bb.edn file(s)**: 
   - For single projects: Create a standard kane-build bb.edn with CI/CD tasks
   - For monorepos: Create root bb.edn with project-specific tasks and individual bb.edn files for each subproject
3. **Configure dependencies**: Add kane-build dependency with the latest git SHA
4. **Include standard tasks**:
   - clean: Clean build artifacts
   - test: Run tests
   - ci: CI pipeline (test + build)
   - install: Install JAR locally
   - deploy: Deploy to remote repo
   - repl: Start development REPL
   - Git hooks management (setup:hooks, hooks:status, hooks:remove), shell-based as described below

Use the kane-bus and vertex projects as reference patterns. If arguments are provided:
- $1: Project type ("single" or "monorepo") 
- $2: Git SHA for kane-build (optional, use latest if not provided)

The command should follow these patterns:
- Single project: Standard kane-build bb.edn like vertex-core
- Monorepo: Root coordinator bb.edn + individual project bb.edn files like vertex

Known constraints:
1. **Test command**: use `clojure -X:test`, not `-M:test` - the test runners are exec functions.
2. **Hooks**: don't require `[kane.build.hooks :as hooks]` or call `(hooks/install-hooks!)` - it causes classpath errors. Define hooks tasks by shelling out instead: `(shell "bb" "--config" "../kane-build/bb.edn" "setup:hooks")`.

Ensure proper git SHA and repository URL for kane-build dependency.