# **Custom AI Modes and Workflow Examples for Enhanced Productivity**

To truly supercharge your development process with AI assistants, you can move beyond simple requests and define "custom modes" or structured workflows. These modes encapsulate specific instructions, preferences, and constraints, ensuring the AI behaves consistently and optimally for recurring tasks.

## **1\. Custom AI Modes: Pre-configuring Assistant Behavior**

Your screenshots clearly show Cursor's explicit "mode menu," which is a powerful feature for pre-defining and activating specific assistant behaviors. This allows you to encapsulate a set of instructions, a persona, and constraints that you can "activate" for your AI assistant, saving you from repeating lengthy prompts and ensuring a consistent approach to specific tasks.

### **Understanding Cursor's Built-in Modes (from your screenshot):**

* **Agent (Ctrl+I):** Likely the default, general-purpose AI assistant mode for broad requests.  
* **Ask:** A basic mode for asking general questions without immediate code generation intent.  
* **Manual:** Implies a mode where AI assistance is less prominent, or you explicitly control interactions.  
* **VAN:** (Purpose not immediately clear from name, but likely a specific tool or context mode).  
* **PLAN:** A mode focused on high-level planning, architectural design, or task breakdown.  
* **CREATIVE:** A mode encouraging more imaginative or exploratory AI responses, possibly for brainstorming or alternative solutions.  
* **IMPLEMENT:** A mode geared towards concrete code generation, implementing features, or writing specific functions.

### **Creating Your Own Custom Modes in Cursor:**

The "Add custom mode" option (visible in your screenshot below "IMPLEMENT") is precisely where you can define the specialized behaviors we discussed. When you create a custom mode, you'll typically configure it with a specific **meta-prompt** or **system instruction** that sets the AI's persona, objectives, and constraints for that mode.

**How you can create your custom modes within Cursor's UI (conceptual steps):**

1. **Access the Mode Menu:** Click the "Agent" dropdown (or use Ctrl+.) to open the mode menu.  
2. **Select "Add custom mode":** This will likely open a configuration interface.  
3. **Define Mode Properties:**  
   * **Name:** Give your mode a descriptive name (e.g., "Debugging Mode," "Refactoring Mode," "Documentation Mode," "Bash Generation Mode").  
   * **Icon (Optional):** Choose an icon for easy visual identification.  
   * **System Prompt/Instructions:** This is the most crucial part. Here, you'll write the detailed instructions that define the AI's behavior when this mode is active. This is where you place the "Activation Prompts" described below.  
   * **Default Context/Settings (if available):** Some custom mode interfaces might allow you to pre-select certain files for context or set other default behaviors.

Once created, your custom mode will appear in the mode menu, ready to be activated.

### **Examples of Custom AI Modes You Can Create:**

#### **1.1. Debugging Mode**

* **Purpose:** Guides the AI to focus on identifying, explaining, and fixing bugs efficiently.  
* **AI Behavior:** Prioritizes error messages, stack traces, and relevant code. Suggests root causes, test cases, and fixes. Avoids generating new features.  
* **System Prompt (for "Add custom mode" configuration):**  
  "\*\*DEBUGGING MODE ACTIVATED:\*\* You are an expert Python debugger. My goal is to find and fix the root cause of this error. When I provide code or error messages, your primary tasks are:  
  1\. Identify the exact line/component causing the issue.  
  2\. Explain the error clearly (why it's happening).  
  3\. Suggest a concise, correct, and PEP 8 compliant fix.  
  4\. Provide a small, isolated test case to verify the fix if applicable.  
  Do NOT generate new features or refactor unrelated code."

* **Workflow Integration:** Activate "Debugging Mode," then paste error tracebacks, relevant code snippets, and ask "Why is this happening?" or "How do I fix this?"

#### **1.2. Refactoring Mode**

* **Purpose:** Directs the AI to focus on improving code quality, readability, performance, and adherence to standards.  
* **AI Behavior:** Analyzes code for "code smells," suggests cleaner structures, better naming, and more efficient algorithms. Adheres to ruff rules and Python best practices.  
* **System Prompt (for "Add custom mode" configuration):**  
  "\*\*REFACTORING MODE ACTIVATED:\*\* You are a senior Python software engineer focused on code quality. My goal is to refactor the following code to improve its readability, maintainability, and efficiency. Your tasks are:  
  1\. Identify areas for improvement (e.g., complexity, duplication, poor naming).  
  2\. Propose concrete changes, providing the rewritten code.  
  3\. Explain the reasoning behind each refactoring suggestion.  
  4\. Ensure all changes are \`ruff\` compliant and include type hints/docstrings.  
  Do NOT change core functionality or add new features unless explicitly asked."

* **Workflow Integration:** Activate "Refactoring Mode," highlight a function or class, and prompt "How can I refactor this?" or "Suggest improvements for readability here."

#### **1.3. Documentation Mode**

* **Purpose:** Ensures the AI generates clear, concise, and comprehensive documentation.  
* **AI Behavior:** Focuses on explaining code's purpose, parameters, return values, and usage examples. Adheres to specified documentation styles (e.g., Google, reStructuredText).  
* **System Prompt (for "Add custom mode" configuration):**  
  "\*\*DOCUMENTATION MODE ACTIVATED:\*\* You are a technical writer specializing in Python documentation. My goal is to generate high-quality docstrings and README content. Your tasks are:  
  1\. Generate a Google-style docstring for the provided Python function/class.  
  2\. Include a clear summary, parameters, return values, and usage examples.  
  3\. Ensure clarity, conciseness, and accuracy.  
  4\. For README sections, provide Markdown formatted text with code blocks."

* **Workflow Integration:** Activate "Documentation Mode," select a function, and ask "Generate a docstring for this."

#### **1.4. Bash Generation Mode**

* **Purpose:** Specializes the AI in generating shell commands for specific tasks.  
* **AI Behavior:** Prioritizes brevity and correctness for bash commands. Considers typical CLI environments (MSYS2/bash). May suggest common flags (e.g., \-R for recursive).  
* **System Prompt (for "Add custom mode" configuration):**  
  "\*\*BASH GENERATION MODE ACTIVATED:\*\* You are a Linux shell expert. My goal is to get precise, runnable bash commands for specific tasks. Your tasks are:  
  1\. Provide the most direct and efficient bash command.  
  2\. Include common flags (e.g., \`-R\`, \`-f\`, \`-p\`) where appropriate.  
  3\. Briefly explain the command if it's complex.  
  4\. Do NOT generate Python code or long explanations."

* **Workflow Integration:** Activate "Bash Generation Mode," then prompt directly with "Generate a bash command to..."

## **2\. Practical Workflow Examples with AI Assistant Integration**

These examples combine the custom modes, context control, and AI interaction best practices for typical development scenarios in your "Local AI CLI Assistant" project.

### **Workflow Example 1: Implementing a New my\_ai\_cli Feature (my\_ai\_cli explain)**

**Goal:** Add a new subcommand explain to your CLI that uses DSPy to explain a given code snippet.

1. **Plan with AI (Using "PLAN" or General Agent Mode):**  
   * **You (in chat, with "PLAN" mode active):** "I want to add a new subcommand explain to my\_ai\_cli. It should take a \--file path and optionally a \--line-range. It will then use a local LLM via DSPy to explain the code. How should I structure the argparse for this, and what DSPy components would I need?"  
   * **AI:** Suggests argparse additions (subcommand, arguments) and outlines DSPy Signature (inputs: code\_snippet, explanation\_style; output: explanation), and a dspy.Module.  
2. **CLI Integration (Using "IMPLEMENT" or General Agent Mode):**  
   * **You (in Cursor, my\_cli\_app.py open, with "IMPLEMENT" mode active):** "Generate the argparse modifications for the explain subcommand, as we discussed. Ensure it's integrated with the existing CLI structure."  
   * **AI:** Provides the argparse code. You review, test, and accept.  
3. **DSPy Module Design (Using "Refactoring" / "Documentation" Custom Modes):**  
   * **You (with "Refactoring Mode" active):** "Now, design the dspy.Signature for CodeExplanation and a simple dspy.Predict module. Ensure inputs are code\_snippet: str and explanation\_style: str, and output is explanation: str. It *must* include type hints and a Google-style docstring."  
   * **AI:** Generates the DSPy code.  
   * **You (if needed, with "Documentation Mode" active):** "That's great. Can you add a more detailed usage example to the docstring for CodeExplanation?"  
4. **Local LLM Integration (Using "IMPLEMENT" Mode):**  
   * **You (in my\_cli\_app.py, with "IMPLEMENT" mode active):** "Now, within the explain subcommand's logic, show me how to call this CodeExplanation DSPy module, passing the file content (or selected line range) to code\_snippet. Remember, my local LLM is at http://localhost:8000/v1."  
   * **AI:** Provides the Python code for fetching file content (or a line range), calling the DSPy module, and printing the result.  
5. **Testing and Refinement (Using "Debugging" Mode):**  
   * **You:** Run python my\_cli\_app.py explain \--file my\_script.py \--line-range 10-20.  
   * **AI (in chat, if error, with "Debugging Mode" active):** "I received a TypeError. Here's the traceback: \[paste traceback\]. It looks like explanation\_style is not being passed correctly to the DSPy module. Suggest a fix."

### **Workflow Example 2: Debugging a llama.cpp Integration Issue**

**Goal:** Resolve an issue where your my\_ai\_cli tool isn't getting responses from the llama.cpp server.

1. **Initial Diagnosis (Using General Agent Mode):**  
   * **You:** "My my\_ai\_cli is not getting responses from the llama.cpp server. What are the common reasons for this, and what should I check first?"  
   * **AI:** Suggests checking server status, port, firewall, model path, and api\_base URL in your dspy.OpenAI config.  
2. **Check Server Status (Using "Bash Generation Mode"):**  
   * **You (with "Bash Generation Mode" active):** "How can I check if the llama.cpp server is actively listening on port 8000 on Windows/MSYS2?"  
   * **AI:** netstat \-ano | grep :8000 or lsof \-i :8000 (adjusting for MSYS2 context).  
   * **You:** Run the command in your terminal. (Assume you find it's not running).  
3. **Restart Server (Using "Bash Generation Mode" and Allowlisted Command):**  
   * **You (with "Bash Generation Mode" active):** "Okay, the server isn't running. Provide the exact command to restart llama.cpp server with Vulkan, API server, host, port, and my model Llama-3-8B-Instruct-Q4\_K\_M.gguf located in ./models/ within the llama.cpp directory."  
   * **AI:** ./server \--gpu vulkan \--api-server \--host 0.0.0.0 \--port 8000 \-m ./models/Llama-3-8B-Instruct-Q4\_K\_M.gguf  
   * **You:** Execute the command in a *separate* terminal, ensuring it's running.  
4. **Verify DSPy Configuration (Using General Agent Mode):**  
   * **You (in Cursor, my\_cli\_app.py open, with General Agent mode active):** "Double-check the dspy.settings.configure call in my\_cli\_app.py. Does the api\_base exactly match http://localhost:8000/v1? Are there any typos?"  
   * **AI:** Reviews the code and confirms or points out discrepancies.

### **Workflow Example 3: Refactoring a Core Utility for ruff Compliance**

**Goal:** Improve a Python utility function used by your CLI to meet ruff standards and enhance readability.

1. **Initial Scan (Manual or AI-assisted):**  
   * Run ruff check . in your terminal to identify linting issues.  
   * **You (in Cursor, relevant file open):** "I have a utils.py file with a read\_file\_content function that ruff is complaining about (e.g., line too long, no docstring). Here's the function: \[paste function code\]. How can I refactor this to satisfy ruff and be more readable?"  
2. **Refactor with AI (Using "Refactoring Mode"):**  
   * **You (with "Refactoring Mode" active):** "Refactor this read\_file\_content function. It needs to be PEP 8 compliant, have a Google-style docstring, include type hints, and handle FileNotFoundError gracefully by returning an empty string. Here's the current code: \[paste code\]"  
   * **AI:** Provides the refactored code.  
3. **Apply and Verify:**  
   * **You:** Review the AI's suggested code in Cursor's diff view, accept the changes.  
   * **You:** Run ruff check utils.py and ruff format utils.py in your terminal.  
   * **AI (if ruff still reports issues, with "Debugging Mode" active):** "ruff is still flagging E501 (line too long) on line X in utils.py. Can you adjust the line breaking in the provided function?"

By leveraging Cursor's explicit custom mode feature, you can set up these specialized AI behaviors once and activate them with a click, significantly streamlining your development workflows for the "Local AI CLI Assistant" project.