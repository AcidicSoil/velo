---
project: velo
purpose: >
  Velo is a conversational CLI assistant designed to help developers analyze, generate, and automate common tasks within project repositories. It provides context-aware suggestions, interactive wizards, and integrates with local and external developer tools.
target_users:
  - Developers (Node.js, Python, TypeScript, Go, etc.)
  - DevOps/SRE
  - Open-source maintainers
core_features:
  - Context-aware project analysis (detect frameworks, summarize structure)
  - Command palette and interactive help (`velo help`)
  - Code generation and templating (tests, configs)
  - AI-powered code explanation and refactoring
  - Plugin/extension system (Python plugins)
  - Local model serving (llama.cpp or llama-cpp-python)
  - Cross-compiling for different platforms
  - YAML-based configuration
  - LLM/agent-based testing and automation
  - Dry-run/preview mode for all commands
commands:
  - command: velo init
    description: Initialize a new velo project.
    usage: velo init [options]
  - command: velo analyze [target]
    description: Analyze codebase or directory, output summary.
    usage: velo analyze src/
  - command: velo generate test --for <file>
    description: Generate test skeleton for a given source file.
    usage: velo generate test --for src/main.ts
  - command: velo explain <file>
    description: AI-powered code explanation.
    usage: velo explain src/utils/helpers.py
  - command: velo help
    description: List available commands, flags, and usage examples.
    usage: velo help
  # ... add further commands as features are defined
extension_points:
  - Plugin system for new commands (Python, with manifest schema)
  - Config templates (YAML)
  - Custom command aliases
non_goals:
  - Velo is **not** a general-purpose shell replacement
  - Does **not** store or transmit user code externally (unless user configures remote APIs)
  - No built-in telemetry unless explicitly enabled
integration_points:
  - Git (repo awareness, branch context)
  - Docker (project containerization)
  - LLM inference (llama.cpp, OpenAI API [optional])
  - Plugin marketplace [future]
data_handling:
  - Does not store or transmit user data without consent
  - No default external telemetry
  - Configuration stored in local YAML files
security_considerations:
  - No sensitive data stored or transmitted by default
  - Optional opt-in for telemetry and remote inference
  - User controls all local/remote model usage
deployment_targets:
  - Local CLI (cross-platform)
  - Docker container
  - Future: Package manager (brew, npm, etc.)
positioning:
  - Velo is most similar to gemini-cli in conversational flow and interactive wizards, but with a **local-first, extensible plugin architecture**.
  - Unlike Codex, Velo supports offline/local model inference for privacy and speed.
  - Velo aims to be language/tool-agnostic with first-class support for major developer workflows.
error_handling:
  - On ambiguous input, Velo asks clarifying questions rather than guessing.
  - If external models/APIs fail, Velo falls back to local analysis or shows actionable error messages.
  - All destructive actions require explicit confirmation (or --yes flag).
testing_strategy:
  - Dry-run and preview mode for all commands.
  - Automated tests for core workflows and agentic patterns.
  - LLM/agent integration tests using example codebases.
accessibility:
  - All output supports alternative text and screen readers.
  - Verbose/quiet output flags available.
changelog:
  - v0.1: Initial masterplan and CLI scaffolding.
  - v0.2: Added Python plugin support.
  - v0.3: Local model (llama.cpp) integration.
  # ...extend as needed
examples:
  - User: velo help
    Assistant: Here are common commands...
  - User: velo analyze src/
    Assistant: The src directory contains...
  - User: velo explain main.py
    Assistant: This file defines a Flask web server...
must_have_features:
  - [ ] Context-aware CLI help
  - [ ] Local LLM integration (llama.cpp)
  - [ ] Plugin system (Python)
  - [ ] YAML config loader
  - [ ] Dry-run mode
nice_to_have_features:
  - [ ] Remote inference (OpenAI, Gemini, etc.)
  - [ ] Plugin marketplace/discovery
  - [ ] Interactive onboarding wizard
  - [ ] VSCode integration
future_expansion:
  - Cloud sync for config/plugins (opt-in)
  - Web dashboard for project analytics
  - Team collaboration features
---

## Objectives

- Provide an extensible, conversational CLI assistant for developer workflows.
- Prioritize local-first, privacy-conscious AI capabilities.
- Enable seamless extension with plugins and integrations.
- Deliver clear, actionable responses for common coding tasks.

## Problem Domain

Velo addresses developer friction in multi-language, multi-tool repositories by offering an AI-powered CLI for analysis, automation, and code generation—without needing cloud access or deep manual configuration.

## Target Audience

- Individual developers
- Teams with polyglot codebases
- Open-source project maintainers
- DevOps/SRE engineers

## High-Level Technical Stack (No code, just concepts)

- CLI core: TypeScript
- Plugin system: Python (manifest-based)
- Model serving: llama.cpp or llama-cpp-python (local)
- Config: YAML files, cross-platform paths
- Packaging: Cross-compile for major OSs
- Testing: LLM/agent test harness

## Conceptual Data Model

- Project config (YAML): {name, plugins, model config, command aliases}
- Plugins: Manifest, Python code, CLI registration
- User command history: Local cache (opt-in)
- Model context: Maintains current project, working directory, active plugins

## User Interface Design Principles

- Command-first, with conversational context
- Progressive help and examples
- Interactive wizards for onboarding/configuration
- Always preview/destructively confirm

## Security Considerations

- Local-first; no default network calls or telemetry
- All remote API/model usage must be explicit/opt-in
- User-configurable plugin sandboxing

## Development Phases/Milestones

1. CLI scaffolding and basic command palette
2. Project analysis and context awareness
3. Local model (llama.cpp) integration
4. Python plugin system & manifest
5. YAML config loader and editor
6. Interactive help and onboarding wizard
7. Testing harness and dry-run mode
8. Remote inference and plugin discovery (future)

## Key Challenges & Solutions

- **LLM integration:** Abstracted interface for local/remote models; fallback support.
- **Plugin safety:** Manifest review, sandboxing for untrusted code.
- **Context window limits:** Smart chunking/summarization for big repos.
- **Cross-platform support:** Testing on major OSs; CI/CD.
- **User onboarding:** Interactive wizards and docs.

## Ideas for Future Expansion

- Plugin marketplace/discovery
- VSCode/web dashboard integration
- Team collaboration (shared config, cloud sync)
- Automated code review and PR integration

---

**If you’d like, I can further refine any section or generate checklists/examples for AI command grammar, response templates, etc.
Let me know what you want to flesh out next—or paste your current draft for a section-by-section review!**
