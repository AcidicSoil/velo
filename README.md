# Velo

**Local‑first AI CLI assistant powered by **``** + DSPy**

Velo brings offline LLM magic straight to your terminal and editor. It delivers interactive chat, code completion, NL → shell, error explanations, and project‑wide refactors—all on your GPU (Vulkan) or CPU, with optional cloud fallback.

---

## ✨ Features

- `` – multi‑turn REPL with MCP / function‑calling (Qwen3, Osmosis‑MCP‑4B, smolLM2, …).
- `` – context‑aware code completion at `FILE:LINE`.
- `` – translate natural language into shell commands (`-y` to auto‑run).
- `` – break down error logs and suggest fixes.
- `` – project‑wide refactors from plain‑language instructions.
- **Hybrid retrieval (HNSW → Tree‑Sitter chunks)** for fast, precise context.
- **Vulkan GPU off‑loading** (AMD, NVIDIA, Intel) with CPU fallback.
- **Built‑in llama‑server Web UI** – chat and inspect responses at [http://127.0.0.1:8080/](http://127.0.0.1:8080/).

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

- **API** → `http://127.0.0.1:8080/v1/*` (used by Velo)
- **Web UI** → `http://127.0.0.1:8080/`

### 2 — Enable Vulkan (optional but recommended)

```bash
# Linux / macOS (CMake build)
cmake -B build -DGGML_USE_VULKAN=ON .. && cmake --build build -j

# Windows / MSYS2 (make build)
LLAMA_VULKAN=1 make -j
```

Velo auto‑detects the API at `http://localhost:8080`; override with `VELO_API_URL` if using a different host/port.

---

### 3 — (Optional) Build **llama.cpp** from source

If you’d rather compile `llama-server` yourself (instead of using pre‑built binaries), follow these steps—adapted from SteelPh0enix’s guide.

1. **Install build tools** (Windows/MSYS2 example):
   ```bash
   pacman -S git mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja
   # or, with winget
   winget install cmake git.git ninja-build.ninja
   ```
2. **Clone repo & submodules**
   ```bash
   git clone https://github.com/ggerganov/llama.cpp.git
   cd llama.cpp
   git submodule update --init --recursive
   ```
3. **Configure & build (Vulkan backend)**
   ```bash
   cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLAMA_VULKAN=ON -DLLAMA_BUILD_SERVER=ON
   cmake --build build --config Release -j $(nproc)
   cmake --install build --config Release
   ```
4. **Smoke‑test**
   ```bash
   build/bin/llama-cli --help
   build/bin/llama-server --version
   ```

---

### 4 — Prepare a model (GGUF)

1. **Clone without LFS download** (example SmolLM2):
   ```bash
   GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/HuggingFaceTB/SmolLM2-1.7B-Instruct
   ```
2. **Create / activate a Python venv** (if you plan to convert):
   ```bash
   python -m venv ~/llama-cpp-venv && source ~/llama-cpp-venv/bin/activate
   python -m pip install --upgrade -r llama.cpp/requirements/requirements-convert_hf_to_gguf.txt
   ```
3. **Convert & quantize**
   ```bash
   python llama.cpp/convert_hf_to_gguf.py SmolLM2-1.7B-Instruct --outfile ./SmolLM2.gguf
   llama-quantize SmolLM2.gguf SmolLM2.Q4_K_M.gguf Q4_K_M
   ```
4. **Benchmark (optional)**
   ```bash
   llama-bench -m SmolLM2.Q4_K_M.gguf
   ```

Once you have a `.gguf` model, point the `--model` flag in the `llama-server` launch command to its path.

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

- `~/.velo/config.toml` – global defaults (model path, retrieval knobs).
- `<repo>/.velo/config.toml` – per‑project overrides.

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
