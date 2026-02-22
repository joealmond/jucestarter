# AAX Plugin Support (Pro Tools)

AAX is Avid's proprietary plugin format for **Pro Tools** (also VENUE S6L and Media Composer). It runs on **macOS and Windows only** — no Linux support.

This guide covers everything needed to build, sign, and distribute AAX plugins from this project.

---

## Overview

| Aspect | Details |
|--------|---------|
| **Format** | AAX (Avid Audio eXtension) |
| **Platforms** | macOS, Windows |
| **DAW** | Pro Tools (Intro, Artist, Studio, Ultimate) |
| **SDK** | Proprietary — free evaluation download from Avid |
| **Signing** | PACE wraptool — **required** for end-user distribution |
| **Testing** | Unsigned plugins work in Pro Tools "Development" mode |

---

## Prerequisites

### 1. Avid Developer Account

1. Create an account at [my.avid.com](https://my.avid.com/)
2. Go to [developer.avid.com/aax](https://developer.avid.com/aax/)
3. Accept the click-through license agreement
4. Download the **AAX Evaluation Toolkit** (SDK)

### 2. AAX SDK Placement

Place the SDK somewhere accessible on your machine:

```bash
# Recommended locations:
~/SDKs/AAX_SDK/          # Personal
/opt/AAX_SDK/            # System-wide (macOS/Linux)
C:\SDKs\AAX_SDK\         # Windows
```

> **Important:** The AAX SDK is proprietary and **must NOT be committed to a public repository**. Add it to `.gitignore` if stored inside the project tree.

### 3. Pro Tools for Testing

You need Pro Tools installed to test AAX plugins:

- **Pro Tools Intro** (free) — loads AAX plugins, limited track count
- **Pro Tools** (subscription) — full version

AAX plugin install locations:
- **macOS:** `/Library/Application Support/Avid/Audio/Plug-Ins/`
- **Windows:** `C:\Program Files\Common Files\Avid\Audio\Plug-Ins\`

---

## CMake Configuration

### Step 1: Set the SDK Path

Add this line in `CMakeLists.txt` **before** the `juce_add_plugin()` call:

```cmake
# AAX SDK — set the path to your local AAX SDK installation
# Download from: https://developer.avid.com/aax/
# Comment out or remove if you don't have the SDK
juce_set_aax_sdk_path("$ENV{HOME}/SDKs/AAX_SDK")
```

Or pass it as a CMake variable during configuration:

```bash
cmake -B Builds -G Ninja -DCMAKE_BUILD_TYPE=Debug \
  -DAAX_SDK_PATH="$HOME/SDKs/AAX_SDK"
```

With the corresponding CMake logic:

```cmake
if(DEFINED AAX_SDK_PATH)
    juce_set_aax_sdk_path("${AAX_SDK_PATH}")
endif()
```

### Step 2: Add AAX to Formats

```cmake
set(FORMATS Standalone AU VST3 AUv3 AAX)
```

### Step 3: Optional AAX-Specific Settings

These go inside the `juce_add_plugin()` call:

```cmake
juce_add_plugin("${PROJECT_NAME}"
    # ... existing settings ...

    # AAX-specific (all optional):
    AAX_CATEGORY Effect          # or: Analyzer, EQ, Dynamics, Reverb, etc.
    AAX_IDENTIFIER "${BUNDLE_ID}"  # defaults to BUNDLE_ID
    DISABLE_AAX_BYPASS FALSE       # default
    DISABLE_AAX_MULTI_MONO FALSE   # default
)
```

#### AAX Category Values

| Category | Description |
|----------|-------------|
| `None` | Default for non-synth plugins |
| `EQ` | Equalizer |
| `Dynamics` | Compressor, limiter, gate |
| `PitchShift` | Pitch shifting |
| `Reverb` | Reverb |
| `Delay` | Delay |
| `Modulation` | Chorus, flanger, phaser |
| `Harmonic` | Harmonic processing |
| `NoiseReduction` | Noise reduction |
| `Dither` | Dithering |
| `SoundField` | Spatial/surround processing |
| `HWGenerators` | Hardware generators |
| `SWGenerators` | Software generators (synths) |
| `WrappedPlugin` | Wrapped plugin |
| `Effect` | General effect |
| `MIDIEffect` | MIDI effect |

Multiple categories can be combined (space-separated).

---

## AU Compatibility Note (macOS)

If your plugin uses PACE signing and is also an AU plugin, you may need to set `SUPPRESS_AU_PLIST_RESOURCE_USAGE` to `TRUE` in `juce_add_plugin()`. PACE-protected AU plugins can fail to load in GarageBand without this flag.

```cmake
juce_add_plugin("${PROJECT_NAME}"
    # ...
    SUPPRESS_AU_PLIST_RESOURCE_USAGE TRUE
)
```

---

## PACE Digital Signing (Required for Distribution)

AAX plugins **must be digitally signed with PACE wraptool** to load in standard Pro Tools installations. Unsigned plugins only work in Pro Tools "Development" mode.

### Signing Pipeline

| Step | Action | Details |
|------|--------|---------|
| **1** | Apply for partner program | Email `audiosdk@avid.com` — explain your product |
| **2** | Receive PACE wraptool + certificate | Avid provides after approval (days to weeks) |
| **3** | Purchase iLok USB key | ~$50 from [ilok.com](https://ilok.com) — stores the private signing key |
| **4** | Sign the `.aaxplugin` bundle | Run wraptool on the built plugin binary |

### Wraptool Usage (after obtaining it)

```bash
# macOS
wraptool sign --verbose \
  --account <your-ilok-account> \
  --signid <your-sign-id> \
  --in Builds/Pamplejuce_artefacts/Release/AAX/Pamplejuce.aaxplugin \
  --out signed/Pamplejuce.aaxplugin

# Windows
wraptool.exe sign --verbose ^
  --account <your-ilok-account> ^
  --signid <your-sign-id> ^
  --in Builds\Pamplejuce_artefacts\Release\AAX\Pamplejuce.aaxplugin ^
  --out signed\Pamplejuce.aaxplugin
```

### Development Testing (No Signing Needed)

For local development and testing without PACE signing:

1. Enable Pro Tools **Developer** mode (requires Avid dev account)
2. Or use the **AudioPluginHost** that ships with JUCE for basic testing (not a real Pro Tools environment, but validates AAX loading)

---

## CI/CD Considerations

Since the AAX SDK is proprietary and PACE signing requires an iLok USB key, CI integration is more complex than for open formats.

### Option A: Local-Only AAX Builds (Recommended to Start)

Keep AAX builds local. Make the CMake config conditional:

```cmake
# Only enable AAX if the SDK path is available
if(DEFINED AAX_SDK_PATH AND EXISTS "${AAX_SDK_PATH}")
    juce_set_aax_sdk_path("${AAX_SDK_PATH}")
    set(FORMATS Standalone AU VST3 AUv3 AAX)
    message(STATUS "AAX SDK found — AAX format enabled")
else()
    set(FORMATS Standalone AU VST3 AUv3)
    message(STATUS "AAX SDK not found — AAX format disabled")
endif()
```

This way the project builds everywhere, and AAX is automatically enabled when the SDK is present.

### Option B: AAX in CI (Advanced)

If you need AAX in CI:

1. **Store the AAX SDK** as an encrypted archive in GitHub Actions secrets or a private artifact
2. **Decrypt and extract** during the build step
3. **Pass the path** via `-DAAX_SDK_PATH=...` to CMake
4. **Skip signing in CI** — or use PACE Cloud Signing (requires setup with PACE)
5. **Skip on Linux runners** — AAX is macOS/Windows only

Example workflow snippet:

```yaml
- name: Extract AAX SDK
  if: runner.os != 'Linux'
  run: |
    echo "${{ secrets.AAX_SDK_BASE64 }}" | base64 -d > aax_sdk.zip
    unzip -q aax_sdk.zip -d $HOME/SDKs/AAX_SDK

- name: Configure with AAX
  if: runner.os != 'Linux'
  run: |
    cmake -B Builds -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DAAX_SDK_PATH="$HOME/SDKs/AAX_SDK"
```

---

## JUCE Licensing

AAX builds are not restricted by a specific JUCE tier, but **commercial distribution** of any JUCE plugin requires proper licensing:

| Tier | Cost | Revenue Limit | AAX Allowed |
|------|------|---------------|-------------|
| **Starter** | Free | Personal/evaluation use | Yes (eval) |
| **Indie** | $40/mo/user | Up to $300K | Yes |
| **Pro** | $175/mo/user | Unlimited | Yes |

The Starter tier uses AGPLv3 licensing — fine for development and personal use, but commercial closed-source distribution requires Indie or Pro.

See [juce.com/get-juce](https://juce.com/get-juce/) for current pricing and details.

---

## Implementation Phases

| Phase | Action | Blockers |
|-------|--------|----------|
| **1 — SDK Setup** | Download AAX SDK, add conditional CMake config | Avid account required |
| **2 — Local Build** | Build AAX locally, verify it compiles | AAX SDK on disk |
| **3 — Testing** | Test in Pro Tools (dev mode) | Pro Tools installed |
| **4 — Signing** | Apply for partner program, get PACE wraptool + iLok | Avid approval (days–weeks) |
| **5 — Distribution** | Sign AAX plugin, include in installer | iLok USB + wraptool |
| **6 — CI (optional)** | Add encrypted SDK + conditional AAX to GitHub Actions | Complex setup |

**Phase 1 is the only code change.** Everything else is account/license setup with Avid and PACE.

---

## Quick Reference Links

- [Avid Developer Portal — AAX SDK](https://developer.avid.com/aax/)
- [PACE Code Signing Platform](https://paceap.com/code-signing-platform/)
- [iLok — Create Account / Buy USB Key](https://ilok.com)
- [JUCE CMake API — `juce_set_aax_sdk_path`](https://github.com/juce-framework/JUCE/blob/master/docs/CMake%20API.md)
- [JUCE CMake API — Plugin Options](https://github.com/juce-framework/JUCE/blob/master/docs/CMake%20API.md) (search for `AAX_CATEGORY`)
- [JUCE Licensing](https://juce.com/get-juce/)
- [Avid SDK Support](mailto:audiosdk@avid.com)
