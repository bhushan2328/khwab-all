#!/usr/bin/env bash
set -e

echo "========================================"
echo "Adding changes to all repositories"
echo "========================================"

repos=("khwab" "khwab-core" "khwab-integration")

for repo in "${repos[@]}"; do
    echo ""
    echo ">>> $repo"
    git -C "$repo" add .
done

echo ""
echo ">>> khwab-all"
git add .

echo ""
echo "✓ All changes staged successfully!"
