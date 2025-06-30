
```markdown
# AGENTS.md — Velo AI Agent Guide

**TL;DR:** This guide defines how AI agents collaborate to develop, test, and document *velo*—always favor clarity, minimalism, and consistency.

---

## Project Overview

**Velo** is a privacy-first, conversational CLI tool for developers that assists with:
- Project analysis and AI-generated code
- Refactoring, testing, and config templating
- Agentic Python plugins powered by DSPy
- **Core Principles**: Local execution, dry-run mode, accessibility-first UX

### Project Structure
```
/
├── src/          # Core implementation (Rust/Go/Python/TS)
├── plugins/      # DSPy-based extension points (Python)
├── velo/         # CLI scaffolding & commands
├── examples/     # Sample projects and use cases
├── README.md     # Overview and usage guide
├── AGENTS.md     # AI agent instructions
└── .veloignore   # Filter for agent context extraction
```

---

## Repository Philosophy

- **Clarity first**: Prioritize readable, maintainable code over cleverness
- **Minimal dependencies**: Favor built-ins and standard tools
- **Unix-like ethos**: Compose small, focused utilities that do one thing well
- **Portable by default**: Write cross-platform code unless OS-specific
- **Explicit over implicit**: Prefer code that makes behavior obvious

---

## AI Agent Requirements

### Core Capabilities
AI agents must be capable of:

1. **Code Analysis**: Understanding project structure (`src/`, `plugins/`, CLI entrypoints)
2. **Code Generation**: Creating new functionality or plugins using DSPy format
3. **Documentation**: Explaining existing components and generating clear docstrings
4. **Refactoring**: Preserving style while adding type annotations and improvements
5. **Testing**: Generating tests that follow existing patterns in `examples/`
6. **Dry-run Awareness**: Generating code without executing side-effects
7. **Privacy Compliance**: No telemetry or unauthorized network traffic

### Output Requirements
- **Always respond with unified diffs or complete file rewrites**, not plain code snippets
- **Generate commit messages** that summarize *what* and *why*
- **Flag potential breaking changes**, security risks, or required follow-ups
- **Title PRs** with conventional format: `feat(...)`, `fix(...)`, `refactor(...)`

---

## Code Standards

### Naming Conventions
- Functions/variables: `lower_case_with_underscores`
- Types/classes: `UpperCamelCase`
- Environment variables: `VELO_` prefix (e.g., `VELO_CONFIG`)

### CLI Standards
- **Flags**: Long-form, dashed (`--verbose`, `--dry-run`). Short flags (`-v`) only for common options
- **Output**: Default to human-readable. Use `--json` or `--quiet` for machine-friendly modes
- **Help**: Hierarchical pattern: main command → subcommands → flags

### Code Quality
- **Comments**: Explain *why*, not *what*—avoid obvious restatements
- **Error Handling**: Fail fast with actionable error messages
- **Logging**: Structured, level-based (debug, info, warn, error)
- **Style**: Follow existing file patterns and language idioms
- **Configuration**: YAML-based for plugin definitions and CLI metadata

---

## Testing & Documentation

### Testing Requirements
- **Unit Tests**: Required for all new features and bug fixes
- **Smoke Tests**: Each CLI command needs end-to-end invocation test
- **Test Commands**:
  ```bash
  velo test        # Unified test runner
  cargo test       # Rust
  npm test         # TypeScript
  pytest           # Python plugins
  ```

### Documentation Standards
- **Docstrings**: Required for all exported functions, classes, and modules
- **README Updates**: Required for CLI interface or major behavior changes
- **Man Pages**: All top-level commands and major flags must be documented

---

## Security & Privacy

### Critical Requirements
- **Never hard-code secrets, tokens, or credentials**
- **All secrets via environment variables** with `VELO_` prefix
- **No secrets in configuration files** (must be git-excluded)
- **Minimal, opt-in telemetry only** with documented data collection
- **Respect `--local` and dry-run flags** - no unauthorized remote API calls

---

## Development Workflow

### Change Management
- **Branch naming**: `feature/short-desc` or `fix/short-desc`
- **Semantic versioning**: Follow [SemVer](https://semver.org/)
- **PR Checklist**:
  - [ ] Code is tested and linted
  - [ ] Documentation updated
  - [ ] Follows naming and CLI conventions
  - [ ] No secrets or sensitive info leaked
  - [ ] Breaking changes flagged

### Agent Constraints
- **Plugin loading is sandboxed** - follow manifest format in `plugins/`
- **Avoid modifying** `README.md`, `.veloignore`, or config files unless explicitly instructed
- **Use examples/** as reference implementations for patterns
- **Generate both code and associated tests** for all functionality

---

## Quick Reference

| Term | Definition |
|------|------------|
| Codex | AI coding agent contributing to this repo |
| Patch | Unified diff or code change proposal |
| Smoke Test | Basic functional test simulating real CLI usage |
| DSPy | Framework for agentic Python plugins |
| Dry-run | Generate/analyze without side-effects |

---

**By following this guide, AI agents can effectively maintain code quality, expand the plugin system, refine CLI behaviors, and ensure secure defaults.**
```

## **Key Improvements:**

1. **Eliminated Redundancy**: Consolidated two document structures into one coherent guide
2. **AI-Focused**: Prioritized information specifically relevant to AI agents
3. **Actionable Requirements**: Clear, specific instructions rather than general guidance
4. **Better Organization**: Logical flow from overview → requirements → standards → workflow
5. **Quick Reference**: Added glossary for fast lookups
6. **Consistency**: Unified formatting and structure throughout
7. **Reduced Length**: Cut ~40% of content while preserving all essential information

This cleaned-up version provides a much more efficient reference for OpenAI Codex agents while maintaining all critical information for effective collaboration.

```markdown
# AGENTS.md — Velo AI Agent Guide

**TL;DR:** This guide defines how AI agents collaborate to develop, test, and document *velo*—always favor clarity, minimalism, and consistency.

---

## Project Overview

**Velo** is a privacy-first, conversational CLI tool for developers that assists with:
- Project analysis and AI-generated code
- Refactoring, testing, and config templating
- Agentic Python plugins powered by DSPy
- **Core Principles**: Local execution, dry-run mode, accessibility-first UX

### Project Structure
```

```plaintext

---

## Repository Philosophy

- **Clarity first**: Prioritize readable, maintainable code over cleverness
- **Minimal dependencies**: Favor built-ins and standard tools
- **Unix-like ethos**: Compose small, focused utilities that do one thing well
- **Portable by default**: Write cross-platform code unless OS-specific
- **Explicit over implicit**: Prefer code that makes behavior obvious

---

## AI Agent Requirements

### Core Capabilities
AI agents must be capable of:

1. **Code Analysis**: Understanding project structure (`src/`, `plugins/`, CLI entrypoints)
2. **Code Generation**: Creating new functionality or plugins using DSPy format
3. **Documentation**: Explaining existing components and generating clear docstrings
4. **Refactoring**: Preserving style while adding type annotations and improvements
5. **Testing**: Generating tests that follow existing patterns in `examples/`
6. **Dry-run Awareness**: Generating code without executing side-effects
7. **Privacy Compliance**: No telemetry or unauthorized network traffic

### Output Requirements
- **Always respond with unified diffs or complete file rewrites**, not plain code snippets
- **Generate commit messages** that summarize *what* and *why*
- **Flag potential breaking changes**, security risks, or required follow-ups
- **Title PRs** with conventional format: `feat(...)`, `fix(...)`, `refactor(...)`

---

## Code Standards

### Naming Conventions
- Functions/variables: `lower_case_with_underscores`
- Types/classes: `UpperCamelCase`
- Environment variables: `VELO_` prefix (e.g., `VELO_CONFIG`)

### CLI Standards
- **Flags**: Long-form, dashed (`--verbose`, `--dry-run`). Short flags (`-v`) only for common options
- **Output**: Default to human-readable. Use `--json` or `--quiet` for machine-friendly modes
- **Help**: Hierarchical pattern: main command → subcommands → flags

### Code Quality
- **Comments**: Explain *why*, not *what*—avoid obvious restatements
- **Error Handling**: Fail fast with actionable error messages
- **Logging**: Structured, level-based (debug, info, warn, error)
- **Style**: Follow existing file patterns and language idioms
- **Configuration**: YAML-based for plugin definitions and CLI metadata

---

## Testing & Documentation

### Testing Requirements
- **Unit Tests**: Required for all new features and bug fixes
- **Smoke Tests**: Each CLI command needs end-to-end invocation test
- **Test Commands**:
  ```bash
  velo test        # Unified test runner
  cargo test       # Rust
  npm test         # TypeScript
  pytest           # Python plugins
  ```

### Documentation Standards
- **Docstrings**: Required for all exported functions, classes, and modules
- **README Updates**: Required for CLI interface or major behavior changes
- **Man Pages**: All top-level commands and major flags must be documented

---

## Security & Privacy

### Critical Requirements
- **Never hard-code secrets, tokens, or credentials**
- **All secrets via environment variables** with `VELO_` prefix
- **No secrets in configuration files** (must be git-excluded)
- **Minimal, opt-in telemetry only** with documented data collection
- **Respect `--local` and dry-run flags** - no unauthorized remote API calls

---

## Development Workflow

### Change Management
- **Branch naming**: `feature/short-desc` or `fix/short-desc`
- **Semantic versioning**: Follow [SemVer](https://semver.org/)
- **PR Checklist**:
  - [ ] Code is tested and linted
  - [ ] Documentation updated
  - [ ] Follows naming and CLI conventions
  - [ ] No secrets or sensitive info leaked
  - [ ] Breaking changes flagged

### Agent Constraints
- **Plugin loading is sandboxed** - follow manifest format in `plugins/`
- **Avoid modifying** `README.md`, `.veloignore`, or config files unless explicitly instructed
- **Use examples/** as reference implementations for patterns
- **Generate both code and associated tests** for all functionality

---

## Quick Reference

| Term | Definition |
|------|------------|
| Codex | AI coding agent contributing to this repo |
| Patch | Unified diff or code change proposal |
| Smoke Test | Basic functional test simulating real CLI usage |
| DSPy | Framework for agentic Python plugins |
| Dry-run | Generate/analyze without side-effects |

---

**By following this guide, AI agents can effectively maintain code quality, expand the plugin system, refine CLI behaviors, and ensure secure defaults.**
```
