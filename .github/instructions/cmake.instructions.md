````instructions
---
name: CMake Standards
description: Rules for editing CMake files in this Pamplejuce-based JUCE project
applyTo: '**/*.cmake,**/CMakeLists.txt'
---

# CMake Standards

When editing CMake files in this project:

## Architecture

- `CMakeLists.txt` (root) is the main build file — it uses `include()` for modular cmake helpers
- All reusable cmake logic lives in `cmake/` — these are shared via the `cmake-includes` submodule
- Don't modify files in `cmake/` unless you know they're project-local (the submodule tracks `sudara/cmake-includes`)
- JUCE is added via `add_subdirectory(JUCE)` — it's a git submodule, not CPM

## SharedCode Pattern

- `SharedCode` is an INTERFACE library — both plugin targets and test targets link to it
- New source files go in `source/` and are picked up by `GLOB_RECURSE`
- Link new JUCE modules to `SharedCode` with `INTERFACE` visibility (not `PRIVATE`)
- This avoids ODR violations between the plugin and test targets

## Adding Dependencies

- Use CPM (`include(CPM)` is already done) for non-JUCE dependencies
- JUCE modules: use `juce_add_module()` or `add_subdirectory()` before `juce_add_plugin()`
- Link to `SharedCode` with `INTERFACE` so tests also get the dependency
- Check `docs/tech-stack.md` and update it when adding new deps

## Plugin Configuration

- Plugin formats are set in `FORMATS` variable — valid: AAX Unity VST VST3 AU AUv3 Standalone
- CLAP format is added separately via `clap_juce_extensions_plugin()`
- `PLUGIN_CODE` and `PLUGIN_MANUFACTURER_CODE` must be unique 4-char codes
- `BUNDLE_ID` follows reverse-domain notation

## Rules

- Keep CMake minimum at 3.25+ (required by Pamplejuce)
- Use `target_compile_definitions(SharedCode INTERFACE ...)` for preprocessor defines
- Prefer `CONFIGURE_DEPENDS` with globs so the build system detects new files
- Don't hardcode paths — use `${CMAKE_CURRENT_SOURCE_DIR}` and variables
- Version is read from the `VERSION` file — don't hardcode it

````
