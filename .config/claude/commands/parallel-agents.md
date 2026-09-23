I want to develop features in parallel using Git worktrees and subagents: $ARGUMENTS

You are in the parent folder of the main repo. You will need to change to the main repo
folder to create the worktrees.

Please execute this complete workflow:

PHASE 1 - SETUP WORKTREES:
For each feature mentioned:
1. Create a worktree at ../claude-[feature-name] with branch feature/[feature-name]
2. Set up the development environment in each worktree (if needed)
3. List all worktrees created

PHASE 2 - SPAWN SUBAGENTS:
For each feature, run a subagent in parallel with these instructions:
- You are working in the ../claude-[feature-name] worktree directory
- This is a completely isolated development environment
- Implement the [feature-name] feature, with tests
- Compile and run tests, but don't attempt to run the application (e.g., don't do "npm run" or "npm run dev &", etc.) 
- When complete, write a summary in [feature-name].work.txt in the main repo directory
- The summary should include: what was implemented, files created/modified, dependencies added, testing approach, and integration notes

PHASE 3 - FINAL SUMMARY:
After all subagents complete:
1. Read all the .work.txt files created by subagents
2. Provide a comprehensive summary of what was accomplished
3. List all features implemented and their status
4. Provide next steps for integration
