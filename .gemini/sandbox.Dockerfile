# Base this on the gemini-cli sandbox image
FROM gemini-cli-sandbox

# Install additional tools from your .bashrc configuration
RUN apt-get update && apt-get install -y --no-install-recommends \
  # Python packages for DSPy (mentioned in your MASTERPLAN.md)
  python3-pip \
  python3-venv \
  python3-dev \
  # EZA (modern ls replacement)
  && wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - \
  | tar xz -C /usr/local/bin eza \
  # Additional development tools
  && apt-get install -y --no-install-recommends \
  vim \
  nano \
  tree \
  curl \
  wget \
  htop \
  tmux \
  screen \
  # Rust (for potential future use)
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set up Rust environment for node user
USER node
RUN echo 'source $HOME/.cargo/env' >> ~/.bashrc
ENV PATH="/home/node/.cargo/bin:$PATH"

# Install Python dependencies for DSPy
RUN pip3 install --no-cache-dir --user \
  dspy \
  llama-cpp-python \
  pyyaml \
  requests \
  jinja2 \
  click \
  typer \
  rich

# Set up NVM for container environment
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
  && export NVM_DIR="/home/node/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && nvm install --lts \
  && nvm use --lts

# Set up a working directory for velo-specific configurations
RUN mkdir -p /app/velo-config
USER root
RUN chown -R node:node /app/velo-config
USER node

# Set environment variables for your project
ENV VELO_ENV=sandbox
ENV PYTHONPATH="/app/velo-config:$PYTHONPATH"
ENV NVM_DIR="/home/node/.nvm"

# Ensure paths are set correctly
ENV PATH="/home/node/.nvm/versions/node/$(ls /home/node/.nvm/versions/node 2>/dev/null | head -1)/bin:/home/node/.local/bin:/home/node/.cargo/bin:$PATH"

# Default entrypoint remains gemini
CMD ["gemini"]