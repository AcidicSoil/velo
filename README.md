# Velo

**Local‑first AI CLI assistant powered by **``** + DSPy**

Velo brings offline large‑language‑model magic right into your terminal and editor. It delivers interactive chat, code completion, natural‑language → shell, error explanations, and project‑wide refactors—all running on your GPU (Vulkan) or CPU, with an optional cloud fallback.

---

## ✨ Features

- `` – multi‑turn REPL with Model Context Protocol (MCP) / function‑calling support (Qwen3, Osmosis‑MCP‑4B, smolLM2, etc.).
- `` – context‑aware code completion at `FILE:LINE`.
- `` – translate natural language into ready‑to‑run shell commands (`-y` to auto‑execute).
- `` – break down error logs and suggest fixes.
- `` – project‑wide refactors driven by natural‑language instructions.
- **Hybrid retrieval (HNSW → Tree‑Sitter chunks)** for fast, precise context.
- **Vulkan GPU off‑loading** (AMD, NVIDIA, Intel) with automatic CPU fallback.

---

## 📦 Installation

| Method                  | Command                                                                   |
| ----------------------- | ------------------------------------------------------------------------- |
| **Python (pipx)**       | `pipx install velo-ai`                                                    |
| **Python (virtualenv)** | `pip install velo-ai`                                                     |
| **Standalone binary**   | Download the latest release for your OS and place `velo` on your `$PATH`. |

> **Requires**: \~8 GB disk for model weights. 16 GB RAM (CPU) or 8 GB VRAM (GPU) recommended.

### Enable Vulkan (recommended)

```bash
# Linux / macOS (CMake build)
cmake -B build -DGGML_USE_VULKAN=ON .. && cmake --build build -j

# Windows / MSYS2 (make build)
LLAMA_VULKAN=1 make -j
```

Velo auto‑detects the `llama.cpp` server at `http://localhost:11434`; set `VELO_API_URL` to override.

---

## 🚀 Quick Start

```bash
# 1) First run – launch the interactive wizard
velo                     # seeds caches, picks a default model

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

- `~/.velo/config.toml` – global defaults (model path, retrieval knobs).
- `<repo>/.velo/config.toml` – per‑project overrides.
- CLI flags always override config files.

Common flags:

| Flag                          | Purpose                                           |
| ----------------------------- | ------------------------------------------------- |
| `--model /path/to/model.gguf` | Use a specific local model.                       |
| `--cloud`                     | Route requests to cloud provider (if configured). |
| `--top-files N`               | Adjust coarse retrieval width (default 8).        |
| `--quality high`              | Enable cross‑encoder rerank for refactors.        |
| `--json`                      | Machine‑parseable output.                         |

---

## 🗺️ Roadmap

1. VS Code/Cursor inline integration.
2. Git commit hooks for auto‑lint and PR comments.
3. Web UI overlay (Streamlit/Textual).
4. Code‑Interpreter & Browser‑automation modes via Qwen‑Agent.

See the full [Master Plan](./Masterplan) for details.

---

## 🤝 Contributing

PRs and discussions welcome!  Please read `CONTRIBUTING.md` (coming soon) and open an issue to get started.

---

## 📄 License

Velo is released under the MIT License.  See `LICENSE` for more information.

