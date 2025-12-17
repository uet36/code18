#!/usr/bin/env bash
set -euo pipefail

# Simple check script for Codespaces:
# - run check50 and save JSON result to .check50/result.json
# - commit and push the file to the repository (main branch)

mkdir -p .check50

# Run check50 and write output to .check50/result.json
# (This sends both stdout and stderr into the file so debugging info is preserved.)
check50 --json . > .check50/result.json 2>&1 || true

git add .check50/result.json
git commit -m "Check result at $(date)" || echo "No changes to commit"
git push origin $(git rev-parse --abbrev-ref HEAD)

echo "Check result saved and pushed" 
