#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <assignmentId> [backendUrl]

Example: $0 week1 https://platform.example.com"
  exit 1
fi

ASSIGNMENT="$1"
BACKEND_URL="${2:-${PLATFORM_BACKEND_URL:-https://localhost:3000}}"
REPO_FULLNAME="${REPO_FULLNAME:-$(git config --get remote.origin.url | sed -E 's|.*[:/](.+/.+)(\.git)?$|\1|') }"
BRANCH="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
TOKEN="${PLATFORM_TOKEN:-${GITHUB_TOKEN:-}}"

if [ -z "$TOKEN" ]; then
  echo "Missing token. Set PLATFORM_TOKEN or GITHUB_TOKEN in environment or Codespaces secrets."
  exit 2
fi

# ensure check50/submit50 installed
python3 -m pip install --user check50 submit50 >/dev/null
export PATH="$HOME/.local/bin:$PATH"

OUTFILE=$(mktemp)
STATUS="fail"
SUMMARY=""

# Example: run check50 against a tests repo you maintain
# Adjust below to your specific tests or adapt to run local tests
if check50 --version >/dev/null 2>&1; then
  echo "Running check50 for $ASSIGNMENT..."
  # Replace 'my-org/my-tests/$ASSIGNMENT' with your test suite
  if check50 "my-org/my-tests/$ASSIGNMENT" > "$OUTFILE" 2>&1; then
    STATUS="success"
  else
    STATUS="fail"
  fi
  SUMMARY=$(head -n 10 "$OUTFILE" | tr -d '\n' | sed 's/"/\\"/g')
else
  echo "check50 not available"
  echo "Installing..."
  python3 -m pip install --user check50
  export PATH="$HOME/.local/bin:$PATH"
  echo "Please re-run the command"
  exit 3
fi

RAW=$(jq -Rs '.' < "$OUTFILE")

PAYLOAD=$(jq -n \
  --arg assignmentId "$ASSIGNMENT" \
  --arg repoFullName "$REPO_FULLNAME" \
  --arg branch "$BRANCH" \
  --arg tool "check" \
  --arg status "$STATUS" \
  --arg summary "$SUMMARY" \
  '{ assignmentId:$assignmentId, repoFullName:$repoFullName, branch:$branch, tool:$tool, status:$status, summary:$summary, rawResult:$RAW }')

echo "Reporting result to $BACKEND_URL/api/tools/report"
http_status=$(curl -s -o /dev/stderr -w "%{http_code}" -X POST "$BACKEND_URL/api/tools/report" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

if [ "$http_status" -ge 200 ] && [ "$http_status" -lt 300 ]; then
  echo "Reported successfully"
  exit 0
else
  echo "Report failed with HTTP $http_status"
  exit 4
fi
