#!/usr/bin/env bash
set -euo pipefail

# Simple submit script for Codespaces:
# - Ensure current branch is pushed to a dedicated `submit` branch so webhook can detect submission

CURRENT=$(git rev-parse --abbrev-ref HEAD)
echo "Preparing submit from branch: $CURRENT"

# Push to 'submit' branch (force update to reflect the latest work)
git push origin HEAD:submit --force

echo "Submitted (pushed to branch 'submit')"
