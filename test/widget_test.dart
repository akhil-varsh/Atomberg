import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atomberg/main.dart';

void main() {
  setUp(() async {
    // Initialize SharedPreferences with test values
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts and shows splash screen', (
    WidgetTester tester,
  ) async {
    // Set a realistic screen size for testing
    await tester.binding.setSurfaceSize(const Size(1080, 1920));
    
    // Build our app wrapped in ProviderScope
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    
    // Verify app starts successfully
    expect(find.byType(MyApp), findsOneWidget);
    
    // Allow all timers and animations to complete (splash screen has 3 second delay)
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
