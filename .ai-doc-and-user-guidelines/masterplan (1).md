# Velo – Master Plan

## 0. Executive Summary
Velo is a local‑first AI CLI assistant, powered by **llama.cpp** running an OpenAI‑compatible server on your workstation. The MVP delivers four core capabilities—code completion, natural‑language → shell commands, error explanation, and project‑wide refactors—exposed through a minimal CLI and an opt‑in Cursor/VS Code plug‑in. A hybrid two‑stage retrieval pipeline (file‑level → chunk‑level, Tree‑Sitter splits) balances speed with precision, while a hybrid cache layout (`~/.velo/` + `.velo/` per repo) preserves reproducibility without wasting disk. Guided interactive onboarding gives beginners an instant “aha!”, yet all features remain scriptable and deeply configurable for power users.

---

## 1. App Overview & Objectives
* **Problem → Solution**   Modern devs juggle many tools; switching to browsers or cloud AIs breaks flow. Velo embeds LL‑powered assistance directly in the terminal and editor, offline‑first, with optional cloud fallback.
* **Primary Goals**
  1. **<200 ms avg token latency** on commodity hardware (7950X3D+64 GB RAM).
  2. **Immediate value**: ship a CLI that solves real‑world tasks on day one.
  3. **Progressive disclosure**: seamless for novices, deep controls for experts.

## 2. Target Audience
* **Beginners** looking for “explain this stack‑trace” or “what shell command does X?”.
* **Experienced devs** needing context‑aware refactors, large‑repo completions, and editor integrations.
* **Teams** that value reproducible per‑repo AI checkpoints without cloud dependencies.

## 3. Core Features (v1)
| Command | Description | Key Notes |
|---------|-------------|-----------|
| `velo chat` | **Interactive REPL** (Codex‑CLI style) for multi‑turn conversations, quick prototyping, and agent‑style workflows. | Supports tool calling via **Model Context Protocol (MCP)** and OpenAI function‑calling; auto‑detects local MCP‑capable models such as **osmosis‑mcp‑4b** or **smolLM2**, with graceful fallback to plain chat. |
| `velo complete` | Fill or extend code at `FILE:LINE`. | Auto‑context via hybrid retrieval and DSPy pipeline. |
| `velo shell` | NL → shell (with `-y` to auto‑run). | Rich confirm prompt; supports Bash, zsh, MSYS, PowerShell. |
| `velo explain` | Explain errors from stdin/file. | Summarises, suggests fixes. |
| `velo refactor` | Project‑wide refactor driven by NL instruction. | Uses AST‑aware patching; optional `--quality high` rerank. ([medium.com](https://medium.com/%40adnanmasood/re-ranking-mechanisms-in-retrieval-augmented-generation-pipelines-an-overview-8e24303ee789?utm_source=chatgpt.com)) |

## 4. High‑Level Technical Stack. High‑Level Technical Stack
| Layer | Choice | Rationale |
|-------|--------|-----------|
| **LLM runtime** | `llama.cpp` (OpenAI‑compat server) ([llama-cpp-python.readthedocs.io](https://llama-cpp-python.readthedocs.io/en/latest/server/?utm_source=chatgpt.com)) | Local inference with **Vulkan GPU off‑loading** (enable via `-DGGML_USE_VULKAN=ON` in CMake or `LLAMA_VULKAN=1 make`) that supports most modern AMD, NVIDIA, and Intel GPUs; automatic fallback to CPU-only if Vulkan isn’t available. Optional cloud routing can be toggled with `--cloud` or `VELO_CLOUD=1`. |
| **Orchestration** | **DSPy** modules + **Agent sub‑framework** | Declarative pipelines; auto‑tune prompts/weights from few I/O pairs; agent layer mediates MCP/function‑calling for tool invocation. |
| **Tool‑calling / Agent layer** | **MCP 0.1 + OpenAI function‑calling + Qwen‑Agent templates** (auto‑detects Qwen3, osmosis‑mcp‑4b, smolLM2, etc.) | Enables structured tool calls, code‑interpreter steps, and RAG chains inside `velo chat`; graceful fallback to standard chat when the active model lacks these capabilities. |
| **CLI framework** | **Typer + Rich** | Auto‑generated help & completions; polished TUI with progress bars. |
| **Packaging** | PyPI wheel **and** single‑file PyInstaller binary | One‑line install for Python users; friction‑free exe for others. |
| **Editor plug‑in** | Cursor/VS Code custom endpoint | Minimal code—just point at `localhost:11434`. | framework** | **Typer + Rich** ([typer.tiangolo.com](https://typer.tiangolo.com/tutorial/options-autocompletion/?utm_source=chatgpt.com), [rich.readthedocs.io](https://rich.readthedocs.io/en/stable/progress.html?utm_source=chatgpt.com)) | Auto‑generated help & completions; polished TUI with progress bars. |
| **Packaging** | PyPI wheel **and** single‑file PyInstaller binary ([pyinstaller.org](https://pyinstaller.org/en/v4.1/usage.html?utm_source=chatgpt.com)) | One‑line install for Python users; friction‑free exe for others. |
| **Editor plug‑in** | Cursor/VS Code custom endpoint (settings JSON) ([github.com](https://github.com/ggml-org/llama.cpp/discussions/795?utm_source=chatgpt.com)) | Minimal code—just point at `localhost:11434`. |

## 5. Conceptual Data & Retrieval Model
* **Two‑stage retrieval**: HNSW file embeddings → Tree‑Sitter chunk embeddings; optional cross‑encoder rerank. ([medium.com](https://medium.com/%40joe_30979/mastering-code-chunking-for-retrieval-augmented-generation-66660397d0e0?utm_source=chatgpt.com), [medium.com](https://medium.com/%40adnanmasood/re-ranking-mechanisms-in-retrieval-augmented-generation-pipelines-an-overview-8e24303ee789?utm_source=chatgpt.com))
* **Embeddings**: E5‑large‑v2 (384‑dim) for density; can swap models per project.
* **Storage**:
  * Global: models, tokenizer, coarse index (~8–12 GB).
  * Project: fine embeddings, DSPy checkpoints (~50–300 MB).   ([arxiv.org](https://arxiv.org/html/2410.16229v1?utm_source=chatgpt.com))

## 6. User Interface & Experience
* **First‑run**: running `velo` with no args launches an interactive wizard (skippable via `--defaults`). Wizard seeds global cache and creates a `.velo/config.toml`. ([appcues.com](https://www.appcues.com/blog/customer-onboarding-checklist?utm_source=chatgpt.com))
* **Help system**: `velo --help` collapses advanced flags under “More options ▼”.
* **Colors**: Rich‑style output on by default; respect `NO_COLOR` env.
* **Verbosity**: `-q`, default, `-v`, `-vv`; `--json` for machine parsing.

## 7. Security & Privacy Considerations
* No network calls unless `VELO_CLOUD=1` or `--cloud` flag set.
* All embeddings stored locally; repo overrides commit‑friendly but can be `.gitignore`’d.
* Shell‑execution guard: auto‑runs only with `-y`; otherwise prints command for user confirmation.

## 8. Development Phases / Milestones
1. **M0 – Scaffold (Week 1)**
   * Typer CLI skeleton & `velo init` wizard.
   * Global cache folder & settings loader.
2. **M1 – Core commands (Weeks 2–3)**
   * Implement retrieval pipeline & `complete`/`shell`/`chat` commands.
   * Basic error explain & refactor skeleton.
3. **M2 – Editor integration (Week 4)**
   * VS Code / Cursor settings template.
4. **M3 – Quality & UX polish (Weeks 5–6)**
   * Cross‑encoder rerank option, progress bars, colored diffs.
5. **M4 – Optional cloud gateway (Week 7)**
   * Simple env flag to redirect to provider API.

## 9. Potential Challenges & Mitigations
| Risk | Mitigation |
|------|-----------|
| Large repos slow first‑build | Lazy chunking; caching; progress feedback. |
| GPU variance across users | Default to CPU‑only Q4_K_M; auto‑detect GPU flag. |
| Windows MSYS path quirks | Normalize paths early; add PowerShell tests in CI. |

## 10. Future Expansion Possibilities
* **Git commit hooks** for automated lint / PR comments.
* **Web UI** overlay (Streamlit/Textual) for interactive chat.
* **Code Interpreter sessions** via Qwen‑Agent templates for local data analysis and notebook‑style experimentation.
* **Browser automation / Chrome‑extension flows** powered by Qwen‑Agent, enabling scripted form filling, scraping, and end‑to‑end workflow demos.
* **Multi‑model routing**: leverage Mixtral‑MoE or GPT‑4o via cloud for heavy tasks.
* **Sparse + dense retrieval**: bring BM25 into hybrid index for rare tokens.

## 11. References. References
* Typer auto‑completion docs ([typer.tiangolo.com](https://typer.tiangolo.com/tutorial/options-autocompletion/?utm_source=chatgpt.com))
* Rich progress bars ([rich.readthedocs.io](https://rich.readthedocs.io/en/stable/progress.html?utm_source=chatgpt.com))
* PyInstaller usage guide ([pyinstaller.org](https://pyinstaller.org/en/v4.1/usage.html?utm_source=chatgpt.com))
* llama‑cpp OpenAI server docs ([llama-cpp-python.readthedocs.io](https://llama-cpp-python.readthedocs.io/en/latest/server/?utm_source=chatgpt.com))
* DSPy GitHub repo ([github.com](https://github.com/stanfordnlp/dspy?utm_source=chatgpt.com))
* RAG re‑rank overview ([medium.com](https://medium.com/%40adnanmasood/re-ranking-mechanisms-in-retrieval-augmented-generation-pipelines-an-overview-8e24303ee789?utm_source=chatgpt.com))
* Tree‑Sitter chunking article ([medium.com](https://medium.com/%40joe_30979/mastering-code-chunking-for-retrieval-augmented-generation-66660397d0e0?utm_source=chatgpt.com))
* Onboarding best practices (time‑to‑value) ([appcues.com](https://www.appcues.com/blog/customer-onboarding-checklist?utm_source=chatgpt.com))
* PyInstaller exe tutorial ([medium.com](https://medium.com/%40moraneus/crafting-a-standalone-executable-with-pyinstaller-f9a99ea24432?utm_source=chatgpt.com))
* CONAN code RAG benchmark ([arxiv.org](https://arxiv.org/html/2410.16229v1?utm_source=chatgpt.com))

