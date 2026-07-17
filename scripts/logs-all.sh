#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "========== Recent Commits =========="
for repo in khwab khwab-core khwab-integration; do
  echo ""
  echo ">>> $repo"
  cd "$ROOT/$repo"
  git log --oneline -5
done
