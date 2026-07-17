#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$GITHUB_PAT" ]; then
    echo "ERROR: GITHUB_PAT is not set."
    echo "Run:"
    echo 'export GITHUB_PAT="your_personal_access_token"'
    exit 1
fi

echo "========================================="
echo "PUSHING ALL KHWAB REPOSITORIES"
echo "========================================="

for repo in khwab khwab-core khwab-integration
do
    echo ""
    echo ">>> $repo"

    cd "$ROOT/$repo"

    BRANCH=$(git branch --show-current)

    if [ -n "$(git status --porcelain)" ]; then
        echo "Repository '$repo' has uncommitted changes."
        echo "Please commit them first."
        exit 1
    fi

    URL=$(git remote get-url origin)
    URL=${URL#https://github.com/}

    git -c credential.helper= push \
    "https://bhushan2328:${GITHUB_PAT}@github.com/${URL}" \
    "$BRANCH"
done

echo ""
echo ">>> Updating khwab-all"

cd "$ROOT"

git add .

if ! git diff --cached --quiet; then
    git commit -m "Update submodule references"
fi

BRANCH=$(git branch --show-current)

git -c credential.helper= push \
"https://bhushan2328:${GITHUB_PAT}@github.com/bhushan2328/khwab-all.git" \
"$BRANCH"

echo ""
echo "========================================="
echo "SUCCESS!"
echo "All repositories are synchronized."
echo "========================================="
