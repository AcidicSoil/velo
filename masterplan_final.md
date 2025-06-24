# Velo – Master Plan (Final, Port 8080)

> **Status: Sealed – 23 Jun 2025**   All references now use **port 8080** to match `llama-server` defaults and the README.

---

## Executive Summary
Velo is a local‑first AI CLI assistant powered by **llama.cpp** (`llama-server`) on your workstation. It ships five capabilities—interactive chat, code completion, NL→shell, error explanation, and repo‑wide refactors—exposed via CLI and an opt‑in Cursor/VS Code plug‑in. A hybrid retrieval pipeline (file→AST chunk) balances speed and precision, while a hybrid cache layout (`~/.velo/` + `.velo/`) ensures reproducibility without wasting disk. Guided onboarding gets beginners productive in minutes, but every lever remains scriptable for power users.

---

## Target Audience
* **Beginners** who need quick explanations and shell helpers.  
* **Experienced devs** wanting context‑aware refactors, large‑repo completions, and editor integration.  
* **Teams** that value reproducible, offline AI checkpoints.

---

## Core Features (v1)
| Command | Purpose | Notes |
|---------|---------|-------|
| `velo chat` | Multi‑turn REPL / agent | MCP 0.1 + OpenAI function‑calling; auto‑detects Qwen3, Osmosis‑MCP‑4B, smolLM2. |
| `velo complete` | Code completion at `FILE:LINE` | Hybrid retrieval → DSPy pipeline. |
| `velo shell` | NL → shell (`-y` auto‑run) | Works with Bash, zsh, MSYS, PowerShell. |
| `velo explain` | Explain error logs | Summarise + suggest fixes. |
| `velo refactor` | Repo‑wide refactor | AST‑aware patching; optional quality rerank. |

---

## Architecture
| Layer | Choice | Details |
|-------|--------|---------|
| **LLM runtime** | `llama-server` | Vulkan GPU off‑loading (`-DGGML_USE_VULKAN=ON` / `LLAMA_VULKAN=1`).  
Default **API** `http://127.0.0.1:8080/v1/…`; built‑in Web UI `http://127.0.0.1:8080/`; automatic CPU fallback; optional cloud via `--cloud` / `VELO_CLOUD=1`. |
| **Orchestration** | **DSPy** modules | Declarative pipelines; BootlegOptimizer fine‑tuning. |
| **Agent layer** | MCP 0.1 + Qwen‑Agent templates | Structured tool calls, code‑interpreter, browser automation. |
| **Retrieval** | Two‑stage RAG (HNSW file → Tree‑Sitter chunks) | < 50 ms retrieval; cross‑encoder rerank optional. |
| **CLI** | Typer + Rich | Auto‑help, shell completions, colorful diffs. |
| **Packaging** | PyPI wheel & PyInstaller exe | One‑line install or standalone binary. |
| **IDE** | Cursor/VS Code endpoint | Point to `http://127.0.0.1:8080`. |

---

## Data & Storage
* **Embeddings**: E5‑large‑v2 (384‑d) per repo.  
* **Cache layout**: `~/.velo/` (models, coarse index) + `.velo/` (fine chunks, checkpoints).

---

## UX Highlights
* `velo` with no args → interactive wizard (skippable via `--defaults`).  
* Rich output; respects `NO_COLOR`; verbosity `-q / -v / -vv`; machine output `--json`.

---

## Security
* True offline unless `--cloud`/`VELO_CLOUD=1` set.  
* Local embeddings; `.gitignore`‑able project cache.  
* Shell commands require `-y` to auto‑execute.

---

## Milestones
1. **M0** – Typer skeleton, wizard, cache folders.  
2. **M1** – Implement `chat`, `complete`, `shell`; scaffold `explain`, `refactor`.  
3. **M2** – VS Code/Cursor plug‑in template.  
4. **M3** – UX polish, cross‑encoder rerank.  
5. **M4** – Cloud gateway flag/env.

---

## Risks & Mitigations
| Risk | Mitigation |
|------|-----------|
| Slow initial indexing | Lazy chunking, progress bars. |
| GPU variance | Fall back to Q4‑K‑M CPU quant; auto‑detect GPU. |
| Windows path quirks | Normalise paths; PowerShell CI tests. |

---

## Future Expansion
* Git commit hooks.  
* Streamlit/Textual Web UI overlay.  
* Code‑Interpreter sessions via Qwen‑Agent.  
* Browser automation flows.  
* Hybrid BM25 + dense retrieval.

---

### DSPy Appendix
* **RetrieverModule** → coarse HNSW + fine chunker.  
* **GeneratorModule** → calls `http://127.0.0.1:8080/v1`.  
* Pipeline auto‑tuned with BootlegOptimizer.

---

_End of Master Plan_

