#!/usr/bin/env bash

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -z "$GITHUB_PAT" ]; then
    echo "ERROR: GITHUB_PAT is not set."
    echo "Run: source ~/.bashrc"
    exit 1
fi

push_repo() {
    local REPO="$1"

    echo
    echo "========================================"
    echo "Pushing $REPO"
    echo "========================================"

    cd "$ROOT/$REPO"

    BRANCH=$(git branch --show-current)

    if [ -z "$BRANCH" ]; then
        echo "ERROR: Detached HEAD in $REPO"
        exit 1
    fi

    URL=$(git remote get-url origin)
    URL=${URL#https://}

    git push "https://bhushan2328:${GITHUB_PAT}@${URL}" "$BRANCH"
}

# Push all repositories
push_repo "khwab"
push_repo "khwab-core"
push_repo "khwab-integration"

echo
echo "========================================"
echo "Updating khwab-all"
echo "========================================"

cd "$ROOT"

git add .

if ! git diff --cached --quiet; then
    git commit -m "Update submodule references"
fi

BRANCH=$(git branch --show-current)

if [ -z "$BRANCH" ]; then
    echo "ERROR: Detached HEAD in khwab-all"
    exit 1
fi

URL=$(git remote get-url origin)
URL=${URL#https://}

git push "https://bhushan2328:${GITHUB_PAT}@${URL}" "$BRANCH"

echo
echo "========================================"
echo "✓ All repositories pushed successfully!"
echo "========================================"
