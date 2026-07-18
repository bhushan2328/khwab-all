#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/commit-all.sh \"Commit message\""
    exit 1
fi

MESSAGE="$1"

echo "========================================="
echo "COMMITTING ALL REPOSITORIES"
echo "========================================="

for repo in khwab khwab-core khwab-integration
do
    echo ""
    echo ">>> $repo"

    cd "$ROOT/$repo"

    if [ -n "$(git status --porcelain)" ]; then
        git add .
        git commit -m "$MESSAGE"
    else
        echo "No changes to commit."
    fi
done

echo ""
echo "========================================="
echo "All repositories committed."
echo "========================================="
