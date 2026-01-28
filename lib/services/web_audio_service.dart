import 'dart:js_interop';
import 'dart:typed_data';
import '../models/wave_type.dart';

/// Extension type for AudioContext
extension type AudioContext._(JSObject _) implements JSObject {
  external factory AudioContext();
  external OscillatorNode createOscillator();
  external GainNode createGain();
  external AudioDestinationNode get destination;
  external num get currentTime;
  external PeriodicWave createPeriodicWave(JSAny real, JSAny imag);
  external String get state;
  external JSPromise resume();
}

/// Extension type for AudioNode
extension type AudioNode._(JSObject _) implements JSObject {
  external void connect(AudioNode destination);
  external void disconnect();
}

/// Extension type for AudioDestinationNode
extension type AudioDestinationNode._(JSObject _) implements AudioNode {}

/// Extension type for OscillatorNode
extension type OscillatorNode._(JSObject _) implements AudioNode {
  external AudioParam get frequency;
  external set type(String value);
  external void start([num when]);
  external void stop([num when]);
  external void setPeriodicWave(PeriodicWave periodicWave);
}

/// Extension type for GainNode
extension type GainNode._(JSObject _) implements AudioNode {
  external AudioParam get gain;
}

/// Extension type for AudioParam
extension type AudioParam._(JSObject _) implements JSObject {
  external set value(num val);
  external num get value;
  external void setValueAtTime(num value, num startTime);
  external void linearRampToValueAtTime(num value, num endTime);
}

/// Extension type for PeriodicWave
extension type PeriodicWave._(JSObject _) implements JSObject {}

/// Service for generating audio using the Web Audio API
class WebAudioService {
  AudioContext? _audioContext;
  OscillatorNode? _oscillator;
  GainNode? _gainNode;
  bool _isPlaying = false;
  double _currentFrequency = 440.0;
  double _currentVolume = 0.5;
  WaveType _currentWaveType = WaveType.sine;

  bool get isPlaying => _isPlaying;
  double get currentFrequency => _currentFrequency;
  double get currentVolume => _currentVolume;
  WaveType get currentWaveType => _currentWaveType;

  /// Initialize the audio context
  void _ensureContext() {
    _audioContext ??= AudioContext();
  }

  /// Resume audio context if suspended (required for user gesture)
  Future<void> _resumeContext() async {
    if (_audioContext != null && _audioContext!.state == 'suspended') {
      _audioContext!.resume().toDart;
    }
  }

  /// Create a piezo-like periodic wave
  PeriodicWave _createPiezoWave() {
    // Create harmonics for a harsh, piezo-like sound
    final real = Float32List.fromList([0, 1, 0.5, 0.3, 0.25, 0.2, 0.15, 0.1, 0.08, 0.05]);
    final imag = Float32List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

    final realArray = real.toJS;
    final imagArray = imag.toJS;

    return _audioContext!.createPeriodicWave(realArray, imagArray);
  }

  /// Start playing the tone
  void play() {
    if (_isPlaying) return;

    _ensureContext();
    _resumeContext();

    _oscillator = _audioContext!.createOscillator();
    _gainNode = _audioContext!.createGain();

    // Set wave type
    if (_currentWaveType == WaveType.piezo) {
      _oscillator!.setPeriodicWave(_createPiezoWave());
    } else {
      _oscillator!.type = _currentWaveType.oscillatorType;
    }

    // Set frequency and volume
    _oscillator!.frequency.value = _currentFrequency;
    _gainNode!.gain.value = _currentVolume;

    // Connect nodes
    _oscillator!.connect(_gainNode!);
    _gainNode!.connect(_audioContext!.destination);

    // Start oscillator
    _oscillator!.start();
    _isPlaying = true;
  }

  /// Stop playing the tone
  void stop() {
    if (!_isPlaying || _oscillator == null) return;

    _oscillator!.stop();
    _oscillator!.disconnect();
    _gainNode?.disconnect();

    _oscillator = null;
    _gainNode = null;
    _isPlaying = false;
  }

  /// Set the frequency (1 - 20000 Hz)
  void setFrequency(double frequency) {
    _currentFrequency = frequency.clamp(1.0, 20000.0);
    if (_isPlaying && _oscillator != null) {
      _oscillator!.frequency.value = _currentFrequency;
    }
  }

  /// Set the volume (0.0 - 1.0)
  void setVolume(double volume) {
    _currentVolume = volume.clamp(0.0, 1.0);
    if (_isPlaying && _gainNode != null) {
      _gainNode!.gain.value = _currentVolume;
    }
  }

  /// Set the wave type
  void setWaveType(WaveType waveType) {
    _currentWaveType = waveType;
    if (_isPlaying) {
      // Restart with new wave type
      stop();
      play();
    }
  }

  /// Dispose resources
  void dispose() {
    stop();
    _audioContext = null;
  }
}
