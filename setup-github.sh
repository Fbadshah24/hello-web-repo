#!/usr/bin/env bash
# Lightweight helper: create a GitHub repo using gh CLI and push the generated project.
# Usage: ./setup-github.sh <repo-name> [--private]
set -euo pipefail

REPO_NAME="${1:-hello-eks-deployment}"
PRIVATE_FLAG="${2:-}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install GitHub CLI or push manually."
  exit 1
fi

git init
git add .
git commit -m "Initial commit - hello-eks-deployment"
if [ "$PRIVATE_FLAG" = "--private" ]; then
  gh repo create "$REPO_NAME" --private --source=. --remote=origin --push
else
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
fi

echo "Repository created and pushed: $(gh repo view --json url -q .url)"
