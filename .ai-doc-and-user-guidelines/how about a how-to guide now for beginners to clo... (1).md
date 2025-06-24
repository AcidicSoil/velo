# **Beginner's Guide: Setting Up Your Local AI CLI Environment**

This guide will walk you through setting up the powerful local AI CLI environment, enabling you to run large language models (LLMs) on your AMD GPU (RX 6750 XT) for a fast and efficient developer workflow.

## **Prerequisites**

Before you begin, ensure you have the following ready:

1. **Windows 11:** Your operating system.  
2. **MSYS2/bash:** A Unix-like environment for Windows (already installed and confirmed working). This provides tools like git and make.  
3. **AMD Radeon RX 6750 XT:** Your GPU.  
4. **GPU Acceleration (Vulkan):** Ensure your AMD drivers and Vulkan runtime are correctly installed and working.  
5. **Python:** Installed system-wide.  
6. **Terminal:** You'll be primarily using the bash shell within your MSYS2 environment.

## **Step 1: Set up llama.cpp for AMD GPU Acceleration**

llama.cpp is the core engine that will run your local LLMs. We need to compile it with Vulkan support to utilize your AMD GPU.

### **1.1. Clone llama.cpp**

Open your MSYS2 bash terminal and run:

git clone https://github.com/ggerganov/llama.cpp.git  
cd llama.cpp

* git clone ...: This command downloads the llama.cpp project from GitHub to your computer.  
* cd llama.cpp: This command changes your current directory to the newly downloaded llama.cpp folder.

### **1.2. Compile llama.cpp with Vulkan Support**

While still in the llama.cpp directory, run the compilation command:

make LLAMA\_VULKAN=1

* make LLAMA\_VULKAN=1: This command compiles llama.cpp. The LLAMA\_VULKAN=1 part is crucial – it tells the compilation process to include support for your Vulkan-enabled AMD GPU. This might take a few minutes.  
  * **Troubleshooting Note:** If make or C++ compilation tools are not found, you might need to install them within MSYS2. For example, pacman \-Syu mingw-w64-x86\_64-toolchain.

## **Step 2: Download a Local LLM (GGUF Format)**

You'll need a model to run. These models are typically in the .gguf format, which llama.cpp understands. A good starting point is a quantized Llama-3 model.

### **2.1. Choose and Download a Model**

Navigate to a trusted source for GGUF models (e.g., Hugging Face) and download a suitable model. For instance, a Llama-3 8B (8 Billion parameters) quantized model like Llama-3-8B-Instruct-Q4\_K\_M.gguf is a good balance of size and performance for many systems.

* **Recommendation:** Download the model into a dedicated models folder within your llama.cpp directory, or a separate models directory you create elsewhere, for organization.  
  \# Example: Create a models directory inside llama.cpp  
  mkdir ./models  
  \# Then download your chosen .gguf file into this directory,  
  \# e.g., move it from your browser's downloads folder.

## **Step 3: Run llama.cpp as an OpenAI API Emulation Server**

This step is vital for DSPy to communicate with your local LLM. llama.cpp can mimic the OpenAI API, making integration seamless.

### **3.1. Start the Server**

Open a **new** MSYS2 bash terminal. Navigate back to your llama.cpp directory (if you're not there) and run:

cd /path/to/llama.cpp \# If you're not already in the llama.cpp directory  
./server \--gpu vulkan \--api-server \--host 0.0.0.0 \--port 8000 \-m ./models/Llama-3-8B-Instruct-Q4\_K\_M.gguf

* ./server: This executes the llama.cpp server program you just compiled.  
* \--gpu vulkan: Tells the server to use your AMD GPU via Vulkan for inference.  
* \--api-server: Activates the OpenAI API emulation.  
* \--host 0.0.0.0 \--port 8000: Makes the server accessible on your local network at http://localhost:8000.  
* \-m ./models/Llama-3-8B-Instruct-Q4\_K\_M.gguf: Specifies the path to your downloaded GGUF model. **Remember to change Llama-3-8B-Instruct-Q4\_K\_M.gguf to the actual filename of your model.**  
* **Important:** Keep this terminal window open. This server needs to be running in the background for your CLI tool to function.

## **Step 4: Set up Your Python Project with uv and ruff**

Now, let's create your Python project where your CLI tool and DSPy programs will live.

### **4.1. Create Your Project Directory**

Create a new directory for your AI CLI project.

cd \~ \# Go back to your home directory or any preferred location  
mkdir my\_ai\_cli\_project  
cd my\_ai\_cli\_project

### **4.2. Install uv (if not already installed)**

uv is a fast Python package manager.

\# First, ensure you have pip installed for this initial step  
python \-m ensurepip \--default-pip  
python \-m pip install uv

### **4.3. Create a Virtual Environment with uv**

A virtual environment keeps your project's Python dependencies isolated from your system Python.

uv venv .venv

* uv venv .venv: This creates a new virtual environment named .venv in your my\_ai\_cli\_project directory.

### **4.4. Activate Your Virtual Environment**

You **must** activate the virtual environment every time you open a new terminal session to work on your project.

source .venv/bin/activate

* You'll know it's active because your terminal prompt will usually show (.venv) at the beginning.  
* **For Windows CMD/PowerShell:** If you switch to a different terminal, the activation command is usually .\\.venv\\Scripts\\activate.

### **4.5. Install Project Dependencies with uv**

Now, install DSPy and the openai Python client (which DSPy uses to talk to your llama.cpp server) and ruff.

uv pip install dspy openai ruff

* dspy: The declarative AI framework.  
* openai: The client library DSPy uses to communicate with the llama.cpp OpenAI API emulation.  
* ruff: For linting and formatting your Python code.

### **4.6. Configure ruff (Optional but Recommended)**

You can create a pyproject.toml file in your my\_ai\_cli\_project directory to configure ruff.

Create a file named pyproject.toml and add:

\[tool.ruff\]  
\# Enable all Linter rules  
select \= \["ALL"\]  
\# Exclude certain rules that might be too strict initially or conflict  
ignore \= \[  
    "E501", \# Line too long (often handled by formatter)  
    "D",    \# Disable all pydocstyle checks for now  
\]  
line-length \= 120 \# Adjust as per your preference

\[tool.ruff.format\]  
\# Enable formatting features  
docstring-code-format \= true  
quote-style \= "double"  
indent-style \= "space"

## **Step 5: Start Building Your CLI Tool (Example with DSPy)**

Now that your environment is ready, you can start writing your Python code.

### **5.1. Create a Simple DSPy Program**

Create a file named my\_cli\_app.py in your my\_ai\_cli\_project directory.

\# my\_cli\_app.py  
import dspy  
import openai \# DSPy uses this internally, but good to know it's there  
import os

\# 1\. Configure the local LLM  
\# This tells DSPy to use the OpenAI API compatible server run by llama.cpp  
\# The base URL should match where your llama.cpp server is listening (localhost:8000)  
\# 'lm' stands for Language Model  
local\_lm \= dspy.OpenAI(  
    model='your-local-model', \# You can name this anything, or match the actual model name if llama.cpp provides it  
    api\_base='http://localhost:8000/v1',  
    api\_key='sk-no-key-required' \# A placeholder, as llama.cpp doesn't require a key  
)  
dspy.settings.configure(lm=local\_lm)

\# 2\. Define a DSPy Signature  
\# A Signature defines the inputs and outputs for a single LLM call.  
\# This signature takes a 'question' and expects a 'code\_snippet' as output.  
class BashCommandGenerator(dspy.Signature):  
    """Generates a bash command to achieve a specific task."""  
    question: str \= dspy.InputField(desc="The task described in natural language.")  
    bash\_command: str \= dspy.OutputField(desc="The corresponding bash command.")

\# 3\. Define a DSPy Module  
\# A Module wraps one or more DSPy Signatures or other Modules.  
\# Here, we're using dspy.Predict which is a simple module for a single LLM call.  
class GenerateBashCommand(dspy.Module):  
    def \_\_init\_\_(self):  
        super().\_\_init\_\_()  
        self.generate\_command \= dspy.Predict(BashCommandGenerator)

    def forward(self, question):  
        prediction \= self.generate\_command(question=question)  
        return prediction.bash\_command

\# 4\. Simple CLI logic to use the DSPy Module  
if \_\_name\_\_ \== "\_\_main\_\_":  
    print("Local AI CLI: Bash Command Generator")  
    print("-----------------------------------")  
    print("Type a question (e.g., 'list all python files recursively in current directory')")  
    print("Type 'exit' to quit.")

    bash\_generator \= GenerateBashCommand()

    while True:  
        user\_input \= input("\\nYour task (natural language): ")  
        if user\_input.lower() \== 'exit':  
            break

        if not user\_input.strip():  
            print("Please enter a question.")  
            continue

        try:  
            print("Thinking...")  
            \# Call the DSPy module with the user's input  
            command \= bash\_generator.forward(question=user\_input)  
            print(f"\\nGenerated Bash Command:\\n{command}")  
        except Exception as e:  
            print(f"An error occurred: {e}")  
            print("Ensure your llama.cpp server is running and accessible at http://localhost:8000/v1.")

### **5.2. Run Your CLI Tool**

Make sure your llama.cpp server is still running in its separate terminal window. Then, in your my\_ai\_cli\_project terminal (with the .venv activated), run:

python my\_cli\_app.py

You should now be able to type natural language questions, and your local LLM (via llama.cpp and DSPy) will attempt to generate a corresponding bash command\!

## **Congratulations\!**

You've successfully set up your local AI CLI environment. You have llama.cpp running on your AMD GPU, a local GGUF model serving requests, and a basic DSPy program interacting with it through your Python CLI. From here, you can expand your my\_cli\_app.py with more complex DSPy programs, integrate context management (MCP), and build out more sophisticated CLI features.