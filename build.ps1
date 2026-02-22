<#
.SYNOPSIS
    One-command build script for this JUCE plugin (Windows).

.DESCRIPTION
    PowerShell equivalent of build.sh for Windows development.
    Auto-detects Visual Studio's bundled CMake when it's not on PATH.

.PARAMETER Action
    Build action: debug (default), release, test, clean

.EXAMPLE
    .\build.ps1              # Build Debug (default)
    .\build.ps1 release      # Build Release
    .\build.ps1 test         # Build Debug + run tests
    .\build.ps1 clean        # Remove build artifacts
#>

param(
    [Parameter(Position = 0)]
    [ValidateSet("debug", "release", "test", "clean")]
    [string]$Action = "debug"
)

$ErrorActionPreference = "Stop"
$BuildDir = "Builds"

# ── Tool Discovery ───────────────────────────
# Visual Studio bundles CMake, Ninja, and the MSVC compiler — but does NOT
# add any of them to the system PATH in a plain PowerShell terminal.
# We use vswhere.exe (ships with VS installer) to locate the installation,
# then import the full developer environment via vcvarsall.bat.
# See: docs/know-how/windows-toolchain-path.md

function Find-VsInstallPath {
    $vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (-not (Test-Path $vsWhere)) { return $null }
    $vsPath = & $vsWhere -latest -property installationPath 2>$null
    return $vsPath
}

function Import-VsDevEnvironment {
    # If cl.exe is already on PATH, the environment is already set up
    if (Get-Command cl -ErrorAction SilentlyContinue) { return $true }

    $vsPath = Find-VsInstallPath
    if (-not $vsPath) { return $false }

    $vcvarsall = Join-Path $vsPath "VC\Auxiliary\Build\vcvarsall.bat"
    if (-not (Test-Path $vcvarsall)) { return $false }

    # Determine architecture
    $arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "x86" }

    Write-Host "Importing Visual Studio developer environment ($arch)..." -ForegroundColor DarkGray

    # Run vcvarsall.bat in a cmd subprocess and capture the resulting environment
    $output = cmd /c "`"$vcvarsall`" $arch >nul 2>&1 && set" 2>$null
    if ($LASTEXITCODE -ne 0) { return $false }

    # Apply each environment variable to the current PowerShell session
    foreach ($line in $output) {
        if ($line -match '^([^=]+)=(.*)$') {
            [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }

    Write-Host "  MSVC environment loaded." -ForegroundColor DarkGray
    return $true
}

function Find-VsCmake {
    # 1. Already on PATH? Great, use it.
    $cmd = Get-Command cmake -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    # 2. Look inside Visual Studio's installation
    $vsPath = Find-VsInstallPath
    if (-not $vsPath) { return $null }

    $cmakeExe = Join-Path $vsPath "Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
    if (Test-Path $cmakeExe) {
        Write-Host "Found VS-bundled CMake: $cmakeExe" -ForegroundColor DarkGray
        return $cmakeExe
    }
    return $null
}

function Find-VsNinja {
    # 1. Already on PATH? (e.g. installed via choco)
    $cmd = Get-Command ninja -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    # 2. Visual Studio also bundles Ninja
    $vsPath = Find-VsInstallPath
    if (-not $vsPath) { return $null }

    $ninjaExe = Join-Path $vsPath "Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe"
    if (Test-Path $ninjaExe) {
        Write-Host "Found VS-bundled Ninja: $ninjaExe" -ForegroundColor DarkGray
        return $ninjaExe
    }
    return $null
}

# Import VS developer environment (compiler, linker, Windows SDK paths)
# This must happen BEFORE resolving tool paths, since vcvarsall.bat may
# add CMake/Ninja to PATH as well.
$vsEnvLoaded = Import-VsDevEnvironment

# Resolve tool paths once at startup
$script:CMAKE = Find-VsCmake
$script:NINJA = Find-VsNinja

function Test-Dependencies {
    $missing = @()
    if (-not $script:CMAKE) { $missing += "cmake" }
    if (-not $script:NINJA) { $missing += "ninja" }

    if ($missing.Count -gt 0) {
        Write-Host "Missing required tools: $($missing -join ', ')" -ForegroundColor Red
        Write-Host ""
        Write-Host "  To fix:" -ForegroundColor Yellow
        Write-Host "  1. Install Visual Studio 2022 with 'Desktop development with C++' workload" -ForegroundColor Yellow
        Write-Host "     (this bundles both CMake and Ninja — no PATH setup needed)" -ForegroundColor Yellow
        Write-Host "  2. Or install them manually: choco install cmake ninja" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  See docs/know-how/windows-toolchain-path.md for details." -ForegroundColor DarkGray
        exit 1
    }

    # Add Ninja's directory to PATH for the current session so CMake can find it
    $ninjaDir = Split-Path $script:NINJA
    if ($env:PATH -notlike "*$ninjaDir*") {
        $env:PATH = "$ninjaDir;$env:PATH"
    }
}

function Initialize-Submodules {
    if (-not (Test-Path "JUCE/CMakeLists.txt")) {
        Write-Host "Initializing submodules (first time only)..." -ForegroundColor Cyan
        git submodule update --init --recursive
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

function Invoke-Configure {
    param([string]$BuildType)
    Write-Host "Configuring ($BuildType)..." -ForegroundColor Cyan
    # Use "Ninja Multi-Config" — CMake 4.x's single-config Ninja generator has a
    # bug that puts unresolved $BuildType variables in rule names, breaking Ninja.
    # Multi-Config works correctly and supports --config at build time.
    # See: docs/know-how/windows-toolchain-path.md
    & $script:CMAKE -B $BuildDir -G "Ninja Multi-Config" "-DCMAKE_DEFAULT_BUILD_TYPE=$BuildType" "-DCMAKE_MAKE_PROGRAM=$($script:NINJA)"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Invoke-Build {
    param([string]$BuildType)
    Write-Host "Building ($BuildType)..." -ForegroundColor Cyan
    & $script:CMAKE --build $BuildDir --config $BuildType
    if ($LASTEXITCODE -ne 0) {
        # JUCE's "Copy After Build" tries to install VST3 to Program Files,
        # which needs admin rights. If the Standalone built successfully,
        # treat this as a non-fatal warning rather than a hard failure.
        $standaloneExe = Join-Path $BuildDir "Pamplejuce_artefacts\$BuildType\Standalone\Pamplejuce Demo.exe"
        if (Test-Path $standaloneExe) {
            Write-Host ""
            Write-Host "Build completed with warnings." -ForegroundColor Yellow
            Write-Host "  The VST3 copy-after-build failed (needs admin rights)." -ForegroundColor Yellow
            Write-Host "  All plugins were compiled successfully. To install VST3 system-wide," -ForegroundColor Yellow
            Write-Host "  run this script as Administrator, or copy manually from:" -ForegroundColor Yellow
            Write-Host "  $BuildDir\Pamplejuce_artefacts\$BuildType\VST3\" -ForegroundColor Yellow
            return
        }
        exit $LASTEXITCODE
    }
    Write-Host "Build complete!" -ForegroundColor Green
}

function Invoke-Tests {
    Write-Host "Running tests..." -ForegroundColor Cyan
    # ctest lives in the same bin dir as cmake
    $ctestExe = Join-Path (Split-Path $script:CMAKE) "ctest.exe"
    if (-not (Test-Path $ctestExe)) { $ctestExe = "ctest" }
    Push-Location $BuildDir
    & $ctestExe --verbose --output-on-failure
    $testExit = $LASTEXITCODE
    Pop-Location
    if ($testExit -ne 0) { exit $testExit }
}

# ── Main ─────────────────────────────────────

Test-Dependencies
Initialize-Submodules

switch ($Action) {
    "debug" {
        Invoke-Configure "Debug"
        Invoke-Build "Debug"
        Write-Host ""
        Write-Host "Run the standalone plugin:" -ForegroundColor Yellow
        Write-Host "  & `".\$BuildDir\Pamplejuce_artefacts\Debug\Standalone\Pamplejuce Demo.exe`"" -ForegroundColor Yellow
    }
    "release" {
        Invoke-Configure "Release"
        Invoke-Build "Release"
    }
    "test" {
        Invoke-Configure "Debug"
        Invoke-Build "Debug"
        Invoke-Tests
    }
    "clean" {
        Write-Host "Cleaning build artifacts..." -ForegroundColor Cyan
        if (Test-Path $BuildDir) {
            Remove-Item -Recurse -Force $BuildDir
        }
        Write-Host "Clean!" -ForegroundColor Green
    }
}
