# AI CLI Assistant ‒ Sample Repository Blueprint

## 0. Folder / File Tree

```plaintext
aI-cli-assistant/
│
├── cli/
│   ├── __init__.py
│   ├── main.py            # `python -m cli.main` entry
│   ├── commands.py        # sub‑commands: complete, explain …
│   └── utils.py
│
├── core/
│   ├── __init__.py
│   ├── dspy_programs.py   # DSPy Signatures, Modules, Pipelines
│   ├── context_manager.py # MCP‑style context storage helpers
│   ├── plugin_manager.py  # entry‑point based plugin registry
│   └── models.py          # pydantic data models (optional)
│
├── api/                   # optional REST server (FastAPI)
│   ├── __init__.py
│   ├── server.py
│   └── routes.py
│
├── model_server/
│   ├── run_llama_cpp.sh   # starts `./server --gpu vulkan --api-server`
│   ├── config.yaml        # model + offload settings
│   └── README.md
│
├── context_data/
│   ├── context.db         # SQLite auto‑created
│   ├── context_schema.sql # DDL below
│   └── schema.md          # doc of schema / MCP mapping
│
├── plugins/
│   ├── __init__.py
│   └── hello_world_plugin.py
│
├── tests/
│   ├── __init__.py
│   ├── conftest.py        # spins up llama.cpp once per session
│   ├── test_cli.py
│   ├── test_plugins.py
│   └── test_context.py
│
├── scripts/
│   ├── setup_env.sh       # `uv venv .venv && uv pip install -r requirements.txt`
│   ├── start_all.sh       # dev helper to run compose & open a shell
│   └── benchmark.py       # latency / token‑throughput
│
├── Dockerfile
├── docker-compose.yml
├── pyproject.toml
├── requirements.txt
├── .env.example
├── pre-commit-config.yaml
├── README.md
├── LICENSE
└── .gitignore
```

---

## 1. Containerisation

### 1.1 `Dockerfile`

```Dockerfile
FROM python:3.11-slim

# system build deps
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*

# install uv + ruff early (layer caching)
RUN pip install --no-cache-dir uv ruff

WORKDIR /app

COPY requirements.txt ./
RUN uv pip install -r requirements.txt

COPY . .

# expose CLI by default (can be overridden)
ENTRYPOINT ["python", "-m", "cli.main"]
```

### 1.2 `docker-compose.yml`

```yaml
version: "3.9"
services:
  model_server:
    build: .
    image: ai-cli-assistant:latest
    container_name: llama_cpp_server
    command: ["bash", "model_server/run_llama_cpp.sh"]
    environment:
      - MODEL_PATH=/models/qwen-3b.Q4_K_M.gguf
    volumes:
      - ./model_weights:/models
    ports:
      - "8000:8000"

  cli_dev:
    image: ai-cli-assistant:latest
    container_name: cli_dev
    command: ["tail", "-f", "/dev/null"]   # keep container alive for `docker exec` dev
    volumes:
      - ./:/app
      - ~/.cache/huggingface:/root/.cache/huggingface
    depends_on:
      - model_server
```

---

## 2. Testing & Quality

### 2.1 `pyproject.toml` excerpt

```toml
[tool.pytest.ini_options]
addopts = "-q"
testpaths = ["tests"]
python_files = ["test_*.py"]

[tool.ruff]
line-length = 88
select = ["E", "F", "B", "I"]
```

### 2.2 `tests/conftest.py`

```python
import subprocess, time, pytest, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]

@pytest.fixture(scope="session", autouse=True)
def llama_server():
    """Spin up llama.cpp once for all integration tests."""
    proc = subprocess.Popen(
        ["bash", str(ROOT / "model_server" / "run_llama_cpp.sh")],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    time.sleep(5)  # crude readiness wait
    yield
    proc.terminate()
```

### 2.3 `tests/test_cli.py` (sample)

```python
from click.testing import CliRunner
from cli.main import cli

def test_help():
    runner = CliRunner()
    result = runner.invoke(cli, ["--help"])
    assert result.exit_code == 0
    assert "Usage" in result.output
```

---

## 3. Plugin / Extensibility

### 3.1 `core/plugin_manager.py`

```python
"""Simple entry‑point plugin loader."""
import importlib, pkg_resources
from typing import Callable, Dict

_PLUGINS: Dict[str, Callable] = {}

def discover_plugins() -> None:
    for ep in pkg_resources.iter_entry_points("ai_cli_assistant.plugins"):
        _PLUGINS[ep.name] = ep.load()

def get_plugin(name: str):
    return _PLUGINS.get(name)
```

### 3.2 `plugins/hello_world_plugin.py`

```python
def register():
    return {"hello": hello_cmd}

def hello_cmd(text: str) -> str:
    return f"Hello, {text}!"
```

### 3.3 `setup.cfg` entry‑points excerpt

```ini
[options.entry_points]
ai_cli_assistant.plugins =
    hello = plugins.hello_world_plugin:register
```

---

## 4. Context Storage Schema

### 4.1 `context_data/context_schema.sql`

```sql
CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT REFERENCES sessions(id),
    role TEXT NOT NULL,          -- 'user' | 'assistant' | 'system'
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS context_blocks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT REFERENCES sessions(id),
    type TEXT NOT NULL,          -- 'code', 'error', 'meta' …
    data JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4.2 `core/context_manager.py` excerpt

```python
import json, sqlite3
from pathlib import Path
from typing import Any, Dict

DB_PATH = Path.home() / ".ai_cli_context.db"

def _conn():
    c = sqlite3.connect(DB_PATH)
    c.row_factory = sqlite3.Row
    return c

def init_db() -> None:
    schema = Path(__file__).parent / "../context_data/context_schema.sql"
    with _conn() as cx, open(schema, "r", encoding="utf-8") as f:
        cx.executescript(f.read())


def store_block(session: str, kind: str, data: Dict[str, Any]) -> None:
    with _conn() as cx:
        cx.execute(
            "INSERT INTO context_blocks (session_id, type, data) VALUES (?, ?, json(?))",
            (session, kind, json.dumps(data)),
        )
```

---

### Notes

- **CI ready:** add GitHub Actions workflow to run `ruff check` + `pytest`.
- **Secrets:** move model paths / API keys to `.env` + `python-dotenv`.
- **Extensibility:** any package can register entry‑points => new CLI verbs.
- **Compose:** `docker-compose up -d` starts local model + dev shell.

