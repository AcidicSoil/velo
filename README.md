````markdown
# velo

<!--
Velo is a conversational, privacy-first CLI agent for developers.
It offers project analysis, code generation, explanation, and automation—locally, with extensible plugins and a consistent, AI-friendly interface.
-->

---

## 🚀 Overview

<!--
Describe what Velo is, its philosophy, and who it’s for.
-->
Velo is a **conversational CLI agent** designed for developers and DevOps engineers. It automates code analysis, generation, refactoring, and project setup, using local AI models and an extensible plugin system. Velo prioritizes privacy, speed, and context-awareness—no cloud connection needed for core features.

---

## ✨ Key Features

<!--
Bullet out what makes velo special and what’s included.
-->
- Context-aware project analysis (detect frameworks, summarize structure)
- Interactive help and command palette (`velo help`)
- Code generation (tests, configs, docs) with local LLM
- AI-powered code explanation and refactoring
- Plugin/extension system (Python plugins, manifest-based)
- YAML-based project configuration
- Cross-platform CLI (Linux, macOS, Windows) and Docker support
- Dry-run/preview mode for all commands
- Onboarding wizard and accessibility-first output

---

## 🏁 Quickstart

<!--
Show a minimal install/build/run sequence.
-->
```shell
# 1. Install (after downloading or cloning repo)
npm install   # or yarn install

# 2. Initialize a velo project
velo init

# 3. See available commands and options
velo help

# 4. Analyze your codebase
velo analyze src/

# 5. Generate tests for a file
velo generate test --for src/main.ts --dry-run
````

---

## 🧩 Plugin System

<!--
Describe plugin capabilities and extension points.
-->

Velo supports Python plugins via a manifest schema.

* Add custom commands, context processors, or automations.
* See `velo plugin install <plugin-name>` and documentation for authoring.

---

## 🛠️ Core Commands

<!--
Show most important commands in a structured table.
-->

| Command                           | Description                      |                                 |                                    |                           |
| --------------------------------- | -------------------------------- | ------------------------------- | ---------------------------------- | ------------------------- |
| `velo init`                       | Initialize a new project         |                                 |                                    |                           |
| `velo analyze [target]`           | Analyze codebase or directory    |                                 |                                    |                           |
| `velo generate test --for <file>` | Generate test skeleton for file  |                                 |                                    |                           |
| `velo explain <file>`             | Explain code with LLM            |                                 |                                    |                           |
| \`velo plugin \[install           | list                             | remove                          | update]\`                          | Manage plugins/extensions |
| \`velo config \[get               | set                              | edit]\`                         | Show or edit project configuration |                           |
| \`velo test \[--all               | <testfile>]\`                    | Run agent test suite or dry-run |                                    |                           |
| `velo help [command]`             | Show help, flags, usage examples |                                 |                                    |                           |

---

## ⚡ Examples

<!--
Give machine-readable CLI:agent conversation pairs.
-->

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

## 🔒 Security & Privacy

<!--
Be explicit: what velo does NOT do, and how it handles data.
-->

* **Local-first:** No cloud, no telemetry, unless you opt in
* **User control:** API keys/secrets are stored locally and securely
* **Sandboxed plugins:** Only run trusted or reviewed code

---

## 🧑‍💻 Technical Stack

<!--
Call out the major technologies for devs.
-->

* TypeScript CLI core
* Python plugin system (manifest-based)
* Local model serving: llama.cpp / llama-cpp-python
* YAML configuration

---

## 🧭 Roadmap & Contribution

<!--
Short roadmap and contribution guide.
-->

Planned:

* Remote LLM support (OpenAI, Gemini, etc.) \[opt-in]
* Plugin marketplace and VSCode/web dashboard integration
* Team collaboration, cloud sync, advanced workflows

Want to contribute?

* See [CONTRIBUTING.md](./CONTRIBUTING.md) and open an issue or PR!
* Suggest new plugins or core features

---

## 📖 Documentation

<!--
Link to key docs (expand as needed).
-->

* [Masterplan](./MASTERPLAN.md)
* [Plugin Authoring Guide](./docs/plugins.md)
* [Configuration Reference](./docs/config.md)

---

## 🏷 License

<!--
Insert your license type here.
-->

MIT License

---

<!--
End of README. For detailed technical specs and agent behaviors, see MASTERPLAN.md.
-->

```
```
