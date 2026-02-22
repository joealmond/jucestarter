# JUCE Plugin Architecture

**Learned:** 2026-02-22
**Context:** Understanding JUCE audio plugin patterns in this Pamplejuce project

## The Problem

JUCE audio plugins follow specific patterns with strict real-time constraints. AI agents unfamiliar with audio programming can introduce bugs (allocations in processBlock, thread safety issues, broken state persistence).

## The Solution

- **PluginProcessor** owns all state and DSP — it outlives the editor
- **PluginEditor** is created/destroyed as the DAW opens/closes the plugin window
- **processBlock()** runs on the audio thread — must be real-time safe (no alloc, no locks, no I/O)
- **prepareToPlay()** is where you allocate/prepare DSP — called before audio starts
- **APVTS** (AudioProcessorValueTreeState) manages parameters — DAW automation, state save/restore, UI binding all go through it
- **Parameter IDs are stable** — changing them breaks user presets across versions
- **Use SmoothedValue** for parameter-controlled audio values to prevent clicks
- Plugin formats (VST3, AU, CLAP, etc.) are handled by JUCE's build system — you write one codebase

## Key Takeaway

The processor is the long-lived core; the editor is ephemeral. Never allocate or lock in processBlock(). Use APVTS for all user-facing parameters.
