Great decision to clarify your stack early—**switching to TypeScript** will make your CLI more approachable for many devs and speed up plugin/extension work, especially with strong typing and NPM ecosystem.

You *can* share the old Go version if you’d like targeted migration tips, but it’s not required for a new `README.md`. I’ll generate a README that is **aligned with your masterplan.md, reflects a TypeScript-first project**, and sets clear expectations for users and contributors (including AI/LLM assistant context).

---

## AI-Optimized `README.md` for Velo

````markdown
# Velo

**Velo** is a conversational CLI assistant for developers, designed to automate, analyze, and enhance coding workflows using AI and modern language tooling. Powered by a local-first architecture, Velo combines the flexibility of TypeScript with a Python-based plugin system and optional LLM integration.

---

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Commands](#commands)
- [Plugin System](#plugin-system)
- [Configuration](#configuration)
- [AI & Model Integration](#ai--model-integration)
- [Development](#development)
- [Security & Privacy](#security--privacy)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Conversational CLI:** Natural-language and command-driven interface for codebase analysis, code generation, and automation.
- **Context Awareness:** Auto-detects project type, frameworks, and tooling.
- **Extensible Plugins:** Python-based plugin system for custom commands and workflows.
- **Local LLM Integration:** Runs with local models (llama.cpp/llama-cpp-python) for private, fast inferencing.
- **YAML Configuration:** Flexible, human-readable project and user config.
- **Cross-Platform:** Works on Windows, macOS, and Linux. Supports Docker.
- **Dry-run/Preview Mode:** Safely test commands before applying changes.
- **First-class TypeScript Support:** All core CLI functionality is written in TypeScript for maintainability and speed.

---

## Quick Start

1. **Install Velo CLI**
   ```sh
   npm install -g velo-cli
   # or via Docker:
   # docker run --rm -it -v $PWD:/repo acidicsoil/velo
````

2. **Initialize Velo in Your Project**

   ```sh
   velo init
   ```

3. **See Available Commands**

   ```sh
   velo help
   ```

4. **Analyze Your Codebase**

   ```sh
   velo analyze src/
   ```

---

## Commands

| Command                           | Description                                |
| --------------------------------- | ------------------------------------------ |
| `velo init`                       | Initialize a new Velo project              |
| `velo analyze [target]`           | Analyze codebase, output structure/summary |
| `velo generate test --for <file>` | Generate a test skeleton for a file        |
| `velo explain <file>`             | Get an AI-powered explanation of code      |
| `velo help`                       | List available commands and options        |
| *See plugin docs for more...*     |                                            |

**All commands support `--dry-run` for safe previews.**

---

## Plugin System

* **Write Plugins in Python:** Extend Velo with new commands and integrations.
* **Manifest-Based:** Simple manifest schema for easy registration.
* **Examples and API:** See [`docs/plugins.md`](docs/plugins.md) for how to get started.

---

## Configuration

* **Project-level config:** `.velo.yml` in your repo root.
* **User config:** `~/.config/velo/config.yml`
* **Settings:** Models, plugins, command aliases, and more.
* **Sample:**

  ```yaml
  model: llama.cpp
  plugins:
    - name: custom-linter
      path: ./plugins/custom-linter.py
  ```

---

## AI & Model Integration

* **Local-first:** Uses [llama.cpp](https://github.com/ggerganov/llama.cpp) or [llama-cpp-python](https://github.com/abetlen/llama-cpp-python).
* **Remote/Cloud optional:** Can connect to OpenAI, Gemini, or other APIs if enabled.
* **Privacy:** No code or data leaves your machine unless explicitly configured.

---

## Development

* **Language:** TypeScript (core CLI), Python (plugins)
* **Requirements:** Node.js (>=18), Python 3.8+ (for plugins), [llama.cpp](https://github.com/ggerganov/llama.cpp) optional for local models.
* **Setup:**

  ```sh
  git clone https://github.com/AcidicSoil/velo.git
  cd velo
  npm install
  # (optional) python -m venv venv && source venv/bin/activate
  ```
* **Run Tests:**

  ```sh
  npm test
  # Plugin/LLM testing: see docs/tests.md
  ```

---

## Security & Privacy

* **Local-first:** No external calls or telemetry by default.
* **User Control:** All remote model/API usage is opt-in via config.
* **Sandboxed Plugins:** Plugins run with limited access by default.
* **For more, see [SECURITY.md](SECURITY.md).**

---

## Roadmap

* [x] CLI scaffolding and TypeScript migration
* [x] Context-aware project analysis
* [x] Local LLM integration
* [ ] Python plugin system
* [ ] YAML config management
* [ ] Interactive onboarding wizard
* [ ] Marketplace for plugins/extensions

See [masterplan.md](masterplan.md) for full vision and milestones.

---

## Contributing

Velo welcomes contributors!
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines and [masterplan.md](masterplan.md) for architecture and feature planning.

* **Bugs/Requests:** Use [GitHub Issues](https://github.com/AcidicSoil/velo/issues)
* **Discussions:** Join us in [Discussions](https://github.com/AcidicSoil/velo/discussions)

---

## License

MIT (see [LICENSE](LICENSE))

---

## Example Usage

```sh
velo init
velo analyze src/
velo generate test --for src/main.ts
velo explain app.py
```

---

> **For AI assistants and LLM integrations:**
> Please refer to [masterplan.md](masterplan.md) for context, design philosophy, and up-to-date feature definitions.

---
