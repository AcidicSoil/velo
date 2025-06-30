#!/bin/bash

# Project-specific sandbox initialization
echo "🔧 Loading Velo project-specific configuration..."

# Set up any project-specific environment variables
export VELO_CONFIG_DIR="/workspace/.gemini"
export VELO_CACHE_DIR="/workspace/.gemini/cache"

# Create necessary directories
mkdir -p "$VELO_CACHE_DIR"

# Install any project-specific Python packages
if [ -f "/workspace/requirements.txt" ]; then
    echo "📦 Installing Python requirements..."
    pip install -r /workspace/requirements.txt
fi

# Install any project-specific npm packages
if [ -f "/workspace/package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    cd /workspace && npm install
fi

echo "✅ Velo project initialization complete!"