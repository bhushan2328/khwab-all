#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "========== Pulling repositories =========="
for repo in khwab khwab-core khwab-integration; do
  echo ""
  echo ">>> $repo"
  cd "$ROOT/$repo"
  BRANCH=$(git branch --show-current)
  git pull origin "$BRANCH"
done
echo ""
echo "✅ Pull completed."
