# Velo AI Code Style Guide (v1.1)

*Last updated 2025‑06‑27*

Unified engineering standards for contributors building **local, container‑friendly AI CLI assistants** with `llama.cpp`, **DSPy**, **Typer**, **ruff**, and **MCP**.

---

## 1  General Code Practices

| Rule | Setting |
|------|---------|
| **Encoding** | UTF‑8 for every file |
| **Line length** | 100 chars max (soft‑wrap at 88 via `ruff`) |
| **Indentation** | 2 spaces (TypeScript), 4 spaces (Python) |
| **File endings** | Always end files with a single newline |
| **Whitespace** | No trailing spaces; use blank lines for logical grouping |
| **Comments** | Prefer *Google‑style* docstrings over inline comments; comment **why**, not *what* |
| **Documentation** | Module, class & public function docstrings are mandatory |
| **Tool versions** | Target **Python 3.11+**, **Node ≥ 20** |

> Follow *KISS* & *Single‑Responsibility* principles; refactor long blocks into reusable helpers.

---

## 2  Naming Conventions

### 2.1 TypeScript
- `camelCase`: variables, functions
- `PascalCase`: components, classes, enums
- `UPPER_SNAKE_CASE`: constants
- Prefixes: `I` interfaces, `T` types, `E` enums

### 2.2 Python
- `snake_case`: variables, functions, methods, files, modules
- `PascalCase`: classes, exceptions
- `UPPER_SNAKE_CASE`: constants

---

## 3  Imports (TS & Python)
1. **Built‑ins / stdlib**
2. **Third‑party packages**
3. **Local (project) modules**
4. **Type stubs / interfaces**
5. **Assets / config** *(TS only)*

- TS: single quotes; default export for primary component; named exports for utils.
- Python: `import x` *or* `from x import y`; **never** `import *`.

---

## 4  Python‑Specific Practices

| Topic | Guideline |
|-------|-----------|
| **Tooling** | Use **uv** for env + deps; **ruff** for lint + format |
| **Ruff profile** | `line‑length = 88`; enable *ALL* rules, ignore `D` (docstrings) only if docs are elsewhere |
| **String quotes** | Double quotes (`"`) preferred |
| **Typing** | Mandatory, incl. `Path` from `pathlib` over raw strings |
| **Error handling** | Catch specific exceptions; degrade gracefully |
| **Paths** | Use `pathlib.Path` throughout |
| **Logging** | Std‑lib `logging`, INFO default, DEBUG via `--verbose` |

---

## 5  TypeScript + React Standards
- Functional components & hooks only.
- Destructure props in the parameter list.
- Styling: **Tailwind CSS**; use `@apply` sparingly.
- Mobile‑first responsive design.

---

## 6  CLI Code Guidelines (Typer & Bash)
- Root entry uses `typer.Typer()`.
- Place sub‑commands under `commands/`; file names = command names.
- Each command **must**: validate inputs, handle errors, log to *stderr*.
- Never echo raw user input without escaping.

---

## 7  DSPy Usage Standards
1. Every **Signature** has full type hints.
2. All **Module** classes inherit `dspy.Module` and implement a typed `forward()`.
3. Separate **Signatures**, **Modules**, **Programs** into dedicated packages.
4. Provide unit tests for every module (≥ 80 % coverage).

---

## 8  Containerisation & Deployment

### 8.1 Dockerfile Baseline
- Base: `python:3.11-slim`.
- Install build essentials + **uv** + **ruff** early for layer caching.
- `WORKDIR /app`; copy `requirements.txt`; `uv pip install -r requirements.txt`.
- Copy project files **after** deps.
- Default `ENTRYPOINT ["python", "-m", "cli.main"]`.

### 8.2 Docker Compose Pattern
```yaml
version: "3.9"
services:
  model_server:
    build: .
    command: ["bash", "model_server/run_llama_cpp.sh"]
    environment:
      - MODEL_PATH=/models/qwen-3b.Q4_K_M.gguf
    volumes:
      - ./model_weights:/models
    ports:
      - "8000:8000"

  cli_dev:
    image: ai-cli-assistant:latest
    command: ["tail", "-f", "/dev/null"]
    volumes:
      - ./:/app
      - ~/.cache/huggingface:/root/.cache/huggingface
    depends_on:
      - model_server
```
- Always include a `.dockerignore` (node_modules, .venv, tests/__pycache__, etc.).
- Enable BuildKit: `DOCKER_BUILDKIT=1`.

---

## 9  Plugin Architecture & Extensibility
- Plugins register through **entry‑points** group `ai_cli_assistant.plugins`.
- File naming: `my_feature_plugin.py`; each file exposes `register() -> dict[str, Callable]`.
- `core/plugin_manager.py` must provide `discover_plugins()` & `get_plugin()` helpers.
- Keep plugin public APIs stable; document breaking changes.

---

## 10  Context Storage Schema
- Default DB: `~/.ai_cli_context.db` (SQLite).
- Tables: `sessions`, `messages`, `context_blocks` (see DDL below).
- Foreign keys *on*; handle migrations with `alembic` or manual DDL.
- Never commit the DB file; add to `.gitignore`.

```sql
CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
*(see `context_data/context_schema.sql` for full schema)*

---

## 11  Secrets & Configuration
- Use **python‑dotenv** to load variables from `.env`.
- Commit a redacted `.env.example`; never commit real secrets.
- Pass model paths & API keys via env vars; fallback to sane defaults.

---

## 12  AI Command Controls (Security)
- Default **allow‑list** for shell commands: `git`, `python`, `uv`, `ruff`, `ls`, `cd`, `pwd`, `cat`.
- **Deny** destructive commands: `rm`, `sudo`, `curl`, `wget`, `docker`, `npm`.
- Always enable File‑, Dirtyfile‑ & External‑File‑Protection.

---

## 13  Git, CI & Collaboration
- Branch workflow: feature → PR → squash‑merge.
- Conventional Commits (`feat:`, `fix:`, `docs:`…).
- **GitHub Actions**: run `ruff check` & `pytest ‑q` on every PR.
- Pre‑commit hook: `pre‑commit run --all‑files` (ruff + mypy + black if used).

---

## 14  Testing & Validation
- Unit tests in `tests/`; file prefix `test_`.
- Use `pytest-mock` or `unittest.mock` for external calls.
- Integration fixture spins up **llama.cpp** once per session (see `tests/conftest.py`).
- Coverage target: **≥ 80 %**; fail CI below threshold.

---

## 15  LLM Integration Norms
- Default local **llama.cpp** REST server on `http://localhost:8080`.
- CLI must degrade gracefully if the model server is offline.
- Benchmark script (`scripts/benchmark.py`) tracks latency & throughput.

---

## 16  Example Project Layout
```text
my_ai_cli_project/
├── cli/                   # Typer CLI (entry & sub‑commands)
├── core/                  # DSPy programs, context & plugin managers
├── api/                   # Optional FastAPI server
├── model_server/          # llama.cpp runner + config
├── context_data/          # SQLite DB + schema
├── plugins/               # Third‑party extensions
├── scripts/               # Helper & benchmark scripts
├── tests/                 # Unit / integration tests
├── Dockerfile & docker-compose.yml
├── pyproject.toml & requirements.txt
└── .env.example | README.md | LICENSE | .gitignore
```

---

## 17  Final Notes
- **Read this guide before opening a PR.**
- Keep the **sample repo blueprint** (`ai_cli_assistant_sample_repo.md`) in mind—this document mirrors its expectations.
- When in doubt, prefer readability, explicitness, and **small composable units**.

