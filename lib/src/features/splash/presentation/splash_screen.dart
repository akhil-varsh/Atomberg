import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/constants.dart';
import '../../auth/presentation/login_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../auth/data/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for animation to be enjoyable
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has seen onboarding
    final prefs = await SharedPreferences.getInstance();
    // TEMPORARY: Force onboarding to show for testing
    await prefs.remove('hasSeenOnboarding');
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!mounted) return;

    // Route to onboarding for first-time users
    if (!hasSeenOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    // Check auth state for returning users
    final authState = ref.read(authProvider);

    if (authState.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors
              .lightBeigeBackground, // Or dark based on theme, but handle later
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            Image.asset('assets/images/logo.png', width: 200)
                .animate()
                .scale(duration: 800.ms, curve: Curves.easeOutBack)
                .then(delay: 200.ms)
                .shimmer(
                  duration: 1200.ms,
                  color: Colors.white.withValues(alpha: 0.5),
                ) // Shine effect
                .then()
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scaleXY(
                  end: 1.05,
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ), // Breathing effect

            const SizedBox(height: 24),

            // Text Animation
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.atombergOrange,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    );
  }
}
