# **Guide to Collaborating with AI Assistants on Your Coding Project**

AI assistants (like the one you're currently interacting with, or future AI agents you build) can be incredibly powerful tools for software development. This guide will help you use them effectively to build your local AI CLI assistant, focusing on best practices for communication, context, and iterative development.

## **1\. Understand the AI's Role and Limitations**

**The AI is an assistant, not a replacement.**

* **Strengths:**  
  * **Code Generation:** Boilerplate, functions, small scripts, specific algorithms.  
  * **Debugging:** Identifying errors, suggesting fixes, explaining error messages.  
  * **Refactoring:** Suggesting improvements for readability, efficiency, or adherence to best practices.  
  * **Explaining Concepts:** Clarifying complex code, technologies (like DSPy or MCP), or error messages.  
  * **Brainstorming:** Generating ideas for features, approaches, or solutions.  
  * **Documentation:** Generating comments, docstrings, or README content.  
  * **Learning:** Helping you understand new libraries, frameworks, or programming paradigms.  
* **Limitations:**  
  * **Lacks Real-World Context:** It doesn't "know" your specific project's history, architectural decisions, or unspoken team conventions unless you explicitly tell it.  
  * **No "Common Sense":** It won't infer things you don't explicitly state.  
  * **Can Hallucinate:** May generate plausible-sounding but incorrect code or information.  
  * **Security Vulnerabilities:** Generated code might contain security flaws; always review.  
  * **Suboptimal Solutions:** Might not always provide the most efficient, elegant, or idiomatic solution.  
  * **Context Window Limits:** It can "forget" earlier parts of a long conversation.

## **2\. Crafting Effective Prompts (The Art of Asking)**

The quality of the AI's output directly correlates with the quality of your prompt.

### **2.1. Be Specific and Detailed**

* **Avoid Vague Requests:** Instead of "Write some Python code," ask "Write a Python function using dspy to classify user intent for CLI commands, specifically distinguishing between code generation and system query tasks."  
* **Specify Language, Frameworks, and Libraries:** Always state the programming language (Python), relevant frameworks (DSPy, Click), and libraries (uv, ruff).  
* **Define Inputs and Outputs:** Clearly describe what the function should take as input and what it should return.  
  * *Example:* "I need a Python function get\_file\_content(file\_path: str) \-\> str that reads the content of a file at file\_path and returns its content as a string. Handle FileNotFoundError gracefully by returning an empty string."

### **2.2. Provide Sufficient Context**

* **Relevant Code Snippets:** If your question relates to existing code, include the snippet. Use markdown code blocks (\`\`\`python) for clarity.  
* **Project Structure/Files:** Mention relevant file paths or a simplified directory structure if it helps the AI understand the context.  
* **Problem Statement:** Clearly explain the problem you're trying to solve, not just the code you want.  
* **Current State:** "My current code does X, but I want it to do Y."  
* **Error Messages:** Copy-paste exact error messages when debugging.

### **2.3. Specify Constraints and Requirements**

* **Performance:** "Optimize this for speed."  
* **Style:** "Follow PEP 8 guidelines." "Include type hints and docstrings."  
* **Dependencies:** "Only use standard Python libraries, no external packages."  
* **Patterns:** "Implement this using a factory pattern."

### **2.4. Use Examples (Few-Shot Prompting)**

* If you have a desired input/output format or a specific coding style, provide 1-3 examples.  
  * *Example:* "Given this input: list python files. I want the output to be: ls \-R \*.py. Now, given how do I remove a directory? produce a similar output."

### **2.5. Break Down Complex Tasks**

* For large features, don't ask for everything at once. Break it into smaller, manageable sub-tasks.  
  * *Instead of:* "Build the entire CLI for my AI assistant."  
  * *Try:*  
    1. "Create the basic argparse structure for my\_cli\_app.py with complete and generate subcommands."  
    2. "Now, write the DSPy Signature for CodeCompletion that takes code\_context and target\_line."  
    3. "Next, implement the dspy.Module that uses this Signature."

### **2.6. Iterate and Refine**

* Don't expect perfect code on the first try.  
* **Refine Your Prompts:** If the AI's response isn't what you expected, explain why and ask it to refine its answer.  
  * "That's good, but the bash\_command should also include sudo if necessary."  
  * "The function you provided doesn't handle empty input. Please add a check for that."  
* **Ask for Explanations:** If you don't understand the generated code, ask the AI to explain specific parts.  
  * "Can you explain why you used functools.lru\_cache here?"

## **3\. Treating the AI as a Collaborator (Your Pair Programmer)**

Think of your AI assistant as a pair programmer with vast knowledge but no personal context.

### **3.1. Structured Collaboration**

* **Start with Clear Goals:** Define the objective for each interaction.  
* **Provide Feedback:** Explicitly state what was good, what was wrong, and what needs adjustment. This helps the AI learn (within the current conversation context) and improves future outputs.  
* **Review and Test Critically:** **NEVER** blindly trust AI-generated code. Always review it for:  
  * **Correctness:** Does it do what it's supposed to do?  
  * **Efficiency:** Is it optimal?  
  * **Security:** Are there any vulnerabilities?  
  * **Style:** Does it match your ruff configuration and project standards?  
  * **Edge Cases:** Does it handle unusual inputs or scenarios?  
* **Human Oversight is Key:** You are the ultimate decision-maker and responsible for the code. AI assists, but human approval is essential.

### **3.2. Context Management in Conversations**

* **Keep Sessions Focused:** If you're switching topics or starting a completely new task, consider starting a new conversation with the AI to prevent context drift.  
* **Summarize if Needed:** For very long threads, you might occasionally ask the AI to "Summarize our discussion so far on feature X" to reinforce the context.

### **3.3. Leveraging AI for Different Project Phases**

* **Planning:** "Brainstorm 3 different architectural approaches for integrating MCP with DSPy in a CLI."  
* **Design:** "Design a DSPy Signature for a code refactoring task. It should take original\_code and refactoring\_instruction."  
* **Implementation:** "Write the Python code for the get\_file\_content utility function, including try-except for file operations."  
* **Debugging:** "I'm getting this error: \[Paste Error Traceback\]. Here's my my\_cli\_app.py file: \[Paste Code\]. What's causing this?"  
* **Documentation:** "Generate a docstring for the GenerateBashCommand class in my\_cli\_app.py."

## **4\. Specific Tips for Your Local AI CLI Project**

* **llama.cpp Interactions:** When asking about llama.cpp issues, provide details about your compilation (LLAMA\_VULKAN=1), how you're running the server (./server \--gpu vulkan \--api-server), and the exact model name.  
* **DSPy Prompting:**  
  * Clearly define your dspy.Signature inputs and outputs in your prompt before asking for the Module implementation.  
  * Explain the role of each DSPy component (Signature, Module, Program, Teleprompter) when asking for help with their design.  
  * "I need a DSPy Signature for a NaturalLanguageToCode task. It should take a natural\_language\_description of the desired code and output the python\_code."  
* **MCP Integration:** When discussing MCP, provide context on what data you want to manage (e.g., "I want to pass the currently open file's content as a context block to the LLM. How can I structure this using MCP principles?").  
* **uv and ruff:** If you encounter issues with these tools, provide the exact command you ran and the error message. "When I run uv pip install \-r requirements.txt, I get \[Error\]. What could be wrong?"

By adopting these practices, you'll transform your AI assistant from a simple code generator into a true collaborator, significantly boosting your productivity and the quality of your local AI CLI project.