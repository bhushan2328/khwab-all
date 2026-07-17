#!/data/data/com.termux/files/usr/bin/bash

set -e

REPOS=(
  "khwab"
  "khwab-core"
  "khwab-integration"
)

for repo in "${REPOS[@]}"; do
  echo "=================================="
  echo "Adding changes: $repo"
  echo "=================================="

  (
    cd "$HOME/khwab-all/$repo"
    git add .
  )
done

echo
echo "✓ All repositories staged successfully."
