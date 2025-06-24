# Velo

**Local‑first AI CLI assistant powered by `llama.cpp` + DSPy**

Velo brings offline LLM magic straight to your terminal and editor. It delivers interactive chat, code completion, NL → shell, error explanations, and project‑wide refactors—all on your GPU (Vulkan) or CPU, with optional cloud fallback.

---

## ✨ Features

* **`velo chat`** – multi‑turn REPL with MCP / function‑calling (Qwen3, Osmosis‑MCP‑4B, smolLM2, …).
* **`velo complete`** – context‑aware code completion at `FILE:LINE`.
* **`velo shell`** – translate natural language into shell commands (`-y` to auto‑run).
* **`velo explain`** – break down error logs and suggest fixes.
* **`velo refactor`** – project‑wide refactors from plain‑language instructions.
* **Hybrid retrieval (HNSW → Tree‑Sitter chunks)** for fast, precise context.
* **Vulkan GPU off‑loading** (AMD, NVIDIA, Intel) with CPU fallback.
* **Built‑in llama‑server Web UI** – chat and inspect responses at [http://127.0.0.1:8080/](http://127.0.0.1:8080/).

---

## 📦 Installation

| Method                  | Command                                                            |
| ----------------------- | ------------------------------------------------------------------ |
| **Python (pipx)**       | `pipx install velo-ai`                                             |
| **Python (virtualenv)** | `pip install velo-ai`                                              |
| **Standalone binary**   | Download the release for your OS and place `velo` on your `$PATH`. |

> **Requires** ≈ 8 GB disk for weights. 16 GB RAM (CPU) or 8 GB VRAM (GPU) recommended.

### 1 — Start the `llama-server`

```bash
# Launch llama-server with Vulkan, OpenAI API, and Web UI
./server --gpu vulkan \
        --api-server --host 127.0.0.1 --port 8080 \
        --chat-ui \
        --model /path/to/model.gguf &
```

This exposes:

* **API** → `http://127.0.0.1:8080/v1/*` (used by Velo)
* **Web UI** → `http://127.0.0.1:8080/`

### 2 — Enable Vulkan (optional but recommended)

```bash
# Linux / macOS (CMake build)
cmake -B build -DGGML_USE_VULKAN=ON .. && cmake --build build -j

# Windows / MSYS2 (make build)
LLAMA_VULKAN=1 make -j
```

Velo auto‑detects the API at `http://localhost:8080`; override with `VELO_API_URL` if using a different host/port.

---

## 🚀 Quick Start

```bash
# 1) First run – launch the interactive wizard
velo               # seeds caches, chooses a default model

# 2) Chat with the assistant
velo chat

# 3) Ask for a shell command
velo shell "list largest git objects" -y

# 4) Complete code at a cursor
velo complete src/foo.py:120
```

The wizard writes per‑project config to `.velo/` and stores heavy assets under `~/.velo/`.

---

## 🔧 Configuration

Files:

* `~/.velo/config.toml` – global defaults (model path, retrieval knobs).
* `<repo>/.velo/config.toml` – per‑project overrides.

CLI flags override config.  Common examples:

| Flag                          | Purpose                                          |
| ----------------------------- | ------------------------------------------------ |
| `--model /path/to/model.gguf` | Use a specific local model                       |
| `--cloud`                     | Route requests to cloud provider (if configured) |
| `--top-files N`               | Adjust coarse retrieval width (default 8)        |
| `--quality high`              | Enable cross‑encoder rerank for refactors        |
| `--json`                      | Output machine‑parseable JSON                    |

---

## 🗺️ Roadmap

1. VS Code/Cursor inline integration
2. Git hooks for auto‑lint / PR comments
3. Web UI overlay (Streamlit/Textual)
4. Code‑Interpreter & browser‑automation via Qwen‑Agent

See the full [Master Plan](.ai-doc-and-user-guidelines/Masterplan.md) for details.

---

## 🤝 Contributing

PRs and discussions welcome!  Please read `CONTRIBUTING.md` (coming soon) before starting.

---

## 📄 License

Velo is released under the MIT License.  See `LICENSE` for details.
