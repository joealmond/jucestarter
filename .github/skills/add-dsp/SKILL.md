````skill
---
name: add-dsp
description: Add DSP processing to the audio plugin. Guides through implementing audio processing in PluginProcessor using JUCE's DSP module. Use when adding effects, filters, synthesizers, or any audio processing.
user-invokable: true
disable-model-invocation: false
---

# Add DSP — Implement Audio Processing

## When to Use

- Adding an audio effect (filter, delay, reverb, distortion, etc.)
- Adding a synthesizer voice
- Implementing any signal processing logic
- The user wants to "make the plugin do something"

## Steps

1. **Read current state** of `source/PluginProcessor.h` and `source/PluginProcessor.cpp`
2. **Understand the request** — what kind of DSP? Effect? Synth? Analyzer?
3. **Check JUCE DSP module docs** — `juce_dsp` is already linked. Key classes:
   - `juce::dsp::ProcessorChain` — chain multiple processors
   - `juce::dsp::IIR::Filter` — IIR filters
   - `juce::dsp::Gain` — gain control
   - `juce::dsp::Reverb` — reverb
   - `juce::dsp::Delay` — delay line
   - `juce::dsp::Oscillator` — wavetable oscillator
   - `juce::dsp::Compressor` — dynamics
   - `juce::dsp::ProcessSpec` — sample rate, block size, channels
4. **Implement in PluginProcessor:**
   - Add DSP members to the header (private section)
   - Initialize in `prepareToPlay()` with `juce::dsp::ProcessSpec`
   - Process in `processBlock()` using `juce::dsp::AudioBlock` and `juce::dsp::ProcessContextReplacing`
   - Clean up in `releaseResources()` if needed
5. **Add parameters** if the DSP needs user control (use the `add-parameter` skill)
6. **Build and test** (use the `build` skill)

## JUCE DSP Pattern

```cpp
// In PluginProcessor.h — private section:
juce::dsp::ProcessorChain<juce::dsp::Gain<float>, juce::dsp::IIR::Filter<float>> processorChain;

// In prepareToPlay():
juce::dsp::ProcessSpec spec { sampleRate, (uint32) samplesPerBlock, (uint32) getTotalNumOutputChannels() };
processorChain.prepare(spec);

// In processBlock():
juce::dsp::AudioBlock<float> block(buffer);
juce::dsp::ProcessContextReplacing<float> context(block);
processorChain.process(context);
```

## Rules

- Always call `prepare()` in `prepareToPlay()` — never assume sample rate
- Use `juce::dsp::AudioBlock` to wrap `juce::AudioBuffer` for DSP processing
- Keep `processBlock()` real-time safe: no allocations, no locks, no I/O
- Reset DSP state in `prepareToPlay()` when sample rate or block size changes
- Save/restore DSP state via `getStateInformation()`/`setStateInformation()`

## References

- [JUCE DSP Module Docs](https://docs.juce.com/master/group__juce__dsp.html)
- [JUCE DSP Tutorial](https://docs.juce.com/master/tutorial_dsp_introduction.html)
- [Pamplejuce Manual](https://melatonin.dev/manuals/pamplejuce/)

````
