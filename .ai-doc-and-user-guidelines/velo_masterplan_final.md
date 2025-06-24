# Velo – Master Plan (Final)

## 0. Executive Summary
Velo is a **local‑first AI CLI assistant** powered by **llama.cpp** running an OpenAI‑compatible server on your workstation. The MVP ships five core capabilities—interactive chat, code completion, NL→shell, error explanation, and project‑wide refactors—through a minimal CLI plus an opt‑in Cursor/VS Code plug‑in. A hybrid two‑stage retrieval pipeline (file‑level → chunk‑level, Tree‑Sitter splits) balances speed with precision, while a hybrid cache layout (`~/.velo/` + `.velo/` per repo) preserves reproducibility without wasting disk. Guided interactive onboarding gives beginners an instant “aha!”, yet everything stays scriptable and deeply configurable for power users.

---

## 1. App Overview & Objectives
* **Problem → Solution**  Modern devs juggle many tools; switching to browsers or cloud AIs breaks flow. Velo embeds LL‑powered assistance directly in the terminal and editor, offline‑first, with optional cloud fallback.
* **Primary Goals**
  1. **< 200 ms average token latency** on commodity hardware (7950X3D + 64 GB RAM).
  2. **Immediate value**: deliver a CLI that solves real‑world tasks on day one.
  3. **Progressive disclosure**: seamless for novices, deep controls for experts.

## 2. Target Audience
* **Beginners** seeking quick explanations or shell helpers.
* **Experienced devs** needing context‑aware refactors, large‑repo completions, and editor integration.
* **Teams** that value reproducible per‑repo AI checkpoints with no cloud dependency.

## 3. Core Features (v1)
| Command | Description | Key Notes |
|---------|-------------|-----------|
| `velo chat` | **Interactive REPL** (Codex‑CLI style) for multi‑turn conversations, quick prototyping, and agent workflows. | Supports tool calling via **MCP 0.1** and OpenAI function‑calling; auto‑detects MCP‑capable local models (e.g., **Qwen3**, **osmosis‑mcp‑4b**, **smolLM2**) with graceful fallback to plain chat. |
| `velo complete` | Fill or extend code at `FILE:LINE`. | Auto‑context via hybrid retrieval and DSPy pipeline. |
| `velo shell` | Natural‑language → shell (with `-y` to auto‑run). | Rich confirmation prompt; supports Bash, zsh, MSYS, PowerShell. |
| `velo explain` | Explain errors from stdin or file. | Summarises root cause, suggests fixes. |
| `velo refactor` | Project‑wide refactor driven by NL instruction. | Uses AST‑aware patching; optional `--quality high` cross‑encoder rerank. |

## 4. High‑Level Technical Stack
| Layer | Choice | Rationale |
|-------|--------|-----------|
| **LLM runtime** | **llama.cpp** (OpenAI‑compatible server) | Local inference with **Vulkan GPU off‑loading** (`-DGGML_USE_VULKAN=ON` / `LLAMA_VULKAN=1`) supporting most modern AMD, NVIDIA, and Intel GPUs; automatic CPU fallback; optional cloud routing via `--cloud` or `VELO_CLOUD=1`. |
| **Orchestration** | **DSPy** modules + agent sub‑framework | Declarative pipelines; auto‑tune prompts/weights from few I/O pairs; mediates MCP/function‑calling. |
| **Tool‑calling / Agent layer** | **MCP 0.1 + OpenAI function‑calling + Qwen‑Agent templates** | Structured tool calls, code‑interpreter steps, RAG chains inside `velo chat`; graceful fallback if the model lacks these capabilities. |
| **Retrieval engine** | Two‑stage RAG (HNSW file embeddings → Tree‑Sitter chunk embeddings), optional cross‑encoder rerank | Balances speed (< 50 ms retrieval) with precision; chunking avoids splitting functions. |
| **CLI framework** | **Typer + Rich** | Auto‑generated help, shell‑completions, progress bars, colorised diffs. |
| **Packaging** | PyPI wheel **and** single‑file PyInstaller binary | One‑line install for Python users; friction‑free exe for others. |
| **Editor plug‑in** | Cursor/VS Code settings template | Point the IDE at `http://localhost:11434` for inline completion & refactor. |

## 5. Conceptual Data & Retrieval Model
* **Embeddings**: E5‑large‑v2 (384‑dim), storable per repo.
* **Storage layout**:
  * **Global cache** (`~/.velo/`): model weights, tokenizers, coarse index (~ 8–12 GB).
  * **Project cache** (`.velo/`): fine‑grained chunk embeddings, DSPy checkpoints (~ 50–300 MB).
* **Retrieval flow**: coarse file shortlist (top‑N) → on‑demand chunk ranking → optional cross‑encoder rerank.

## 6. User Interface & Experience
* **First run**: running `velo` (no args) launches an interactive wizard (skippable via `--defaults`) that seeds caches and writes `.velo/config.toml`.
* **Help system**: `velo --help` collapses advanced flags under “More options ▼”.
* **Verbosity & color**: `-q`, default, `-v`, `-vv`; `NO_COLOR` env respected; `--json` for scriptable output.

## 7. Security & Privacy Considerations
* No network calls unless `--cloud`/`VELO_CLOUD=1` set.
* All embeddings stored locally; project caches can be `.gitignore`d.
* Shell‑execution guard: auto‑runs only with `-y`; otherwise prints command for confirmation.

## 8. Development Phases / Milestones
1. **M0 – Scaffold (Week 1)**
   * Typer skeleton, `velo init` wizard, global cache folder.
2. **M1 – Core commands (Weeks 2‑3)**
   * Retrieval pipeline; implement `chat`, `complete`, `shell`.
   * Basic `explain`, `refactor` skeletons.
3. **M2 – Editor integration (Week 4)**
   * VS Code / Cursor settings template.
4. **M3 – Quality & UX polish (Weeks 5‑6)**
   * Cross‑encoder rerank option, Rich progress, colored diffs.
5. **M4 – Optional cloud gateway (Week 7)**
   * Simple flag/env to redirect to external provider API.

## 9. Potential Challenges & Mitigations
| Risk | Mitigation |
|------|-----------|
| Large repos slow first‑build | Lazy chunking; caching; progress feedback. |
| GPU variance | Default CPU‑only Q4_K_M; auto‑detect GPU flag. |
| Windows MSYS path quirks | Normalise paths early; add PowerShell CI tests. |

## 10. Future Expansion Possibilities
* **Git commit hooks** for automated PR lint/comments.
* **Web UI overlay** (Streamlit/Textual) for interactive chat.
* **Code Interpreter sessions** via Qwen‑Agent for local data analysis.
* **Browser automation / Chrome‑extension** flows powered by Qwen‑Agent.
* **Multi‑model routing** (Mixtral‑MoE, GPT‑4o via cloud).
* **Sparse + dense retrieval** (BM25 hybrid) for rare tokens.

## 11. References
* Typer auto‑completion docs
* Rich progress bars
* PyInstaller usage guide
* llama‑cpp OpenAI server docs
* DSPy GitHub repo
* RAG re‑rank overview
* Tree‑Sitter chunking article
* Onboarding best‑practices (time‑to‑value)
* CONAN code RAG benchmark

