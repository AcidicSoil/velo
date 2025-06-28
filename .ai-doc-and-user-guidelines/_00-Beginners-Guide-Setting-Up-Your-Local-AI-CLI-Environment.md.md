# **Beginner's Guide: Setting Up Your Local AI CLI Environment**

This guide will walk you through setting up a powerful local AI CLI environment, enabling you to run large language models (LLMs) on your AMD GPU (RX 6750 XT) for a fast and efficient developer workflow. By following these steps, you'll establish the foundation for your "Local AI CLI Assistant" project.

## **Prerequisites**

Before you begin, ensure you have the following ready on your Windows 11 system:

1. **Windows 11 Operating System:** The environment where you'll be performing these steps.  
2. **MSYS2/bash:** A Unix-like environment for Windows. This provides essential tools like git for cloning repositories and cmake and make (or ninja) for compiling source code. Ensure your MSYS2 installation is up-to-date and the bash shell is your primary terminal.  
3. **AMD Radeon RX 6750 XT GPU:** Your dedicated graphics card, which llama.cpp will leverage for accelerated inference.  
4. **GPU Acceleration (Vulkan):** Confirm that your AMD graphics drivers are up-to-date and the Vulkan runtime is correctly installed and functioning on your system. This is crucial for llama.cpp to utilize your GPU.  
5. **Python:** A system-wide Python installation is required. We'll use uv for project-specific dependency management, but a base Python is necessary for uv itself.  
6. **Terminal Access:** You'll be primarily using the bash shell within your MSYS2 environment for all command-line operations.

## **Step 1: Set up llama.cpp for AMD GPU Acceleration**

llama.cpp is the core, high-performance C/C++ engine that will run your local LLMs. To utilize your AMD GPU, we need to compile it with specific Vulkan support using cmake.

### **1.1. Clone the llama.cpp Repository**

Open your MSYS2 bash terminal. This is where you'll enter all commands.

git clone https://github.com/ggerganov/llama.cpp.git  
cd llama.cpp

* git clone https://github.com/ggerganov/llama.cpp.git: This command downloads the entire llama.cpp project from its GitHub repository to a new llama.cpp folder in your current directory.  
* cd llama.cpp: This command changes your current working directory to the newly cloned llama.cpp folder. All subsequent commands in this step will be run from within this directory.

### **1.2. Compile llama.cpp with Vulkan Support using CMake**

Instead of directly using make, we will use cmake to configure the build and then make to compile. This is a more modern and robust approach for C/C++ projects.

First, create a build directory and navigate into it:

mkdir build  
cd build

Next, run cmake to configure the project, enabling Vulkan support:

cmake .. \-DLLAMA\_VULKAN=ON

* cmake ..: This command configures the build system. The .. tells cmake that the source code is in the parent directory (llama.cpp/).  
* \-DLLAMA\_VULKAN=ON: This flag is **critically important** as it tells cmake to enable the Vulkan backend, allowing llama.cpp to offload computations to your AMD GPU.

Finally, compile the project using the generated build files:

cmake \--build .

* cmake \--build .: This command compiles the project within the current build directory. On Windows with MSYS2, this will typically invoke make internally.  
* **Compilation Time:** This process can take several minutes, depending on your system's specifications. Please be patient.  
* **Troubleshooting Note:** If cmake or C++ compilation tools are not found (command not found or similar errors), you may need to install them within MSYS2. You can often do this using:  
  pacman \-Syu    \# Update package lists  
  pacman \-S \--needed base-devel mingw-w64-x86\_64-toolchain cmake

  After installation, close and reopen your MSYS2 bash terminal and try the cmake commands again.

## **Step 2: Download a Local Large Language Model (LLM) in GGUF Format**

To run llama.cpp, you need a pre-trained language model. These models are typically provided in the .gguf format, which is optimized for llama.cpp.

### **2.1. Choose and Download a GGUF Model**

Navigate to a trusted source for GGUF models, such as Hugging Face. Look for models compatible with llama.cpp.

* **Recommendation:** For your AMD Radeon RX 6750 XT and 64GB RAM, a quantized Llama-3 8B (8 Billion parameters) model, specifically a Q4\_K\_M quantization (e.g., Llama-3-8B-Instruct-Q4\_K\_M.gguf), offers a good balance of performance and quality for many tasks.  
* **Download Location:** It's highly recommended to organize your models. You can create a dedicated models folder inside your llama.cpp directory (or anywhere else convenient) and place your downloaded .gguf file there.  
  \# Example: Create a 'models' directory inside your llama.cpp folder  
  mkdir \-p \~/llama.cpp/models  
  \# Then, manually move your downloaded .gguf file (e.g., from your browser's downloads)  
  \# into this newly created directory: \~/llama.cpp/models/  
  \# For example: mv \~/Downloads/Llama-3-8B-Instruct-Q4\_K\_M.gguf \~/llama.cpp/models/

## **Step 3: Run llama.cpp as an OpenAI API Emulation Server**

This is a crucial step that allows other applications (like your Python CLI tool using DSPy) to communicate with your local LLM as if it were a remote OpenAI API service.

### **3.1. Start the llama.cpp Server**

Open a **new, separate** MSYS2 bash terminal window. This terminal will be dedicated to running the llama.cpp server in the background.

Navigate back to your original llama.cpp directory (the one containing the build folder you just created). The executable server will be located inside the build directory.

cd /path/to/llama.cpp \# Replace '/path/to/llama.cpp' with your actual path, e.g., 'cd \~/llama.cpp'  
./build/bin/server \--gpu vulkan \--api-server \--host 0.0.0.0 \--port 8000 \-m ./models/Llama-3-8B-Instruct-Q4\_K\_M.gguf

* ./build/bin/server: This executes the llama.cpp server program you compiled in Step 1\. Note the path now includes /build/bin/ as executables are typically placed there by cmake.  
* \--gpu vulkan: Instructs the server to use your AMD GPU via the Vulkan backend for all LLM inference.  
* \--api-server: Activates the OpenAI-compatible REST API endpoint. This is what DSPy will connect to.  
* \--host 0.0.0.0 \--port 8000: Configures the server to listen on all available network interfaces (0.0.0.0) on port 8000\. This means your Python application can access it at http://localhost:8000.  
* \-m ./models/Llama-3-8B-Instruct-Q4\_K\_M.gguf: Specifies the path to your downloaded GGUF model. **Remember to replace Llama-3-8B-Instruct-Q4\_K\_M.gguf with the exact filename of the model you downloaded in Step 2.1.**  
* **Important:** Keep this terminal window open and the llama.cpp server running for as long as you want your CLI tool to function. If you close this window, the server will stop, and your CLI tool will lose its connection to the LLM.

## **Step 4: Set up Your Python Project with uv and ruff**

Now, you'll create a dedicated Python project environment for your CLI tool and install the necessary libraries using uv, and configure ruff for code quality.

### **4.1. Create Your Project Directory**

Navigate to your home directory or any preferred location in your MSYS2 bash terminal (not the one running the llama.cpp server). Then, create a new directory for your AI CLI project:

cd \~ \# Go back to your home directory  
mkdir my\_ai\_cli\_project  
cd my\_ai\_cli\_project

### **4.2. Install uv (if not already installed)**

uv is a modern, fast Python package installer and virtual environment manager.

\# First, ensure your system's pip is up-to-date for uv installation  
python \-m pip install \--upgrade pip  
\# Now, install uv  
python \-m pip install uv

### **4.3. Create a Virtual Environment with uv**

A virtual environment is crucial for isolating your project's Python dependencies, preventing conflicts with other Python projects or your system's Python installation.

uv venv .venv

* uv venv .venv: This command creates a new virtual environment named .venv (a hidden directory) within your my\_ai\_cli\_project directory.

### **4.4. Activate Your Virtual Environment**

You **must** activate this virtual environment every time you open a new MSYS2 bash terminal session to work on your project. This ensures that the Python interpreter and packages associated with *this project's* environment are used.

source .venv/bin/activate

* **Verification:** You'll know the virtual environment is active because your terminal prompt will usually show (.venv) at the beginning of the line, like (.venv) user@host:\~/my\_ai\_cli\_project$.  
* **For Windows CMD/PowerShell Users:** If you happen to switch to a native Windows Command Prompt or PowerShell, the activation command is typically .\\.venv\\Scripts\\activate.

### **4.5. Install Project Dependencies with uv**

With your virtual environment active, install DSPy and the openai Python client (which DSPy uses to talk to your llama.cpp server) and ruff.

uv pip install dspy openai ruff

* dspy: The declarative AI framework for building LLM applications.  
* openai: The official OpenAI Python client library. DSPy internally uses this library to communicate with the llama.cpp server's OpenAI API emulation.  
* ruff: A very fast Python linter and code formatter that will help maintain code quality.

### **4.6. Configure ruff (Optional but Recommended)**

You can create a pyproject.toml file in the root of your my\_ai\_cli\_project directory to configure ruff. This file tells ruff which rules to apply and how to format your code.

Create a file named pyproject.toml (if it doesn't already exist) and add the following content:

\[tool.ruff\]  
\# Enable all Linter rules  
select \= \["ALL"\]  
\# Exclude certain rules that might be too strict initially or conflict with your preferences  
ignore \= \[  
    "E501", \# Ignore 'Line too long' \- often handled by automatic formatters or a matter of preference  
    "D",    \# Disable all pydocstyle (docstring) checks for now, if you prefer less strict docstring enforcement  
\]  
line-length \= 120 \# Set your preferred maximum line length. Adjust as needed.

\[tool.ruff.format\]  
\# Enable specific formatting features  
docstring-code-format \= true \# Automatically format code examples within docstrings  
quote-style \= "double"       \# Enforce double quotes for strings  
indent-style \= "space"       \# Enforce spaces for indentation

## **Step 5: Start Building Your CLI Tool (Example with DSPy)**

Now that your environment is fully set up and ready, you can begin writing the Python code for your CLI tool and integrate it with DSPy and your local LLM.

### **5.1. Create a Simple DSPy Program**

Create a new file named my\_cli\_app.py in the root of your my\_ai\_cli\_project directory. This file will contain the core logic for your CLI.

\# my\_cli\_app.py  
import dspy  
import os \# Imported for potential future file operations, though not directly used in this simple example

\# 1\. Configure the local LLM connection for DSPy  
\# This tells DSPy to use the OpenAI API compatible server that llama.cpp is running.  
\# The \`api\_base\` URL must match where your llama.cpp server is listening (localhost:8000).  
\# The \`api\_key\` is a placeholder, as llama.cpp's API emulation typically doesn't require one.  
\# 'lm' stands for Language Model, the default LLM DSPy will use.  
local\_lm \= dspy.OpenAI(  
    model='your-local-model', \# You can assign any descriptive name here, or match the actual model name if llama.cpp provides it.  
    api\_base='http://localhost:8000/v1',  
    api\_key='sk-no-key-required' \# This placeholder API key is common for local OpenAI API emulations.  
)  
dspy.settings.configure(lm=local\_lm) \# Apply the configuration globally for DSPy.

\# 2\. Define a DSPy Signature for a specific task  
\# A Signature acts as a blueprint, defining the inputs the LLM will receive and the outputs it's expected to produce.  
\# This signature takes a 'question' (natural language task) and aims to produce a 'bash\_command'.  
class BashCommandGenerator(dspy.Signature):  
    """  
    Generates a bash command to achieve a specific task described in natural language.  
    """  
    question: str \= dspy.InputField(desc="The task described in natural language.")  
    bash\_command: str \= dspy.OutputField(desc="The corresponding bash command to execute.")

\# 3\. Define a DSPy Module to encapsulate the LLM call  
\# A Module wraps one or more DSPy Signatures or other Modules, representing a step in an AI program.  
\# Here, we're using \`dspy.Predict\`, which is a simple module for a single LLM call based on a Signature.  
class GenerateBashCommand(dspy.Module):  
    def \_\_init\_\_(self):  
        super().\_\_init\_\_()  
        \# Initialize the Predict module with our BashCommandGenerator Signature  
        self.generate\_command \= dspy.Predict(BashCommandGenerator)

    def forward(self, question: str) \-\> str:  
        """  
        Processes a natural language question to generate a bash command.

        Args:  
            question: The natural language description of the task.

        Returns:  
            The generated bash command as a string.  
        """  
        \# Call the LLM using the defined Signature and input question  
        prediction \= self.generate\_command(question=question)  
        \# Return the extracted bash\_command from the LLM's prediction  
        return prediction.bash\_command

\# 4\. Simple CLI logic to interact with the DSPy Module  
if \_\_name\_\_ \== "\_\_main\_\_":  
    print("--- Local AI CLI: Bash Command Generator \---")  
    print("Type a task (e.g., 'list all python files recursively in current directory')")  
    print("Type 'exit' to quit.")  
    print("-------------------------------------------\\n")

    \# Instantiate our DSPy module  
    bash\_generator \= GenerateBashCommand()

    while True:  
        user\_input \= input("Your task (natural language, or 'exit'): ")  
        if user\_input.lower() \== 'exit':  
            print("Exiting CLI. Goodbye\!")  
            break

        if not user\_input.strip():  
            print("Please enter a question or 'exit' to quit.")  
            continue

        try:  
            print("AI thinking...")  
            \# Call the DSPy module's forward method with the user's input  
            command \= bash\_generator.forward(question=user\_input)  
            print(f"\\nGenerated Bash Command:\\n\>\>\> {command}\\n")  
        except Exception as e:  
            \# Basic error handling for issues with LLM call or connection  
            print(f"\\nAn error occurred: {e}")  
            print("Please ensure your 'llama.cpp' server is running and accessible at http://localhost:8000/v1.")  
            print("Check your terminal where llama.cpp server is running for detailed errors.")

### **5.2. Run Your CLI Tool**

Make sure your llama.cpp server is **still running** in its separate terminal window (from Step 3.1). Then, in your my\_ai\_cli\_project terminal (where your .venv is activated), run:

python my\_cli\_app.py

You should now be able to type natural language questions, and your local LLM (via llama.cpp and DSPy) will attempt to generate a corresponding bash command\!

## **Congratulations\!**

You've successfully set up your local AI CLI environment. You have llama.cpp running on your AMD GPU, a local GGUF model serving requests, and a basic DSPy program interacting with it through your Python CLI. From here, you can expand your my\_cli\_app.py with more complex DSPy programs, integrate context management (MCP), and build out more sophisticated CLI features.