/// Enum representing the different wave types available for sound generation
enum WaveType {
  sine('Sine', 'sine'),
  square('Square', 'square'),
  triangle('Triangle', 'triangle'),
  sawtooth('Sawtooth', 'sawtooth'),
  piezo('Piezo', 'custom');

  final String displayName;
  final String oscillatorType;

  const WaveType(this.displayName, this.oscillatorType);
}
