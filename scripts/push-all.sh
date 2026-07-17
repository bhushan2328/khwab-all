#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "========== Pushing repositories =========="
for repo in khwab khwab-core khwab-integration; do
  echo ""
  echo ">>> $repo"
  cd "$ROOT/$repo"
  BRANCH=$(git branch --show-current)
  git push origin "$BRANCH"
done
echo ""
echo "✅ Push completed."
