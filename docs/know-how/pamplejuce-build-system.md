# Pamplejuce Build System

**Learned:** 2026-02-22
**Context:** Discovering the Pamplejuce-based JUCE plugin project structure

## The Problem

Pamplejuce has a non-obvious modular CMake architecture that AI agents need to understand to make correct build system changes.

## The Solution

- **Root `CMakeLists.txt`** orchestrates everything via `include()` calls to `cmake/` modules
- **`cmake/` is a git submodule** tracking `sudara/cmake-includes` — don't modify these files unless intentional
- **SharedCode is INTERFACE** — this is the key pattern. All source files and JUCE modules link to SharedCode, then both the plugin target and test target link to SharedCode. This avoids ODR violations.
- **JUCE is a submodule** on the `develop` branch — `git submodule update --init --recursive` is required
- **CLAP** is added separately via `clap-juce-extensions` submodule (also needs recursive init)
- **Version** comes from the `VERSION` file (not CMakeLists.txt) — auto-bump available via `PAMPLEJUCE_AUTO_BUMP_PATCH_LEVEL`
- **CI** uses sccache for fast rebuilds, Ninja generator, and runs pluginval validation

## Key Takeaway

Never modify `cmake/` submodule files directly. Link new modules to `SharedCode` with `INTERFACE` visibility. Always init submodules recursively (CLAP has nested submodules).
