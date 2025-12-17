#!/usr/bin/env bash
set -e

echo "Running post-create setup..."
if [ -f requirements.txt ]; then
  python -m pip install --upgrade pip
  python -m pip install -r requirements.txt
fi

# Install cs50 library and common CLI tools via pipx if available
python -m pip install --upgrade pip
if command -v pipx >/dev/null 2>&1; then
  pipx install --system-site-packages cs50 check50 submit50 || true
else
  python -m pip install cs50 check50 submit50 || true
fi

# Install nvm and latest LTS node for vscode user
export HOME=/workspace
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash || true
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts || true
fi

# Install common global npm packages
if command -v npm >/dev/null 2>&1; then
  npm install -g eslint typescript || true
fi

# Install rust toolchain for user
if [ -x "$(command -v rustup)" ]; then
  rustup default stable || true
fi

echo "Setup complete."