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
   - Git hooks management (setup:hooks, hooks:status, hooks:remove)

Use the kane-bus and vertex projects as reference patterns. If arguments are provided:
- $1: Project type ("single" or "monorepo") 
- $2: Git SHA for kane-build (optional, use latest if not provided)

The command should follow these patterns:
- Single project: Standard kane-build bb.edn like vertex-core
- Monorepo: Root coordinator bb.edn + individual project bb.edn files like vertex

**IMPORTANT - Common Issues to Fix**:
1. **Test command**: Use `clojure -X:test` not `-M:test` for exec-function based test runners
2. **Hooks imports**: Remove `[kane.build.hooks :as hooks]` import to avoid classpath issues
3. **Hooks tasks**: Comment out or remove hooks tasks that call `(hooks/install-hooks!)` etc.
4. **Alternative hooks**: Use shell-based hooks: `(shell "bb" "--config" "../kane-build/bb.edn" "setup:hooks")`

Ensure proper git SHA and repository URL for kane-build dependency.