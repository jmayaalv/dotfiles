---
allowed-tools: Read, Write, Edit, Bash
argument-hint: [framework] | --c4-model | --arc42 | --adr | --plantuml | --full-suite
description: Generate comprehensive architecture documentation with diagrams, ADRs, and interactive visualization
---

# Architecture Documentation Generator

Generate comprehensive architecture documentation: $ARGUMENTS

## Current Architecture Context

- Project structure: !`find . -type f -name "*.json" -o -name "*.yaml" -o -name "*.toml" | head -5`
- Documentation exists: @docs/ or @README.md (if exists)
- Architecture files: !`find . -name "*architecture*" -o -name "*design*" -o -name "*.puml" | head -3`
- Services/containers: @docker-compose.yml or @k8s/ (if exists)
- API definitions: !`find . -name "*api*" -o -name "*openapi*" -o -name "*swagger*" | head -3`

## Task

Document this system's architecture for engineers who will maintain it: what the components are, how they talk to each other, where data lives, and why the key design decisions were made. Everything you write must be traceable to the code or existing docs - where something can't be determined from the repository, say so rather than inferring it.

Argument selects the format (default: C4 plus ADRs):
- `--c4-model`: C4 context, container, and component diagrams as Mermaid or PlantUML, each with a short prose explanation
- `--arc42`: an arc42-structured document, leaving sections the repository can't inform marked as open
- `--adr`: Architecture Decision Records for the decisions visible in the code (context, decision, consequences, alternatives where known)
- `--plantuml`: diagrams as PlantUML source files
- `--full-suite`: all of the above
- a framework name: focus the documentation on that framework's structure

Put the output under `docs/architecture/` unless the project already has an architecture docs location. Cover security boundaries, data flow, and deployment where the repository shows them, and note architectural debt you find as open questions rather than prescriptions.
