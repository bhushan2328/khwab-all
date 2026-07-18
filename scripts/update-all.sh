#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================="
echo "      KHWAB WORKSPACE UPDATE"
echo "========================================="

echo ""
echo "STEP 1: Pull latest changes"
"$ROOT/scripts/pull-all.sh"

echo ""
echo "STEP 2: Repository status"
"$ROOT/scripts/status-all.sh"

echo ""
echo "STEP 3: Build all projects"
"$ROOT/scripts/build-all.sh"

echo ""
echo "STEP 4: Push all repositories"
"$ROOT/scripts/push-all.sh"

echo ""
echo "========================================="
echo "✅ Workspace update completed successfully!"
echo "========================================="
