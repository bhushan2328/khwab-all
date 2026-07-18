#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPOS=("khwab" "khwab-core" "khwab-integration")

echo "=========================================="
echo "KHWAB WORKSPACE CHECK"
echo "=========================================="

echo
echo "STEP 1 : Repository Status"
for REPO in "${REPOS[@]}"; do
    echo
    echo ">>> $REPO"
    (
        cd "$ROOT/$REPO"
        git status --short
    )
done

echo
echo "STEP 2 : Stage Changes"
for REPO in "${REPOS[@]}"; do
    (
        cd "$ROOT/$REPO"
        git add .
    )
done

cd "$ROOT"
git add .

echo
read -rp "Enter commit message: " MESSAGE

echo
echo "STEP 3 : Commit"

for REPO in "${REPOS[@]}"; do
    echo
    echo ">>> $REPO"
    (
        cd "$ROOT/$REPO"
        if git diff --cached --quiet; then
            echo "No changes."
        else
            git commit -m "$MESSAGE"
        fi
    )
done

echo
echo ">>> khwab-all"
cd "$ROOT"

if git diff --cached --quiet; then
    echo "No changes."
else
    git commit -m "$MESSAGE"
fi

echo
echo "STEP 4 : Build Khwab"

cd "$ROOT/khwab"
chmod +x gradlew

if ! ./gradlew build; then
    echo
    echo "=========================================="
    echo "❌ Build failed."
    echo "Push cancelled."
    echo "=========================================="
    exit 1
fi

echo
echo "=========================================="
echo "✅ Build successful."
echo "=========================================="

echo
echo "STEP 5 : Push"

cd "$ROOT"
./scripts/push-all.sh

echo
echo "=========================================="
echo "✅ Workspace checked successfully."
echo "✅ Commit completed."
echo "✅ Build successful."
echo "✅ All repositories pushed."
echo "=========================================="
