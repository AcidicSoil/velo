# Gemini-CLI Agent Rules

**TL;DR:** Essential rules and workflows for Gemini models powering gemini-cli.

---

## Core Principles

* **Readability first:** Favor clear, direct code over cleverness
* **Minimal dependencies:** Only use external packages when essential
* **Unix-like UX:** Predictable flags, stdin/stdout, exit codes, scriptability
* **Consistency beats novelty:** Conform to existing patterns

---

## Agent Behavior Standards

### Code Generation
* Use snake_case for files, functions, variables
* Use UpperCamelCase for class names
* Keep functions ≤ 40 lines
* Generate explicit error handling that fails fast
* Always add/update tests when altering behavior
* Prefix commit messages with semantic type (`feat:`, `fix:`, etc.)

### CLI Interactions
* Generate examples with both short (`-f`) and long (`--flag`) forms
* Output examples with `$` prefix for commands
* Never leak secrets in logs or error messages
* Respect environment variables: `GEMINI_API_KEY`, `GEMINI_PROFILE`
* Use exit codes: 0=success, 1=usage error, 2=API/network failure

### Security & Privacy
* Always redact/mask secrets in code, docs, and logs
* Never suggest hard-coding sensitive values
* Use `<YOUR_API_KEY>` placeholders in examples
* Never recommend disabling security checks

### Documentation & Testing
* Always generate/update docstrings and usage examples
* Suggest test cases for new flags or parameters
* Never bypass linters or skip CI steps
* Flag missing/outdated docs in PR summaries

### Change Management
* Return patch-ready, minimal diffs unless asked for alternatives
* Suggest branch names matching change type (`feat/`, `fix/`, etc.)
* Never suggest direct pushes to `main`
* Summarize backward-incompatible changes in PR descriptions

---

## Environment Integration

### devcontext Integration
* Check if relevant context/tools exist in [devcontext](https://github.com/aiurda/devcontext) before suggesting changes
* Prefer devcontext-based solutions over custom scripts
* Reference devcontext resources when handling environment/configuration tasks

### Profile Management
* Always respect active profile settings unless explicitly overridden
* Never suggest hard-coding sensitive values
* Use config profiles for API keys, models, and defaults

---

## Workflow Essentials

### For AI-Assisted Development
* Return patch-ready, minimal diffs unless asked for alternatives
* Always explain "why" if non-obvious, not just "what"
* Generate error handling that fails fast and loudly
* Never introduce logging side-effects in libraries

### Quality Assurance
* All code changes require corresponding tests
* Tests must be reproducible and not depend on external APIs
* Lint compliance is mandatory
* Documentation updates required for user-facing changes

---

## Glossary

* **Profile:** Config set for API/model settings
* **Temperature:** Controls randomness in AI output
* **Max Tokens:** Limits output length
* **Smoke Test:** Minimal test for basic operation
* **devcontext:** Repository for shared developer environment standards

---

> ⚠️ Always consult .cursorrules and .cursor/rules/* for additional project-specific rules