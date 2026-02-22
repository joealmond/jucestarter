````skill
---
name: add-parameter
description: Add automatable plugin parameters using JUCE's AudioProcessorValueTreeState (APVTS). Use when adding knobs, sliders, buttons, or any user-controllable values to the plugin.
user-invokable: true
disable-model-invocation: false
---

# Add Parameter — Create Plugin Parameters

## When to Use

- Adding a knob, slider, button, or combo box to the plugin
- Making a DSP value automatable by the host DAW
- The user wants to control something in the plugin UI

## Steps

1. **Read current state** of `source/PluginProcessor.h` and `source/PluginProcessor.cpp`
2. **Check if APVTS exists** — if not, add it:
   - Add `juce::AudioProcessorValueTreeState apvts;` to `PluginProcessor.h`
   - Create a static `createParameterLayout()` function
   - Initialize in constructor: `apvts(*this, nullptr, "Parameters", createParameterLayout())`
   - Wire up `getStateInformation()`/`setStateInformation()` to APVTS
3. **Add parameters** in `createParameterLayout()`:
   - `juce::AudioParameterFloat` — continuous values (knobs, sliders)
   - `juce::AudioParameterBool` — on/off (buttons, toggles)
   - `juce::AudioParameterChoice` — discrete options (combo boxes)
   - `juce::AudioParameterInt` — integer ranges
4. **Access parameters in processBlock** via `apvts.getRawParameterValue("paramId")`
5. **Connect UI** in `PluginEditor` using `juce::AudioProcessorValueTreeState::SliderAttachment`
6. **Build and test** (use the `build` skill)

## APVTS Pattern

```cpp
// In PluginProcessor.h:
juce::AudioProcessorValueTreeState apvts;
static juce::AudioProcessorValueTreeState::ParameterLayout createParameterLayout();

// In PluginProcessor.cpp constructor:
PluginProcessor::PluginProcessor()
    : AudioProcessor(BusesProperties()...),
      apvts(*this, nullptr, "Parameters", createParameterLayout())
{ }

// Parameter layout:
juce::AudioProcessorValueTreeState::ParameterLayout PluginProcessor::createParameterLayout()
{
    std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;
    params.push_back(std::make_unique<juce::AudioParameterFloat>(
        juce::ParameterID{"gain", 1}, "Gain", 0.0f, 1.0f, 0.5f));
    return { params.begin(), params.end() };
}

// State save/restore:
void PluginProcessor::getStateInformation(juce::MemoryBlock& destData)
{
    auto state = apvts.copyState();
    std::unique_ptr<juce::XmlElement> xml(state.createXml());
    copyXmlToBinary(*xml, destData);
}

void PluginProcessor::setStateInformation(const void* data, int sizeInBytes)
{
    std::unique_ptr<juce::XmlElement> xml(getXmlFromBinary(data, sizeInBytes));
    if (xml && xml->hasTagName(apvts.state.getType()))
        apvts.replaceState(juce::ValueTree::fromXml(*xml));
}
```

## UI Attachment Pattern

```cpp
// In PluginEditor.h:
juce::Slider gainSlider;
std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> gainAttachment;

// In PluginEditor constructor:
gainAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(
    processorRef.apvts, "gain", gainSlider);
addAndMakeVisible(gainSlider);
```

## Rules

- Parameter IDs must be stable across versions — changing them breaks user presets
- Use `juce::ParameterID{"name", versionHint}` — increment versionHint on changes
- Always use APVTS for DAW-automatable parameters (not raw member variables)
- Access values in `processBlock()` via `getRawParameterValue()` (returns `std::atomic<float>*`)
- Use smoothing (`juce::SmoothedValue`) for parameters that affect audio to avoid clicks

## References

- [JUCE APVTS Tutorial](https://docs.juce.com/master/tutorial_audio_processor_value_tree_state.html)
- [JUCE Parameter Docs](https://docs.juce.com/master/classAudioProcessorValueTreeState.html)

````
