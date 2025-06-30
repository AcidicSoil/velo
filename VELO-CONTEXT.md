# Velo Project Context for Gemini-CLI

Context and instructions for using Gemini-CLI with the Velo project.

---

## About Velo

**Velo** is a privacy-first, agentic CLI tool that helps developers analyze, generate, and automate workflows within project repositories using DSPy-based Python plugins and local LLMs.

---

## Project Structure

* `velo/` - CLI commands and core functionality
* `plugins/` - Extension points and plugin system
* `src/` - Core application logic
* `tests/` - Test suites and validation

---

## Core Capabilities

### CLI Introspection
* Use `velo help` to explore available commands and flags
* Support for output templates and structured responses

### Plugin System
* Manifest-based, DSPy agentic Python plugin architecture
* Required fields: `name`, `description`, `entrypoint`, API hooks
* Plugin discovery and lifecycle management

### Development Workflow
* `velo generate test --for <file>` - Scaffold test files
* `--dry-run` mode for safe preview of changes
* Local-first operation with minimal external dependencies

---

## Design Constraints

* **Local-first:** Avoid cloud calls; assume limited internet access
* **Privacy-first:** No telemetry or data collection permitted
* **Cross-platform:** Consistent behavior on Linux, macOS, Windows
* **Agentic:** Support for autonomous operation and decision-making

---

## Common Tasks

### Plugin Development
```bash
# Scaffold new plugin
velo plugin create hello-world-plugin

# Generate plugin tests
velo generate test --for plugins/hello_world/plugin.py

# Validate plugin manifest
velo plugin validate plugins/hello_world/manifest.yaml
```

### Code Analysis
```bash
# Explain code behavior
velo explain velo/config.py

# Generate documentation
velo doc generate --for src/core/

# Dry-run formatting changes
velo format --dry-run src/
```

---

## Communication Guidelines

* **Concise explanations** with clear reasoning
* **Step-by-step guidance** for multi-step processes
* **Code snippets** in appropriate language/format
* **Error remediation** suggestions when commands fail
* **Context-aware** responses based on project state

---

## Integration Notes

When assisting with Velo development:
1. Prioritize local-first solutions
2. Respect privacy constraints
3. Maintain cross-platform compatibility
4. Support dry-run workflows
5. Focus on plugin ecosystem extensibility