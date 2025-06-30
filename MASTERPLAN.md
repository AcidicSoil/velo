---

project: velo
purpose: >
Velo is a conversational CLI agent designed to help developers analyze, generate, and automate tasks within project repositories. It provides context-aware suggestions, interactive wizards, and integrates with local and external developer tools, prioritizing privacy and extensibility.
target\_users:

* Software developers (Node.js, Python, TypeScript, Go, etc.)
* DevOps/SRE engineers
* Open-source project maintainers
  core\_features:
* Context-aware project analysis (detect frameworks, summarize structure)
* Command palette and interactive help (`velo help`)
* Code generation and templating (tests, configs, docs)
* AI-powered code explanation and refactoring
* DSPy-powered agentic plugin/extension system (Python, manifest-based)
* Local model serving (llama.cpp or llama-cpp-python), DSPy as Python agentic runtime
* Cross-compiling for different platforms
* YAML-based project configuration
* LLM/agent-based testing and automation
* Dry-run/preview mode for all commands
* Interactive onboarding wizard
* Accessibility and alternative output support
  commands:
* command: velo init
  description: Initialize a new velo project in the current directory.
  usage: velo init \[--template <name>] \[options]
* command: velo analyze \[target]
  description: Analyze codebase or directory, output a summary.
  usage: velo analyze src/
* command: velo generate test --for <file>
  description: Generate test skeleton for a given source file.
  usage: velo generate test --for src/main.ts
* command: velo explain <file>
  description: AI-powered code explanation.
  usage: velo explain src/utils/helpers.py
* command: velo help \[command]
  description: List available commands, flags, and usage examples.
  usage: velo help
* command: velo plugin \[install|list|remove|update]
  description: Manage plugins/extensions.
  usage: velo plugin install example-plugin
* command: velo config \[get|set|edit]
  description: Show or edit project configuration.
  usage: velo config get model
* command: velo test \[--all|<testfile>]
  description: Run LLM/agent test suite or dry-run actions.
  usage: velo test --all

# ...expand as features grow

extension\_points:

* Plugin system for new commands and behaviors (Python, DSPy-powered, manifest schema)
* Config templates (YAML)
* Custom command aliases and macros
* Extension points for model context and CLI hooks
  non\_goals:
* Velo is **not** a general-purpose shell or terminal replacement
* Does **not** store or transmit user code externally (unless user configures remote APIs)
* No built-in telemetry or analytics unless explicitly enabled by user
  integration\_points:
* Git (repo awareness, branch context)
* Docker (project containerization, optional)
* LLM inference (llama.cpp, OpenAI API \[optional/opt-in], DSPy agent runtime)
* Plugin marketplace/discovery \[future]
* VSCode/web dashboard \[future]
  data\_handling:
* Does not store or transmit user data without explicit user consent
* No default external telemetry
* Configuration stored in local YAML files
* Supports `.gitignore` and `.veloignore` for filtering project context
  security\_considerations:
* Local-first: no network calls or remote inference by default
* User must explicitly enable cloud/model APIs or telemetry
* Plugin sandboxing and manifest review (with clear warnings)
* API keys/secrets stored in local, user-controlled secure storage
  deployment\_targets:
* Local CLI (cross-platform: Linux, macOS, Windows)
* Docker image (for isolation and reproducibility)
* Future: Package manager install (brew, npm, pip, etc.)
  testing\_and\_automation:
* Integrated LLM/agent test framework, CLI-triggered
* Dry-run and preview modes
* Supports automated and manual agent testing flows
  user\_experience:
* Conversational, context-sensitive help and feedback
* Progressive help/examples, rich onboarding wizard
* Clear, actionable error messages and suggestions
* All output accessible to screen readers; alternative/verbose/quiet output flags
  extension\_points:
* Plugins/addons (Python/DSPy/TypeScript) can add commands, context processors, UI helpers
* Command/context templates for plugin authors
  positioning:
* Velo is most similar to gemini-cli in conversational, project-aware CLI workflow, but is fully local-first and extensible.
* Unlike Codex, Velo does not require cloud connectivity for core functionality.
* Designed to be AI agent-friendly—structured metadata supports rapid context ingestion, DSPy for agentic Python plugins.
  changelog:
* v0.1: Initial masterplan and CLI scaffolding.
* v0.2: Python plugin support, DSPy agentic logic.
* v0.3: Local model (llama.cpp) integration.
* v0.4: Accessibility, onboarding wizard, dry-run mode.
* v0.5: Enhanced agent context grammar and output format, DSPy plugin support.

# ...extend as needed

---

## Objectives

* Provide an extensible, conversational CLI agent for developer workflows.
* Prioritize privacy, local-first AI capabilities, and clear context for agentic use.
* Enable seamless extension with plugins and integrations (DSPy-powered for Python).
* Deliver actionable, previewable results for common coding and automation tasks.

## Problem Domain

Velo solves developer friction in multi-language, multi-tool repositories by offering an AI-powered, privacy-first CLI for project analysis, code generation, explanation, and automation—without requiring cloud access or complex configuration. Plugins leverage DSPy for advanced agentic behaviors in Python.

## Target Audience

* Individual developers (polyglot, open source, or enterprise)
* Teams with diverse codebases or DevOps needs
* Open-source maintainers and SREs

## High-Level Technical Stack

* CLI core: TypeScript
* Plugin system: Python (manifest-based, **DSPy for agentic plugin logic**), future TypeScript support
* Model serving: llama.cpp / llama-cpp-python (local-first), **DSPy as Python agentic runtime**
* Config: YAML (project root), cross-platform
* Packaging: Cross-compile for major OSs, Docker image
* Testing: LLM/agent test harness with dry-run

## Conceptual Data Model

* Project config: YAML (`velo.yaml`) – name, plugins, model config, aliases
* Plugins: Python scripts + manifest, **DSPy agent logic**, CLI registration
* Command history: Local, opt-in cache
* Model context: Current project, working dir, plugin state, active config

## User Interface Design Principles

* Command-first, conversational and progressive disclosure
* Interactive wizards for onboarding and configuration
* Accessible, preview-first UX (confirm before destructive actions)
* Output always compatible with screen readers and alternative formats

## Security Considerations

* Local-first, no network/telemetry by default
* Remote/cloud API/model use must be explicit and opt-in
* Plugin sandboxing and manifest review; plugins must be signed or approved
* Sensitive keys/secrets stored only in user-controlled local storage

## DSPy Plugin/Agent Design Approach

* **Start Simple:** Each DSPy-powered plugin or agent should begin as a single, well-scoped module—ideally a `dspy.ChainOfThought` or other basic DSPy module.
* **Incremental Complexity:** Only add additional modules, tools, or DSPy patterns as concrete user needs and plugin limitations are observed.
* **Programming First:** Define each plugin’s inputs and outputs clearly, using DSPy’s code-first (not prompt-first) approach to logic and data flow.
* **Examples Early:** For each plugin, try several representative input/output examples—capture both successful and challenging cases for future evaluation.
* **Evaluation Stage:** Once a DSPy-powered plugin or agent works, collect a development set, define a metric, and begin systematic iteration.
* **Optimization Last:** Only after reliable evaluation is established, use DSPy optimizers to tune prompts, weights, or module configuration.
* **Separation of Concerns:** Favor reusable DSPy modules—design plugins so LMs, adapters, or modules can be swapped with minimal logic changes.
* **Avoid Premature Optimization:** Don’t launch optimization or hyperparameter sweeps until your plugin logic and metrics are stable.

> **Tip:** This approach increases plugin maintainability, reproducibility, and portability—especially as models or objectives evolve.

## Development Phases/Milestones

1. CLI scaffolding, command palette, and help
2. Project analysis/context detection
3. Local model (llama.cpp) integration
4. Python plugin system (manifest-based, DSPy logic)
5. YAML config loader/editor
6. Interactive help and onboarding wizard
7. Testing harness and dry-run mode
8. Remote inference, plugin discovery/marketplace (future)
9. VSCode/web dashboard, cloud sync (future)

## Key Challenges & Solutions

* **LLM integration:** Abstract interface for local/remote models, with fallback. Leverage DSPy for advanced agentic workflows in plugins.
* **Plugin safety:** Manifest/signing, sandboxing for untrusted extensions.
* **Context window limits:** Smart chunking/summarization for large repos.
* **Cross-platform support:** CI/CD, pre-built binaries.
* **Onboarding:** Stepwise, interactive onboarding wizard.

## Ideas for Future Expansion

* Plugin marketplace/discovery (DSPy-powered agent plugins)
* VSCode/web dashboard integration
* Team collaboration (shared config, cloud sync, opt-in)
* Automated code review/PR integration

---

## Command Grammar Reference

* Format: `velo <command> [subcommand] [options] [arguments]`
* Flags: `--for <file>`, `--type <type>`, `--yes`, `--dry-run`, `--template <name>`
* Example: `velo generate test --for src/main.ts --dry-run`
* Chaining (planned): `velo analyze && velo generate test --for <file>`

---

## Agent Context & Chunking

* When analyzing large projects, split into logical units (files, folders, modules)
* Summarize each chunk individually before aggregating global results
* Use `.veloignore` and `.gitignore` to filter non-source assets

---

## Agent Output Requirements

* Use plain text for CLI unless Markdown/code block required
* Summarize findings, then list suggestions/next steps
* For ambiguous input, always ask clarifying questions before proceeding
* Require explicit user confirmation (`--yes` or prompt) for destructive actions
* Offer preview/dry-run output where possible
* For errors: Show actionable messages, suggest next step or `velo help`

---

## Model Routing (Local vs Remote)

* Prefer local model (llama.cpp, llama-cpp-python) for inference by default
* If local inference fails, prompt user to try remote/cloud model (if configured)
* Never transmit data externally unless user enables remote mode

---

## Versioning & Extension Handling

* On unknown command or plugin, suggest `velo plugin update` or `velo help`
* If config/schema version mismatches, offer to migrate or update config
* Warn on use of deprecated features, suggest alternatives

---

## Accessibility

* All CLI output supports screen readers
* Verbose and quiet output flags for user customization
* All commands and flags documented in `velo help`

---

## Testing Strategy

* All commands support `--dry-run` mode
* Automated tests for core workflows and agentic patterns
* LLM/agent integration tests on sample codebases and plugin flows (DSPy agent flows)

---

## Examples (Machine-Readable)

```yaml
examples:
  - user: velo help
    agent: |
      Here are common commands:
      - velo analyze [target]: Analyze codebase or directory
      - velo generate test --for <file>: Generate test skeleton
      - velo explain <file>: Explain code
  - user: velo analyze src/
    agent: |
      The src directory contains 12 files.
      - Detected frameworks: TypeScript, Node.js
      - Main modules: app.ts, utils/
  - user: velo explain main.py
    agent: |
      main.py defines a Flask web server with two routes:
      - /: Home
      - /api/data: Returns JSON data
      Suggestion: Add type hints for route handlers.
```

---

## Must-Have Features

* Context-aware CLI help (`velo help`)
* Local LLM integration (llama.cpp)
* Python plugin system (manifest-based, DSPy-powered)
* YAML config loader/editor
* Dry-run/preview mode
* Accessibility-first CLI output

## Nice-to-Have Features

* Remote inference (OpenAI, Gemini, etc.)
* Plugin marketplace/discovery (DSPy agent plugins)
* Interactive onboarding wizard
* VSCode/web dashboard integration
* Team collaboration features

---

## Future Expansion

* Opt-in cloud sync for configs/plugins
* Web dashboard for analytics and plugin management
* Integrated code review and PR generation
* Advanced agentic workflows and macros (DSPy-based)
