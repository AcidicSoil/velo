# Velo AI Code Style Guide (v1.0)

A unified code style standard for contributors building CLI AI assistants with `llama.cpp`, `DSPy`, `Typer`, `ruff`, and `MCP` on local environments.

---

## 1. General Code Practices

- **Encoding:** UTF-8 for all files
- **Line Length:** 100 characters max (120 allowed for special cases)
- **Indentation:** 2 spaces (TypeScript), 4 spaces (Python)
- **File Endings:** Always end with a newline
- **Whitespace:** No trailing spaces
- **Comments:** Prioritize docstrings over inline comments; use Google-style for Python
- **Documentation:** Required for all modules, classes, public functions

---

## 2. Naming Conventions

### TypeScript:
- `camelCase` for variables, functions
- `PascalCase` for classes, components, types, enums
- `UPPERCASE_SNAKE_CASE` for constants
- Prefix: `I` for interfaces, `T` for types, `E` for enums

### Python:
- `snake_case` for variables, functions, methods
- `PascalCase` for classes and exception names
- `UPPERCASE_SNAKE_CASE` for constants
- Module and file names: `lowercase_with_underscores`

---

## 3. Imports

### Order (both TS & Python):
1. Built-in modules
2. Third-party packages
3. Project-local imports
4. Type definitions/interfaces
5. Asset or config imports (TS)

- **TS:** Use single quotes, default export for main components, named for utilities
- **Python:** Use `import x` or `from x import y`; avoid `import *`

---

## 4. Python-Specific Practices

### Tooling:
- **uv** for virtual environments and dependencies
- **ruff** for linting and formatting

### Ruff Defaults:
- Enabled: ALL rules
- Ignored: E501 (line too long), D (docstring rules) *optionally*
- Preferred string quotes: double (`"`)
- Indentation: spaces

### Typing:
- Use full type hints everywhere
- Prefer `Path` from `pathlib` over raw strings for file paths

### Error Handling:
- Always use specific exception classes
- Gracefully degrade with fallback behaviors for expected errors

---

## 5. TypeScript + React Standards

- Use React functional components
- Use hooks, avoid class components
- Prefer destructuring props in function parameters
- Use Tailwind CSS for styling
- Only use `@apply` in Tailwind CSS when absolutely needed
- Follow mobile-first responsive design

---

## 6. CLI Code (Typer, Bash, Python)

- Python CLI apps must use `typer.Typer()` for commands
- CLI scripts follow `my_cli_app.py`, subcommands in `commands/`
- Each CLI command must:
  - Be documented
  - Validate all input types
  - Handle exceptions gracefully
  - Log errors to stderr
- Shell-safe output: never echo raw user input unescaped

---

## 7. DSPy Usage Standards

- Every `Signature` must define type hints for all fields
- All `Module` classes must:
  - Inherit from `dspy.Module`
  - Have a `forward` method with full typing
  - Be unit tested
- DSPy programs must:
  - Separate `Signatures`, `Modules`, and `Programs`
  - Include short inline docs for complex logic

---

## 8. AI Command Controls (Security)

- Default to `Command Allowlist` for shell usage:
  - Allow: `git`, `python`, `uv`, `ruff`, `ls`, `cd`, `pwd`, `cat`, `my_ai_cli`
  - Deny: `rm`, `sudo`, `curl`, `wget`, `docker`, `npm`
- Always enable:
  - File Deletion Protection
  - Dirtyfile Protection
  - External File Protection

---

## 9. Git & Collaboration

- Use feature branches, squash merge when possible
- Follow Conventional Commits
- All commits must:
  - Be imperative (`fix bug`, not `fixed bug`)
  - Reference issue/ticket IDs if relevant
- Use `.velo/` for project-local caches; ignore in Git

---

## 10. Testing & Validation

- All core logic must be covered by unit tests (use `pytest`)
- Use `mock` or `pytest-mock` for external service calls
- Test coverage must exceed 80%
- Use the `Arrange-Act-Assert` testing pattern

---

## 11. Bonus: LLM Integration Norms

- Always test `DSPy` pipelines with local `llama.cpp` before pushing
- Local LLM must be on port `8080` unless otherwise configured
- Ensure CLI still runs when LLM is down (fallback message)

---

## 12. Example Project Layout

```
my_ai_cli_project/
├── .velo/                  # Local AI cache (ignored in Git)
├── commands/               # CLI subcommand modules
│   ├── complete.py
│   └── explain.py
├── dspy_modules/           # DSPy Signatures and Modules
├── dspy_programs/          # Composed Programs
├── utils/                  # Utility helpers
├── tests/                  # All unit tests
├── pyproject.toml          # Ruff + UV config
└── my_cli_app.py           # Main entrypoint
```

---

## Final Notes

This guide consolidates internal DSPy/Typer practices with conventions from TensorBlock Studio and broader AI CLI engineering efforts. All new contributors should review this before submitting a pull request.
