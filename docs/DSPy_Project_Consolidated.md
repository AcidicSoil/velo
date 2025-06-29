<!-- @format -->

# DSPy Project Setup

> DSPy is a bet on writing code instead of strings. In other words, building the right control flow is crucial. Start by defining your task. What are the inputs to your system and what should your system produce as output? Is it a chatbot over your data or perhaps a code assistant? Or maybe a system for translation, for highlighting snippets from search results, or for generating reports with citations?
>
> Next, define your initial pipeline. Can your DSPy program just be a single module or do you need to break it down into a few steps? Do you need retrieval or other tools, like a calculator or a calendar API? Is there a typical workflow for solving your problem in multiple well-scoped steps, or do you want more open-ended tool use with agents for your task? Think about these but start simple, perhaps with just a single dspy.ChainOfThought module, then add complexity incrementally based on observations.

---

## 1 ▪ Define the task (v 0.1)

| Aspect                 | Draft answer                                                                                                                                                                                          |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **Goal**               | Give Velo users an _offline_ "internal-API tutor." A CLI command such as `velo ask "question"` returns a step-by-step answer plus a runnable code snippet that compiles against the checked-out repo. |
| **Inputs**             | ```python\nquestion: str # natural language, possibly multi-line\nfile_hint: str                                                                                                                      | None # optional relative path the user is looking at``` |
| **Outputs**            | `python\nanswer_steps: str # numbered reasoning + citations\nusage_snippet: str # ready-to-paste example\nrefs: list[str] # file:line references shown to user`                                       |
| **Success criteria**   | _a)_ References resolve to real lines; _b)_ snippet type-checks with `mypy`; _c)_ median latency < 2 s on CPU; _d)_ user thumbs-up ≥ 80 % in a feedback prompt.                                       |
| **First stakeholders** | You (dev), early adopters on Discord, and the VS Code extension.                                                                                                                                      |

---

## 2 ▪ Initial pipeline — keep it one module

```python
import dspy, velo_search        # velo_search = tiny wrapper around ripgrep or embedding DB

class AskCode(dspy.Signature):
    """CLI Q&A over the Velo codebase"""
    question      = dspy.InputField()
    context_lines = dspy.InputField()      # file excerpts pre-fetched by retrieval
    answer_steps  = dspy.OutputField(desc="explain step by step")
    usage_snippet = dspy.OutputField(desc="ready code snippet with imports")
    refs          = dspy.OutputField(desc="file:line references")

ask_code = dspy.ChainOfThought(AskCode)   # single-box reasoning module
```

**Control-flow v 0.1**

1. `retrieve(question, file_hint) → top_k_lines` (simple keyword grep now; replace with embedding DB later)
2. `ask_code(question, top_k_lines)` (one LLM call with chain-of-thought)
3. `print(answer_steps, usage_snippet)`

That's it. No agents, no multi-hop, no feedback loops—yet.

---

## 3 ▪ Seed examples to keep around

| Question                                             | file_hint        | Expected key lines & snippet                                                                       |
| ---------------------------------------------------- | ---------------- | -------------------------------------------------------------------------------------------------- |
| "How do I run Velo entirely on CPU?"                 | `pyproject.toml` | Show the `--device cpu` flag in `cli.py` and demonstrate `velo run my.py --device cpu`.            |
| "What does `velo refactor` actually modify?"         | (none)           | Point at `refactor.py` visitor classes; snippet wraps main in `try/except` and shows dry-run mode. |
| "Can I stream tokens from the chat API?"             | `client/chat.py` | Highlight `stream=True` param; snippet with async iterator.                                        |
| "Difference between `Engine` and `Session` objects?" | `engine/*.py`    | Contrast their lifecycles; snippet instantiates both.                                              |

Aim for **5–8 examples**: 3 "easy wins" (explicit docstrings) + 2 "hard" ones (implied behaviour spread across files).

---

## 4 ▪ Questions to unblock the next iteration

1. **Retrieval choice** Do you already maintain an embeddings index (e.g., `vectordb/`), or should we hack in `ripgrep` first?
2. **LLM back-end** Sticking with the local GGUF model shipped in Velo, or calling OpenAI when available?
3. **Citation granularity** Are file-level references fine, or do we need line numbers for the IDE hover provider?
4. **Latency budget** Is sub-second response a must for the terminal UX, or is 2–3 s acceptable?

---

## 5 ▪ Next-step complexity roadmap (v 0.2 → v 0.4)

1. **Swap retrieval** `NaiveRetrieval` ➜ `EmbeddingRetrieval` with a cached FAISS index.
2. **Split pipeline** Separate `Retrieve` and `ChainOfThought` modules; train with DSPy's `RAGOptimizer`.
3. **Add tooling agent** Wrap `black`, `pytest`, and `python -m py_compile` as callable tools; expose via `dspy.ReAct`.
4. **Feedback tuning** Pipe CLI thumb-ups into `RFT` (Reward-Fine-Tuning) to refine prompts.

---

### Tiny evidence check

- The listing we saw shows **Python+HTML** split (~26 % Python) in `main` branch—enough code to warrant a retrieval step [GitHub - AcidicSoil/velo](https://github.com/AcidicSoil/velo?tab=readme-ov-file).
- DSPy's _ChainOfThought_ module is purpose-built for "reason step by step" single-call flows [DSPy Modules](https://dspy.ai/learn/programming/modules/).

---

## Next Steps

That should be plenty to get you moving.
Let me know once you pick answers for the open questions above—we'll wire them in and grow the pipeline from there.