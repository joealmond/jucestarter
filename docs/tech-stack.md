# Tech Stack

> **Purpose:** Agents read this to know what's installed and where to find docs.
> Keep it updated when adding or upgrading dependencies.

## Core

| Layer | Technology | Version | Docs |
|-------|-----------|---------|------|
| Framework | JUCE | develop (submodule) | [JUCE Docs](https://juce.com/learn/documentation/) |
| Language | C++ | C++23 | [cppreference](https://en.cppreference.com/w/cpp/23) |
| Build System | CMake | 3.25+ | [CMake Docs](https://cmake.org/cmake/help/latest/) |
| Template | Pamplejuce | latest | [Pamplejuce Manual](https://melatonin.dev/manuals/pamplejuce/) |
| CI/CD | GitHub Actions | — | [Actions Docs](https://docs.github.com/en/actions) |
| Testing | Catch2 | via CPM | [Catch2 Docs](https://github.com/catchorg/Catch2/blob/devel/docs/Readme.md) |
| Validation | pluginval | v1.0.3 | [pluginval GitHub](https://github.com/Tracktion/pluginval) |

## Plugin Formats

| Format | Status | Notes |
|--------|--------|-------|
| VST3 | Enabled | Default format |
| AU | Enabled | macOS only |
| AUv3 | Enabled | macOS/iOS |
| CLAP | Enabled | Via clap-juce-extensions submodule |
| Standalone | Enabled | For development/testing |

## Submodules

| Module | Path | Branch | Purpose |
|--------|------|--------|---------|
| JUCE | `JUCE/` | develop | Audio framework |
| cmake-includes | `cmake/` | main | Shared CMake helpers (Sudara's) |
| clap-juce-extensions | `modules/clap-juce-extensions/` | main | CLAP plugin format support |
| melatonin_inspector | `modules/melatonin_inspector/` | main | Runtime UI component inspector |

## Key CMake Modules

| File | Purpose |
|------|---------|
| `cmake/PamplejuceVersion.cmake` | Reads VERSION file, optional auto-bump |
| `cmake/CPM.cmake` | CPM.cmake package manager (pulls Catch2) |
| `cmake/SharedCodeDefaults.cmake` | C++23, fast-math, MSVC tweaks |
| `cmake/PamplejuceMacOS.cmake` | Universal binary config, min macOS version |
| `cmake/JUCEDefaults.cmake` | JUCE CMake defaults |
| `cmake/Assets.cmake` | BinaryData target for embedded assets |
| `cmake/Tests.cmake` | Test target configuration |
| `cmake/Benchmarks.cmake` | Benchmark target configuration |
| `cmake/Sanitizers.cmake` | ASAN/UBSAN support |
| `cmake/PamplejuceIPP.cmake` | Intel IPP integration |
| `cmake/GitHubENV.cmake` | Exports config for CI env vars |
| `cmake/XcodePrettify.cmake` | Xcode project organization |

## Initial Setup by Platform

### macOS (Intel or Apple Silicon)

**Prerequisites:**
```bash
# 1. Install Xcode Command Line Tools (provides Clang compiler)
xcode-select --install

# 2. Install Homebrew (if not already) — https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install CMake and Ninja
brew install cmake ninja
```

**VS Code extensions (recommended):**
- CMake Tools (`ms-vscode.cmake-tools`) — configure/build/debug from VS Code
- C/C++ (`ms-vscode.cpptools`) — IntelliSense and debugging

### Windows

**Prerequisites:**
- Visual Studio 2022 (Community is free) with "Desktop development with C++" workload
- CMake (bundled with VS2022, or install separately)
- Ninja (`choco install ninja`)

**VS Code extensions (recommended):**
- CMake Tools (`ms-vscode.cmake-tools`) — configure/build/debug from VS Code
- C/C++ (`ms-vscode.cpptools`) — IntelliSense and debugging

**Build:**
```powershell
.\build.ps1              # Debug build
.\build.ps1 release      # Release build
.\build.ps1 test         # Build + run tests
.\build.ps1 clean        # Remove build artifacts
```

### Linux (Ubuntu/Debian)

**Prerequisites:**
```bash
sudo apt update && sudo apt install -y \
  build-essential cmake ninja-build \
  libasound2-dev libx11-dev libxinerama-dev libxext-dev \
  libfreetype6-dev libwebkit2gtk-4.1-dev libglu1-mesa-dev
```

## Build Commands

```bash
# First time setup — recursive is required (CLAP has nested submodules)
git submodule update --init --recursive

# Configure (Ninja — fast, recommended for local dev)
cmake -B Builds -G Ninja -DCMAKE_BUILD_TYPE=Debug

# Configure (Xcode project — for Xcode IDE users)
cmake -B Builds -G Xcode

# Build
cmake --build Builds --config Debug

# Run tests + benchmarks
cd Builds && ctest --verbose --output-on-failure

# Build Release
cmake -B Builds -DCMAKE_BUILD_TYPE=Release
cmake --build Builds --config Release

# Run the Standalone plugin (macOS)
open Builds/Pamplejuce_artefacts/Debug/Standalone/Pamplejuce\ Demo.app

# Run the Standalone plugin (Windows)
& ".\Builds\Pamplejuce_artefacts\Debug\Standalone\Pamplejuce Demo.exe"
```

## Platform Notes

- **macOS:** Universal binaries (arm64 + x86_64) in CI. Ninja or Xcode generator. Plugins auto-install to `~/Library/Audio/Plug-Ins/`.
- **Windows:** MSVC with sccache. Ninja generator. IPP via NuGet.
- **Linux:** Clang compiler. Ninja generator. IPP via Intel repo. Needs X11/ALSA deps.
