import 'package:flutter/material.dart';
import '../models/wave_type.dart';

/// Widget for selecting the wave type using choice chips
class WaveTypeSelector extends StatelessWidget {
  final WaveType selectedType;
  final ValueChanged<WaveType> onChanged;

  const WaveTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: WaveType.values.map((waveType) {
        final isSelected = waveType == selectedType;
        return ChoiceChip(
          label: Text(waveType.displayName),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onChanged(waveType);
            }
          },
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          avatar: isSelected
              ? Icon(
                  Icons.check,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )
              : null,
        );
      }).toList(),
    );
  }
}
