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
6. **CRITICAL - Fix common bb test issues**:
   - **Remove hooks import**: Don't include `[kane.build.hooks :as hooks]` in requires
   - **Comment out hooks tasks**: Avoid `setup:hooks {:task (hooks/install-hooks!)}`
   - **Use correct test command**: `clojure -X:test` not `-M:test` for exec functions
   - **Handle missing subprojects**: Use conditional existence checks

Arguments:
- $1: Space-separated list of subproject directory names (optional - will auto-detect if not provided)
- $2: Git SHA for kane-build (optional - will use latest if not provided)

Example usage: 
- `/kane-build-monorepo` (auto-detect projects)
- `/kane-build-monorepo core api broker` (specific projects)
- `/kane-build-monorepo core api e1cb408e42192807fcf2c4079ba8037315d9255b` (with specific SHA)

Follow the vertex monorepo pattern as reference.