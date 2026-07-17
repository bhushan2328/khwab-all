#!/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "========== Repository Status =========="
for repo in khwab khwab-core khwab-integration; do
  echo ""
  echo ">>> $repo"
  cd "$ROOT/$repo"
  git status --short
done
