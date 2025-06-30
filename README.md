# Velo

Velo is a conversational CLI agent designed to help developers analyze, generate, and automate tasks within project repositories. It provides context-aware suggestions, interactive wizards, and integrates with local and external developer tools, prioritizing privacy and extensibility.

---

## Table of Contents

* [Overview](#overview)
* [Features](#features)
* [Getting Started](#getting-started)
* [Core Commands](#core-commands)
* [Extension Points](#extension-points)
* [Integrations](#integrations)
* [Security & Privacy](#security--privacy)
* [Development Approach](#development-approach)
* [Roadmap & Milestones](#roadmap--milestones)
* [Contributing](#contributing)
* [License](#license)

---

## Overview

Velo solves developer friction in multi-language, multi-tool repositories by offering an AI-powered, privacy-first CLI for project analysis, code generation, explanation, and automation—without requiring cloud access or complex configuration. Plugins leverage DSPy for advanced agentic behaviors in Python.

**Target Users:**

* Software developers (Node.js, Python, TypeScript, Go, etc.)
* DevOps/SRE engineers
* Open-source project maintainers

---

## Features

* Context-aware project analysis (framework detection, summarization)
* Conversational command palette and interactive help (`velo help`)
* AI-powered code explanation and refactoring
* Code and config generation (tests, templates, docs)
* Python plugin system powered by DSPy
* Local LLM integration (llama.cpp or llama-cpp-python)
* Cross-platform CLI (Linux, macOS, Windows)
* YAML-based project configuration
* Agentic plugin/extension system (Python, manifest-based)
* Dry-run/preview mode for all commands
* Interactive onboarding wizard
* Accessibility-first CLI output
* No default telemetry or data exfiltration

---

## Getting Started

### 1. Installation

* **Build from source:**

  ```bash
  git clone https://github.com/your-org/velo.git
  cd velo
  # Follow platform-specific build instructions
  ```
* **Pre-built binaries (coming soon):** Linux, macOS, Windows
* **Docker image (optional):**

  ```bash
  docker run -it --rm velo/cli
  ```

### 2. Initialize a Project

```bash
velo init [--template <name>] [options]
```

### 3. Common Workflows

* Analyze project structure:

  ```bash
  velo analyze src/
  ```
* Generate test skeleton:

  ```bash
  velo generate test --for src/main.ts
  ```
* AI-powered code explanation:

  ```bash
  velo explain src/utils/helpers.py
  ```
* Run CLI help:

  ```bash
  velo help
  ```

---

## Core Commands

| Command                           | Description                                |                                           |                                    |                           |
| --------------------------------- | ------------------------------------------ | ----------------------------------------- | ---------------------------------- | ------------------------- |
| `velo init`                       | Initialize a new velo project              |                                           |                                    |                           |
| `velo analyze [target]`           | Analyze codebase or directory              |                                           |                                    |                           |
| `velo generate test --for <file>` | Generate test skeleton for a file          |                                           |                                    |                           |
| `velo explain <file>`             | AI-powered code explanation                |                                           |                                    |                           |
| `velo help [command]`             | List available commands and usage examples |                                           |                                    |                           |
| \`velo plugin \[install           | list                                       | remove                                    | update]\`                          | Manage plugins/extensions |
| \`velo config \[get               | set                                        | edit]\`                                   | Show or edit project configuration |                           |
| \`velo test \[--all               | <testfile>]\`                              | Run agentic test suite or dry-run actions |                                    |                           |

---

## Extension Points

* **Plugin system:** Python (DSPy agentic plugins), manifest-based
* **Config templates:** YAML
* **Command aliases/macros**
* **Custom CLI hooks and context processors**

---

## Integrations

* **Git:** Repo awareness, branch context
* **Docker:** Project containerization (optional)
* **LLM:** Local model inference (llama.cpp/llama-cpp-python); remote (OpenAI API, opt-in)
* **VSCode/Web dashboard:** (planned)

---

## Security & Privacy

* Local-first: No network calls or data transmission by default
* No telemetry unless explicitly enabled by user
* User-controlled config (YAML) and secure local storage for secrets
* Plugins sandboxed and reviewed (manifest required)
* `.gitignore` and `.veloignore` supported for filtering project context

---

## Development Approach

* Start simple, expand incrementally (DSPy-powered plugins start as single modules)
* Focus on code-first, not prompt-first plugin logic
* Test on representative examples before optimization
* Use dry-run/preview modes and actionable errors throughout
* Accessibility, clarity, and onboarding prioritized in all UX

---

## Roadmap & Milestones

1. CLI scaffolding, command palette, and help
2. Project analysis/context detection
3. Local model (llama.cpp) integration
4. Python plugin system (manifest-based, DSPy logic)
5. YAML config loader/editor
6. Interactive onboarding wizard
7. Testing harness and dry-run mode
8. Remote inference and plugin discovery (future)
9. VSCode/web dashboard, cloud sync (future)

---

## Contributing

* Pull requests and plugin ideas are welcome!
* See `CONTRIBUTING.md` (coming soon) for guidelines
* For feature requests, open a GitHub issue or start a discussion

---

## License

MIT License (see `LICENSE`)

---

## Credits

* Inspired by gemini-cli, Codex CLI, and the DSPy ecosystem
