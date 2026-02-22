````instructions
---
name: JUCE C++ Standards
description: Rules for editing JUCE C++ source files in this audio plugin project
applyTo: 'source/**/*.cpp,source/**/*.h'
---

# JUCE C++ Standards

When editing C++ source files in `source/`:

## Architecture

- `PluginProcessor` — audio processing, parameters, state. Inherits `juce::AudioProcessor`.
- `PluginEditor` — GUI. Inherits `juce::AudioProcessorEditor`. References the processor.
- The processor creates the editor (not the other way around).
- SharedCode INTERFACE library means these files are compiled into both plugin and test targets.

## Real-Time Safety (processBlock)

- **NO** memory allocations (`new`, `malloc`, `std::vector::push_back`)
- **NO** locks (`std::mutex`, `juce::CriticalSection`) — use lock-free patterns
- **NO** I/O (file, network, logging)
- **NO** exceptions
- Use `juce::dsp::AudioBlock` to wrap `juce::AudioBuffer` for DSP operations
- Use `std::atomic` for parameter values shared between audio and UI threads
- Use `juce::SmoothedValue` to avoid clicks when changing parameters

## Parameter Management

- Use `juce::AudioProcessorValueTreeState` (APVTS) for all automatable parameters
- Access in `processBlock()` via `getRawParameterValue()` (returns `std::atomic<float>*`)
- State save/restore goes through APVTS → XML → binary
- Parameter IDs are **stable across versions** — never rename them after release

## JUCE Conventions

- Use `juce::` namespace prefix (don't `using namespace juce`)
- Use `juce::ignoreUnused()` for intentionally unused parameters
- Use `JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR` in class declarations
- Prefer `std::unique_ptr` for owned components and DSP processors
- The project uses C++23 — modern features are encouraged

## File Organization

- Keep files under 200 lines — split large processors into helper classes
- New source files in `source/` are auto-detected by CMake `GLOB_RECURSE`
- Headers use `#pragma once`
- Include JUCE module headers explicitly: `#include <juce_audio_processors/juce_audio_processors.h>`

## Melatonin Inspector

- Already integrated in `PluginEditor` — the "Inspect" button opens it
- Useful for debugging component layout and paint operations
- Include: `#include "melatonin_inspector/melatonin_inspector.h"`

````
