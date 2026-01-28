import 'package:flutter/material.dart';
import 'screens/sound_generator_screen.dart';

void main() {
  runApp(const SoundGeneratorApp());
}

class SoundGeneratorApp extends StatelessWidget {
  const SoundGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 6,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 6,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SoundGeneratorScreen(),
    );
  }
}
