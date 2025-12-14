import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomberg/src/features/auth/presentation/login_screen.dart';

void main() {
  group('LoginScreen Tests', () {
    testWidgets('Displays all required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      await tester.pumpAndSettle();

      // Verify UI elements
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('API Key'), findsOneWidget);
      expect(find.text('Refresh Token'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
    });

    testWidgets('Form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();

      // Verify validation errors appear
      expect(find.text('Required'), findsNWidgets(2));
    });

    testWidgets('Can enter credentials', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      await tester.pumpAndSettle();

      // Enter API key
      await tester.enterText(
        find.widgetWithText(TextFormField, 'API Key'),
        'test_api_key',
      );

      // Enter refresh token
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Refresh Token'),
        'test_refresh_token',
      );

      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('test_api_key'), findsOneWidget);
      expect(find.text('test_refresh_token'), findsOneWidget);
    });


  });
}
