````prompt
---
name: build
description: "Build the plugin locally — configure, compile, and test"
agent: coder
tools: ['read', 'editFiles', 'search', 'terminal']
---

Build the JUCE audio plugin locally.

## Steps

1. Read `docs/tech-stack.md` for build commands and platform notes
2. Check if submodules are initialized: `git submodule status`
   - If not: `git submodule update --init --recursive`
3. Ask the user which build type they want (or default to Debug):
   - Debug: `cmake -B Builds -DCMAKE_BUILD_TYPE=Debug`
   - Release: `cmake -B Builds -DCMAKE_BUILD_TYPE=Release`
4. Add `-G Ninja` if ninja is available (faster builds)
5. Build: `cmake --build Builds --config <type>`
6. Run tests: `cd Builds && ctest --verbose --output-on-failure`
7. Report results — if build failed, analyze errors and offer fixes

## Notes

- Prefer Ninja generator for speed (install: `brew install ninja` on macOS)
- The Standalone target is easiest for quick testing
- Built plugins auto-install to system plugin folders when `COPY_PLUGIN_AFTER_BUILD` is ON
- For Xcode: `cmake -B Builds -G Xcode`

````
