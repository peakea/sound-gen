import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/wave_type.dart';
import '../services/web_audio_service.dart';
import '../widgets/frequency_slider.dart';
import '../widgets/wave_type_selector.dart';
import '../widgets/play_button.dart';

/// Main screen for the sound generator app
class SoundGeneratorScreen extends StatefulWidget {
  const SoundGeneratorScreen({super.key});

  @override
  State<SoundGeneratorScreen> createState() => _SoundGeneratorScreenState();
}

class _SoundGeneratorScreenState extends State<SoundGeneratorScreen> {
  final WebAudioService _audioService = WebAudioService();
  final TextEditingController _frequencyController = TextEditingController();

  double _frequency = 440.0;
  double _volume = 0.5;
  WaveType _waveType = WaveType.sine;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _frequencyController.text = _frequency.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _audioService.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _onFrequencyChanged(double value) {
    setState(() {
      _frequency = value;
      _frequencyController.text = value.toStringAsFixed(0);
    });
    _audioService.setFrequency(value);
  }

  void _onFrequencySubmitted(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      final clamped = parsed.clamp(1.0, 20000.0);
      _onFrequencyChanged(clamped);
    } else {
      _frequencyController.text = _frequency.toStringAsFixed(0);
    }
  }

  void _onVolumeChanged(double value) {
    setState(() {
      _volume = value;
    });
    _audioService.setVolume(value);
  }

  void _onWaveTypeChanged(WaveType type) {
    setState(() {
      _waveType = type;
    });
    _audioService.setWaveType(type);
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _audioService.setFrequency(_frequency);
      _audioService.setVolume(_volume);
      _audioService.setWaveType(_waveType);
      _audioService.play();
    } else {
      _audioService.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound Generator'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Frequency Display
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            'Frequency',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: _frequencyController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSubmitted: _onFrequencySubmitted,
                                ),
                              ),
                              Text(
                                ' Hz',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Frequency Slider
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: FrequencySlider(
                        frequency: _frequency,
                        onChanged: _onFrequencyChanged,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Wave Type Selector
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            'Wave Type',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          WaveTypeSelector(
                            selectedType: _waveType,
                            onChanged: _onWaveTypeChanged,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Volume Control
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Volume',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${(_volume * 100).toStringAsFixed(0)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.volume_down,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              Expanded(
                                child: Slider(
                                  value: _volume,
                                  onChanged: _onVolumeChanged,
                                ),
                              ),
                              Icon(
                                Icons.volume_up,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Play Button
                  Center(
                    child: PlayButton(
                      isPlaying: _isPlaying,
                      onPressed: _togglePlay,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status Text
                  Center(
                    child: Text(
                      _isPlaying ? 'Playing...' : 'Tap to play',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
