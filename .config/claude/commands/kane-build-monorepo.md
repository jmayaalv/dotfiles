---
description: Add kane-build configuration for a monorepo with multiple Clojure projects
---

I need to set up kane-build configuration for this monorepo. Please:

1. **Analyze the monorepo structure**: Identify all Clojure subprojects by looking for deps.edn files
2. **Create root bb.edn**: Set up coordinator tasks that delegate to subprojects using the pattern:
   ```
   project-name:task -> (shell {:dir "project-directory"} "bb task")
   ```
3. **Create individual bb.edn files**: For each subproject, create a standard kane-build bb.edn
4. **Use proper naming**: 
   - Root tasks should use project names as prefixes (e.g., `core:test`, `api:deploy`)
   - Cross-project tasks should coordinate all subprojects (e.g., `test` runs all project tests)
5. **Include conditional logic**: Use `(fs/exists? "project-dir")` for optional subprojects
6. **Known constraints**:
   - Don't require `[kane.build.hooks :as hooks]` or call `(hooks/install-hooks!)` - it causes classpath errors. Define hooks tasks by shelling out: `(shell "bb" "--config" "../kane-build/bb.edn" "setup:hooks")`.
   - Use `clojure -X:test`, not `-M:test` - the test runners are exec functions.

Arguments:
- $1: Space-separated list of subproject directory names (optional - will auto-detect if not provided)
- $2: Git SHA for kane-build (optional - will use latest if not provided)

Example usage: 
- `/kane-build-monorepo` (auto-detect projects)
- `/kane-build-monorepo core api broker` (specific projects)
- `/kane-build-monorepo core api e1cb408e42192807fcf2c4079ba8037315d9255b` (with specific SHA)

Follow the vertex monorepo pattern as reference.