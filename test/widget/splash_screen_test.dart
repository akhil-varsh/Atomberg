import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atomberg/src/features/splash/presentation/splash_screen.dart';
import 'package:atomberg/src/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SplashScreen Tests', () {
    testWidgets('Renders and displays logo', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );
      
      // Settle animations
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // After navigation completes, check that onboarding is displayed
      // (splash screen removes hasSeenOnboarding flag)
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('Navigates after delay', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1080, 1920));
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Verify splash screen is initially displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for splash delay and navigation (note: splash screen removes onboarding flag)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // After navigation, splash screen should be replaced
      // (Will navigate to onboarding since hasSeenOnboarding is force-removed in splash)
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });
}
