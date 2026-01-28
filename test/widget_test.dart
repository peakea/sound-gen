// Basic smoke test for the Sound Generator App
@TestOn('browser')

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sound_gen/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoundGeneratorApp());

    // Verify that the app title is displayed.
    expect(find.text('Sound Generator'), findsOneWidget);
    
    // Verify that we have a frequency slider.
    expect(find.byType(Slider), findsAtLeastNWidgets(1));
    
    // Verify that we have the play button (starts in stopped state).
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });
}
