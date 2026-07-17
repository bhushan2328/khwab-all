#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "========== Building khwab =========="
cd "$ROOT/khwab"
./gradlew build

echo ""
echo "========== Building khwab-core =========="
cd "$ROOT/khwab-core"
./gradlew build

echo ""
echo "========== Building khwab-integration =========="
cd "$ROOT/khwab-integration"
./gradlew build

echo ""
echo "✅ All builds completed successfully."
