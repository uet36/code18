#!/usr/bin/env bash
set -e

echo "Running post-create setup..."
if [ -f requirements.txt ]; then
  python -m pip install --upgrade pip
  python -m pip install -r requirements.txt
fi

echo "Setup complete."