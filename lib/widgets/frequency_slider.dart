import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A slider widget for selecting frequency with logarithmic scale
class FrequencySlider extends StatelessWidget {
  final double frequency;
  final double minFrequency;
  final double maxFrequency;
  final ValueChanged<double> onChanged;

  const FrequencySlider({
    super.key,
    required this.frequency,
    this.minFrequency = 1.0,
    this.maxFrequency = 20000.0,
    required this.onChanged,
  });

  // Convert frequency to slider position (logarithmic)
  double _frequencyToSlider(double freq) {
    final minLog = math.log(minFrequency);
    final maxLog = math.log(maxFrequency);
    return (math.log(freq) - minLog) / (maxLog - minLog);
  }

  // Convert slider position to frequency (logarithmic)
  double _sliderToFrequency(double value) {
    final minLog = math.log(minFrequency);
    final maxLog = math.log(maxFrequency);
    return math.exp(minLog + value * (maxLog - minLog));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${minFrequency.toInt()} Hz',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${maxFrequency.toInt()} Hz',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            trackHeight: 8.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
          ),
          child: Slider(
            value: _frequencyToSlider(frequency),
            onChanged: (value) => onChanged(_sliderToFrequency(value)),
          ),
        ),
      ],
    );
  }
}
