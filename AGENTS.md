**TL;DR:**
This guide defines how humans and AI agents collaborate to develop, test, and document *velo*—always favor clarity, minimalism, and consistency.

---

## Purpose & Scope

AGENTS.md is the style and process guide for all contributors—human or AI—working on *velo*.
Consult this document *before* opening a PR, writing code, or proposing significant changes.
This is the single source of truth for repo-wide conventions, coding practices, and collaboration rules.

---

## Repository Philosophy

* **Clarity first:** Prioritize readable, maintainable code over cleverness.
* **Minimal dependencies:** Favor built-ins and standard tools.
* **Unix-like ethos:** Compose small, focused utilities that do one thing well.
* **Portable by default:** Write cross-platform code unless a feature is OS-specific.
* **Explicit over implicit:** Prefer code that makes behavior obvious.

---

## Ask vs Code Modes

* **Ask Mode:**
  Use natural language to request design, troubleshooting, or architectural guidance.

  ```bash
  # Example prompt:
  How should I structure the plugin API for new transport backends?
  ```

* **Code Mode:**
  Request or provide concrete code changes, patches, or file rewrites.

  ```bash
  # Example prompt:
  Add a --json flag to the 'velo status' command to output machine-readable results.
  ```

---

## Coding Standards

* **Naming:**
  Use descriptive, consistent, and lower\_case\_with\_underscores for functions/variables.
  Use UpperCamelCase for types and classes.
* **Comments:**
  Explain *why*, not *what*—but do not restate the obvious.
* **Error Handling:**
  Fail fast and loudly. Surface actionable error messages to users.
* **Logging:**
  Use structured, level-based logging (e.g., debug, info, warn, error). Avoid print-debugging.
* **Formatting:**
  Follow the repo’s formatter and linter configuration—no exceptions.

---

## CLI Specifics

* **Flag Naming:**
  Prefer long-form, dashed flags (e.g., `--verbose`, `--dry-run`).
  Short flags (`-v`) only for very common options.
* **Output Format:**
  Default to human-readable output. Use `--json` or `--quiet` for machine/script-friendly modes.
* **Environmental Variables:**
  Document and prefix all environment variables with `VELO_` (e.g., `VELO_CONFIG`).

---

## AI-Assisted Workflow

* **For Humans:**

  * Write clear, focused prompts—one topic per request.
  * Specify context (file, function, command) for code changes.
  * Review and test AI-generated patches before merging.
* **For Codex:**

  * Always respond with unified diffs or complete file rewrites, not plain code snippets.
  * Suggest commit messages that summarize *what* and *why*.
  * Title PRs with a one-line change summary.
  * Flag potential breaking changes, security risks, or required follow-ups.

---

## Testing & CI

* **Unit Tests:**
  Required for all new features and bug fixes.
* **Smoke Tests:**
  Each CLI command must have at least one end-to-end invocation test.
* **Linting:**
  Pass all CI checks and linting before merging.

> ⚠️ Do not bypass tests or CI for quick fixes—file an issue if urgent.

---

## Documentation Requirements

* **README:**
  Update whenever CLI interface, usage, or major behavior changes.
* **Man Pages:**
  All top-level commands and major flags must have up-to-date documentation.
* **In-file Docstrings:**
  Each exported function, class, and module requires a concise docstring.

---

## Security & Privacy

* **Secrets Management:**
  Never hard-code secrets, tokens, or credentials.
  All secrets must be passed via environment variables prefixed with `VELO_`.
  Do not store secrets in configuration files.
* **Configuration:**
  All secrets must be passed via environment variables or config files (excluded from git).
* **Telemetry:**
  Collect only minimal, opt-in telemetry. Always document data collection.

---

## Change Management

* **Branching Model:**
  Use `main` for stable releases.
  Feature and fix branches: `feature/short-desc` or `fix/short-desc`.
* **Semantic Versioning:**
  Follow [SemVer](https://semver.org/) for all releases.
* **PR Checklist:**

  * [ ] Code is tested and linted
  * [ ] Docs are updated
  * [ ] Follows naming and CLI conventions
  * [ ] No secrets or sensitive info leaked

---

## Appendix

| Term                         | Definition                                            |
| ---------------------------- | ----------------------------------------------------- |
| Codex                        | The AI coding agent contributing to this repo         |
| Patch                        | A unified diff or code change proposal                |
| Smoke Test                   | Basic functional test simulating real CLI usage       |
| Semantic Versioning (SemVer) | Versioning format: MAJOR.MINOR.PATCH                  |
| Man Page                     | Unix-style CLI reference, typically generated per cmd |

---
