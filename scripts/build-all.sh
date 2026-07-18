#!/usr/bin/env bash

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "========================================"
echo "Building Khwab Workspace"
echo "========================================"

cd "$ROOT/khwab"

chmod +x gradlew

./gradlew build

echo ""
echo "========================================"
echo "✅ Khwab workspace build completed successfully!"
echo "========================================"
