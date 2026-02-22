#!/bin/bash
# ─────────────────────────────────────────────
# build.sh — one-command build for this JUCE plugin
# Usage:
#   ./build.sh              Build Debug (default)
#   ./build.sh release      Build Release
#   ./build.sh test         Build Debug + run tests
#   ./build.sh clean        Remove build artifacts
# ─────────────────────────────────────────────
set -euo pipefail

BUILD_DIR="Builds"
BUILD_TYPE="${1:-debug}"

# Normalize input
BUILD_TYPE=$(echo "$BUILD_TYPE" | tr '[:upper:]' '[:lower:]')

# ── Helpers ──────────────────────────────────
check_deps() {
    local missing=()
    command -v cmake >/dev/null 2>&1 || missing+=("cmake")
    command -v ninja >/dev/null 2>&1 || missing+=("ninja")

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "❌ Missing required tools: ${missing[*]}"
        echo ""
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "   Install with:  brew install ${missing[*]}"
        elif [[ "$(uname)" == "Linux" ]]; then
            echo "   Install with:  sudo apt install ${missing[*]}"
        fi
        exit 1
    fi
}

check_submodules() {
    if [[ ! -f "JUCE/CMakeLists.txt" ]]; then
        echo "📦 Initializing submodules (first time only)..."
        git submodule update --init --recursive
    fi
}

configure() {
    local cmake_build_type="$1"
    echo "⚙️  Configuring ($cmake_build_type)..."
    cmake -B "$BUILD_DIR" -G Ninja -DCMAKE_BUILD_TYPE="$cmake_build_type"
}

build() {
    local cmake_build_type="$1"
    echo "🔨 Building ($cmake_build_type)..."
    cmake --build "$BUILD_DIR" --config "$cmake_build_type"
    echo "✅ Build complete!"
}

run_tests() {
    echo "🧪 Running tests..."
    cd "$BUILD_DIR"
    ctest --verbose --output-on-failure
    cd ..
}

# ── Main ─────────────────────────────────────
check_deps
check_submodules

case "$BUILD_TYPE" in
    debug)
        configure "Debug"
        build "Debug"
        echo ""
        echo "🎹 Run the standalone plugin:"
        echo "   open $BUILD_DIR/Pamplejuce_artefacts/Debug/Standalone/*.app"
        ;;
    release)
        configure "Release"
        build "Release"
        ;;
    test)
        configure "Debug"
        build "Debug"
        run_tests
        ;;
    clean)
        echo "🗑️  Cleaning build artifacts..."
        rm -rf "$BUILD_DIR"
        echo "✅ Clean!"
        ;;
    *)
        echo "Usage: ./build.sh [debug|release|test|clean]"
        exit 1
        ;;
esac
