#!/bin/bash

# =============================================================================
# Velo Project Sandbox Environment Configuration
# =============================================================================

# Set up velo project environment
export VELO_PROJECT_ROOT=/workspace
export PATH="$PATH:/workspace/bin:/workspace/scripts"

# =============================================================================
# EZA Bash Completion (from your .bashrc)
# =============================================================================
_eza() {
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case "$prev" in
        --help|-v|--version|--smart-group)
            return
            ;;
        --colour)
            mapfile -t COMPREPLY < <(compgen -W 'always automatic auto never' -- "$cur")
            return
            ;;
        --icons)
            mapfile -t COMPREPLY < <(compgen -W 'always automatic auto never' -- "$cur")
            return
            ;;
        -L|--level)
            mapfile -t COMPREPLY < <(compgen -W '{0..9}' -- "$cur")
            return
            ;;
        -s|--sort)
            mapfile -t COMPREPLY < <(compgen -W 'name filename Name Filename size filesize extension Extension date time modified changed accessed created type inode oldest newest age none --' -- "$cur")
            return
            ;;
        -t|--time)
            mapfile -t COMPREPLY < <(compgen -W 'modified changed accessed created --' -- "$cur")
            return
            ;;
        --time-style)
            mapfile -t COMPREPLY < <(compgen -W 'default iso long-iso full-iso relative +FORMAT --' -- "$cur")
            return
            ;;
        --color-scale)
            mapfile -t COMPREPLY < <(compgen -W 'all age size --' -- "$cur")
            return
            ;;
        --color-scale-mode)
            mapfile -t COMPREPLY < <(compgen -W 'fixed gradient --' -- "$cur")
            return
            ;;
        --absolute)
            mapfile -t COMPREPLY < <(compgen -W 'on follow off --' -- "$cur")
            return
            ;;
    esac

    case "$cur" in
        --*)
            parse_help=$(eza --help 2>/dev/null | grep -oE ' (--[[:alnum:]@-]+)' | tr -d ' ' | grep -v '\--colo' || echo "")
            completions=$(echo '--color --colour --color-scale --colour-scale --color-scale-mode --colour-scale-mode' "$parse_help")
            mapfile -t COMPREPLY < <(compgen -W "$completions" -- "$cur")
            ;;
        -*)
            completions=$(eza --help 2>/dev/null | grep -oE ' (-[[:alnum:]@])' | tr -d ' ' || echo "")
            mapfile -t COMPREPLY < <(compgen -W "$completions" -- "$cur")
            ;;
        *)
            _filedir
            ;;
    esac
}

# Only set up eza completion if eza is available
if command -v eza >/dev/null 2>&1; then
    complete -o filenames -o bashdefault -F _eza eza

    # EZA & LS Shortcuts
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias tree='eza --tree'
else
    # Fallback to regular ls if eza is not available
    alias ll='ls -l'
    alias la='ls -la'
    alias tree='tree'
fi

# =============================================================================
# NVM (Node Version Manager) setup - Container adapted
# =============================================================================
export NVM_DIR="/home/node/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"  # Loads nvm
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    \. "$NVM_DIR/bash_completion"  # Loads nvm bash_completion
fi

# Auto-use Node version from .nvmrc if available
if [ -f .nvmrc ]; then
    nvm use > /dev/null 2>&1
fi

# =============================================================================
# Rust Cargo bin to PATH (if Rust is installed in container)
# =============================================================================
if [ -d "/home/node/.cargo/bin" ]; then
    export PATH="/home/node/.cargo/bin:$PATH"
fi

# =============================================================================
# LM Studio API config (adapted for container)
# =============================================================================
export OPENAI_API_KEY="${OPENAI_API_KEY:-1234}"
export OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://host.docker.internal:1234/v1}"
export OLLAMA_MODEL="${OLLAMA_MODEL:-osmosis-ai/osmosis-mcp-4b@q4_k_s}"

# =============================================================================
# Gemini CLI Configuration
# =============================================================================
export GEMINI_CODE_ASSIST="${GEMINI_CODE_ASSIST:-true}"
export GEMINI_API_KEY="${GEMINI_API_KEY}"
export GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.0-flash-exp}"

# =============================================================================
# Python Virtual Environment for DSPy
# =============================================================================
if [ ! -d "/workspace/.gemini/sandbox.venv" ]; then
    echo "🔧 Setting up Python virtual environment for DSPy..."
    python3 -m venv /workspace/.gemini/sandbox.venv

    # Activate and install essential packages
    source /workspace/.gemini/sandbox.venv/bin/activate
    pip install --upgrade pip
    pip install dspy llama-cpp-python pyyaml requests jinja2
    echo "✅ Python virtual environment setup complete!"
else
    echo "🐍 Activating existing Python virtual environment..."
fi

# Activate the virtual environment
source /workspace/.gemini/sandbox.venv/bin/activate

# =============================================================================
# Velo Project Aliases and Functions
# =============================================================================
alias velo-analyze="python3 /workspace/scripts/analyze.py"
alias velo-test="python3 /workspace/scripts/test.py"
alias velo-generate="python3 /workspace/scripts/generate.py"
alias velo-explain="python3 /workspace/scripts/explain.py"

# Enhanced codex alias for container environment
alias codex='codex --provider ollama'

# Gemini CLI with common options
alias gemini-analyze='gemini -p "analyze the project structure"'
alias gemini-test='gemini -p "run tests and show results"'
alias gemini-explain='gemini -p "explain the code structure and purpose"'

# =============================================================================
# Development Utilities
# =============================================================================

# Function to check if required tools are available
check_tools() {
    echo "🔍 Checking available tools..."

    tools=("python3" "pip" "node" "npm" "git" "curl" "jq")

    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "✅ $tool: $(which "$tool")"
        else
            echo "❌ $tool: not found"
        fi
    done

    echo ""
    echo "🐍 Python packages:"
    pip list 2>/dev/null | grep -E "(dspy|llama|yaml|requests|jinja)" || echo "No DSPy-related packages found"

    echo ""
    echo "📦 Node.js version: $(node --version 2>/dev/null || echo 'Not available')"
    echo "📦 NPM version: $(npm --version 2>/dev/null || echo 'Not available')"
}

# Function to show velo project status
velo_status() {
    echo "🚀 Velo Project Status"
    echo "====================="
    echo "Working directory: $(pwd)"
    echo "Python environment: $(which python3)"
    echo "Virtual env: ${VIRTUAL_ENV:-'Not activated'}"
    echo "Git branch: $(git branch --show-current 2>/dev/null || echo 'Not a git repo')"
    echo "Gemini model: ${GEMINI_MODEL}"
    echo "LM Studio URL: ${OLLAMA_BASE_URL}"
    echo ""

    if [ -f "/workspace/MASTERPLAN.md" ]; then
        echo "📋 MASTERPLAN.md found"
    fi

    if [ -f "/workspace/README.md" ]; then
        echo "📖 README.md found"
    fi

    if [ -f "/workspace/package.json" ]; then
        echo "📦 Node.js project detected"
    fi

    if [ -f "/workspace/requirements.txt" ] || [ -f "/workspace/pyproject.toml" ]; then
        echo "🐍 Python project detected"
    fi
}

# =============================================================================
# Container-specific PATH adjustments
# =============================================================================
export PATH="/usr/local/share/npm-global/bin:$PATH"
export PATH="/home/node/.local/bin:$PATH"

# =============================================================================
# Welcome Message
# =============================================================================
echo ""
echo "🚀 Velo Sandbox Environment Ready!"
echo "=================================="
echo "DSPy environment: $(which python3)"
echo "Working directory: $(pwd)"
echo "Container: ${SANDBOX:-'Unknown'}"
echo ""
echo "Available commands:"
echo "  📊 velo_status     - Show project status"
echo "  🔍 check_tools     - Check available tools"
echo "  🤖 gemini-analyze  - Quick project analysis"
echo "  🧪 velo-test       - Run velo tests"
echo ""
echo "Type 'velo_status' to see your project status."
echo ""

# =============================================================================
# Auto-load project configuration if available
# =============================================================================
if [ -f "/workspace/.gemini/sandbox-init.sh" ]; then
    echo "📝 Loading project-specific sandbox configuration..."
    source "/workspace/.gemini/sandbox-init.sh"
fi

# Change to workspace directory
cd /workspace 2>/dev/null || cd /