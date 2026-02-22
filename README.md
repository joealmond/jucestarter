![PAMPLEJUCE](assets/images/pamplejuce.png)
[![](https://github.com/sudara/pamplejuce/actions/workflows/build_and_test.yml/badge.svg)](https://github.com/sudara/pamplejuce/actions)

# JUCE Plugin Starter

A beginner-friendly template for creating audio plugins with [JUCE](https://juce.com/) and [CMake](https://cmake.org/), based on [Pamplejuce](https://melatonin.dev/manuals/pamplejuce/).

Builds **VST3, AU, AUv3, CLAP, and Standalone** on macOS, Windows, and Linux — with CI/CD, testing, and code signing out of the box.

---

## 5-Minute Quickstart

### 1. Prerequisites

<details>
<summary><b>macOS</b></summary>

```bash
# Xcode Command Line Tools (compiler)
xcode-select --install

# CMake + Ninja (build system)
brew install cmake ninja
```
</details>

<details>
<summary><b>Windows</b></summary>

- Install [Visual Studio 2022](https://visualstudio.microsoft.com/) (Community is free) with the **"Desktop development with C++"** workload
- Install [Ninja](https://ninja-build.org/): `choco install ninja`
- CMake is bundled with Visual Studio
</details>

<details>
<summary><b>Linux (Ubuntu/Debian)</b></summary>

```bash
sudo apt update && sudo apt install -y \
  build-essential cmake ninja-build \
  libasound2-dev libx11-dev libxinerama-dev libxext-dev \
  libfreetype6-dev libwebkit2gtk-4.1-dev libglu1-mesa-dev
```
</details>

### 2. Clone & init

```bash
git clone <your-repo-url>
cd <your-repo>
git submodule update --init --recursive
```

### 3. Build

**Option A — One command:**
```bash
# macOS / Linux
./build.sh          # Debug build
./build.sh test     # Debug + run tests
./build.sh release  # Release build

# Windows (PowerShell)
.\build.ps1          # Debug build
.\build.ps1 test     # Debug + run tests
.\build.ps1 release  # Release build
```

**Option B — Manual CMake:**
```bash
cmake -B Builds -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build Builds --config Debug
```

### 4. Run

```bash
# Standalone app (macOS)
open Builds/Pamplejuce_artefacts/Debug/Standalone/*.app

# Standalone app (Windows)
& ".\Builds\Pamplejuce_artefacts\Debug\Standalone\Pamplejuce Demo.exe"

# Or open in your DAW — plugins auto-install to system folders
```

That's it! Your plugin is running.

---

## VS Code Setup

Open this folder in VS Code. It will prompt you to install recommended extensions:
- **CMake Tools** — configure, build, debug from the IDE
- **C/C++** — IntelliSense and debugging

The project is pre-configured (`.vscode/settings.json`) — CMake auto-detects on open.

---

## Customizing for Your Plugin

Edit the top of `CMakeLists.txt` — all the important settings are grouped together:

| Variable | What it does | Example |
|----------|-------------|---------|
| `PROJECT_NAME` | Internal name (no spaces) | `MyPlugin` |
| `PRODUCT_NAME` | Display name in DAWs (spaces OK) | `My Plugin` |
| `COMPANY_NAME` | Your company/brand | `My Company` |
| `BUNDLE_ID` | macOS bundle identifier | `com.mycompany.myplugin` |
| `PLUGIN_MANUFACTURER_CODE` | 4-char manufacturer ID (1st uppercase) | `MyCo` |
| `PLUGIN_CODE` | 4-char unique plugin ID (1+ uppercase) | `MyP1` |
| `FORMATS` | Plugin formats to build | `Standalone AU VST3 AUv3` |

Also update:
- `VERSION` file — your plugin's semantic version (e.g., `1.0.0`)
- `PRODUCT_NAME_WITHOUT_VERSION` in `target_compile_definitions` section

---

## Project Structure

```
source/                 Your plugin code lives here
  PluginProcessor.cpp   Audio processing (DSP)
  PluginProcessor.h     Processor header
  PluginEditor.cpp      GUI
  PluginEditor.h        Editor header
tests/                  Catch2 tests
benchmarks/             Performance benchmarks
JUCE/                   JUCE framework (git submodule)
modules/                External modules (CLAP, Inspector)
cmake/                  CMake helpers (git submodule)
packaging/              Installers, signing, icons
docs/                   Architecture docs, know-how, tech stack
.github/                CI/CD, AI agent config, skills
build.sh                One-command build script (macOS/Linux)
build.ps1               One-command build script (Windows)
VERSION                 Semantic version (read by CMake)
```

---

## What's Included

| Feature | Details |
|---------|---------|
| **C++23** | Modern C++ out of the box |
| **JUCE 8.x** | Tracked on `develop` branch via git submodule |
| **5 plugin formats** | VST3, AU, AUv3, CLAP, Standalone |
| **Cross-platform CI** | GitHub Actions builds on macOS, Windows, Linux |
| **Testing** | Catch2 tests + pluginval validation in CI |
| **Benchmarks** | Separate benchmark target (constructor/destructor/editor timing) |
| **UI Inspector** | [Melatonin Inspector](https://github.com/sudara/melatonin_inspector) for debugging layouts |
| **Code signing** | macOS + Windows signing config (opt-in) |
| **Intel IPP** | Optional SIMD acceleration |
| **sccache** | Fast rebuilds in CI |
| **AI-ready** | Agent configs, skills, prompts for AI-assisted development |

---

## Useful Commands

**macOS / Linux:**
```bash
./build.sh              # Build Debug
./build.sh release      # Build Release
./build.sh test         # Build + run tests
./build.sh clean        # Remove build artifacts
```

**Windows (PowerShell):**
```powershell
.\build.ps1              # Build Debug
.\build.ps1 release      # Build Release
.\build.ps1 test         # Build + run tests
.\build.ps1 clean        # Remove build artifacts
```

**Manual CMake (any platform):**
```bash
cmake -B Builds -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build Builds --config Debug
cd Builds && ctest --verbose --output-on-failure

# Generate Xcode project (macOS):
cmake -B Builds -G Xcode
```

---

## Documentation

- **[Pamplejuce Manual](https://melatonin.dev/manuals/pamplejuce/)** — build system, CI, code signing
- **[JUCE Documentation](https://docs.juce.com/master/)** — framework API reference
- **[JUCE CMake API](https://github.com/juce-framework/JUCE/blob/master/docs/CMake%20API.md)** — all plugin config options
- **[docs/tech-stack.md](docs/tech-stack.md)** — project-specific versions, build commands, setup guides
- **[AAX Plugin Support](docs/know-how/aax-plugin-support.md)** — Pro Tools AAX format: SDK setup, PACE signing, CI integration

---

## Having Issues?

1. Check that submodules are initialized: `git submodule update --init --recursive`
2. Check [docs/tech-stack.md](docs/tech-stack.md) for platform-specific setup
3. Check the [Pamplejuce docs](https://melatonin.dev/manuals/pamplejuce/)
4. [Open an issue](https://github.com/sudara/pamplejuce/issues/new) on the upstream Pamplejuce repo

---

*Based on [Pamplejuce](https://github.com/sudara/pamplejuce) by [Sudara](https://melatonin.dev/). AI infrastructure powered by [Autodocs](README-Autodocs.md).*
