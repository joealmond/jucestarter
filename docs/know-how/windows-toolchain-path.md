# Windows Toolchain PATH Issues

> **TL;DR:** Visual Studio bundles CMake, Ninja, and the MSVC compiler, but doesn't add them to your system PATH. Our `build.ps1` auto-detects everything — you don't need to touch PATH manually.

## The Problem

On macOS, `brew install cmake ninja` puts executables in `/usr/local/bin` (or `/opt/homebrew/bin` on Apple Silicon), which is already on PATH. The Xcode CLT compiler (`clang`) is also on PATH. Everything "just works."

On Windows, things are trickier:

1. **Visual Studio 2022** bundles CMake and Ninja deep inside its installation directory:
   ```
   C:\Program Files\Microsoft Visual Studio\<year>\<edition>\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe
   C:\Program Files\Microsoft Visual Studio\<year>\<edition>\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe
   ```
2. **The MSVC compiler** (`cl.exe`) is also buried inside VS and requires environment setup:
   ```
   C:\Program Files\Microsoft Visual Studio\<year>\<edition>\VC\Tools\MSVC\<version>\bin\Hostx64\x64\cl.exe
   ```
3. **None of these are added to the system PATH** — so a plain PowerShell terminal can't find them.
4. Visual Studio's own "Developer Command Prompt" and "Developer PowerShell" run `vcvarsall.bat` to set up all the paths — but opening a normal terminal does not.

## What `build.ps1` Does

The build script handles all three problems automatically:

1. **VS dev environment import** — uses `vswhere.exe` (ships with VS installer) to find the installation, then runs `vcvarsall.bat` in a subprocess and captures all the environment variables it sets (PATH, INCLUDE, LIB, etc.). This makes `cl.exe`, `link.exe`, and Windows SDK headers available.
2. **CMake discovery** — checks PATH first, then falls back to the known VS-bundled location.
3. **Ninja discovery** — same approach (PATH first, then VS-bundled location).

The net effect: install Visual Studio with "Desktop development with C++", and `.\build.ps1` just works — no PATH editing, no special terminal.

## What Is `vcvarsall.bat`?

It's the official Microsoft script that sets up the MSVC compiler environment. It configures:
- PATH (adds cl.exe, link.exe, cmake, etc.)
- INCLUDE (Windows SDK + MSVC headers)
- LIB (library search paths)
- Platform-specific variables (x86 vs x64 vs ARM)

Visual Studio's "Developer PowerShell" is just a normal PowerShell that runs this script on startup. Our `build.ps1` does the same thing programmatically.

## CMake 4.x + Ninja Generator Bug

**Discovered 2026-02-22.** Visual Studio 2022 now bundles CMake 4.1.x (instead of 3.x). This version has a bug in the single-config `Ninja` generator:

- It generates `$BuildType` as an unresolved Ninja variable in rule names (e.g., `rule C_COMPILER__Pamplejuce_unscanned_$BuildType`)
- Ninja doesn't support variables in rule declarations — it causes a lexing error
- This affects all Ninja versions (tested with 1.12.1 and 1.13.2)

**The fix:** Use `Ninja Multi-Config` instead of `Ninja`:
```bash
# Broken with CMake 4.x:
cmake -B Builds -G Ninja -DCMAKE_BUILD_TYPE=Debug

# Works with CMake 4.x:
cmake -B Builds -G "Ninja Multi-Config" -DCMAKE_DEFAULT_BUILD_TYPE=Debug
cmake --build Builds --config Debug
```

`Ninja Multi-Config` is designed for the multi-config pattern where `$BuildType` gets resolved at build time via `--config`. It's been available since CMake 3.17, so it works everywhere.

Our `build.ps1` and `.vscode/settings.json` already use `Ninja Multi-Config`. If CMake is later fixed, switching back to `Ninja` would also work.

## VST3 Copy-After-Build Needs Admin

JUCE's "Copy After Build" feature auto-installs VST3 plugins to `C:\Program Files\Common Files\VST3\`. This requires administrator privileges. If you see a permissions error during build:

- **Option A:** Run PowerShell as Administrator
- **Option B:** Ignore it — the Standalone app and other artifacts still build fine. The VST3 is at `Builds\Pamplejuce_artefacts\Debug\VST3\` and can be copied manually.

## Alternatives (If You Want CMake on PATH Globally)

You have several options — pick one:

### Option A: Chocolatey (simplest)
```powershell
choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install ninja
```

### Option B: Add VS CMake to PATH manually
1. Open **Settings > System > About > Advanced system settings > Environment Variables**
2. Under **System variables**, find `Path`, click **Edit**
3. Add the CMake bin directory (see path above)
4. Restart your terminal

### Option C: Use "Developer PowerShell for VS"
- Open it from the Start menu or inside VS: **Tools > Command Line > Developer PowerShell**
- This pre-configures PATH with all VS tools (CMake, Ninja, cl.exe, etc.)
- Downside: you must always use this special prompt

## Why Not Just `choco install cmake`?

You can! It works fine. But it means maintaining a second copy of CMake alongside the one VS already bundled. The auto-detection approach avoids that duplication — if VS is installed, you're good to go.

## CMake Tools Extension in VS Code

The **CMake Tools** VS Code extension does its own tool discovery and typically finds the VS-bundled CMake without issues. So even if `cmake` isn't on PATH, the VS Code build toolbar (configure/build/run) will work.

This PATH issue primarily affects command-line usage (PowerShell/terminal).
