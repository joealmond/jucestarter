````skill
---
name: build
description: Build the JUCE plugin locally. Handles submodule init, CMake configure, compile, and test. Use when the user wants to build, test, or verify the project compiles.
user-invokable: true
disable-model-invocation: false
---

# Build — Compile the Plugin Locally

## When to Use

- User wants to build the plugin
- Verifying code changes compile
- Running tests or benchmarks
- First-time project setup

## Steps

1. **Check submodules** — run `git submodule update --init --recursive` if JUCE/ is empty
2. **Read `docs/tech-stack.md`** for build commands and platform notes
3. **Configure** — pick the right generator:
   - Fast builds: `cmake -B Builds -G Ninja -DCMAKE_BUILD_TYPE=Debug`
   - Xcode project: `cmake -B Builds -G Xcode`
   - Default: `cmake -B Builds -DCMAKE_BUILD_TYPE=Debug`
4. **Build** — `cmake --build Builds --config Debug`
5. **Test** — `cd Builds && ctest --verbose --output-on-failure`
6. Report results to the user

## Troubleshooting

- **Missing JUCE:** Run `git submodule update --init --recursive`
- **Ninja not found:** Install with `brew install ninja` (macOS) or `sudo apt install ninja-build` (Linux)
- **CMake too old:** Need 3.25+. Install from https://cmake.org/download/
- **Linux deps missing:** `sudo apt install libasound2-dev libx11-dev libxinerama-dev libxext-dev libfreetype6-dev libwebkit2gtk-4.1-dev libglu1-mesa-dev`
- **Compiler cache:** Use sccache for faster rebuilds: add `-DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache`

## Notes

- The project uses C++23 — ensure your compiler supports it
- SharedCode is an INTERFACE library — plugin targets and tests both link to it
- `COPY_PLUGIN_AFTER_BUILD` is ON — built plugins auto-install to your system plugin folder
- Debug builds get an auto-bumped patch version (+1 from last VERSION commit)

````
