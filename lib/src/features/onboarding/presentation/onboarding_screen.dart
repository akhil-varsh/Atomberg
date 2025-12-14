import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../auth/presentation/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: const [
              _WelcomePage(),
              _OnboardingPage1(),
              _OnboardingPage2(),
              _OnboardingPage3(),
              _OnboardingPage4(),
            ],
          ),

          // Skip button at top right
          Positioned(
            top: 16,
            right: 20,
            child: SafeArea(
              child: TextButton(
                onPressed: _completeOnboarding,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D2D).withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ),
          ),

          // Bottom section with indicators and button
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? const Color(0xFFFDB913)
                                    : const Color(0xFF757575).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 32),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < 4) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _completeOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB913),
                          foregroundColor: const Color(0xFF2D2D2D),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage < 4 ? 'Next' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Welcome Page
class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F8F5), Color(0xFFFFCC80)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.vertical),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.06),

                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Atomberg Logo - responsive size
                      Image.asset(
                        'assets/images/logo.png',
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.4,
                        fit: BoxFit.contain,
                      )
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .scale(
                            delay: 200.ms,
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),

                      SizedBox(height: screenHeight * 0.04),

                      // Welcome text - responsive font size
                      Text(
                            'Welcome to Atomberg!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D2D2D),
                              height: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms),

                      SizedBox(height: screenHeight * 0.02),

                      // Brand message
                      Text(
                            'From day one, we\'ve turned real customer problems into modern solutions through tech-first innovation, R&D, and design.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: const Color(0xFF757575),
                              height: 1.6,
                              fontFamily: 'Outfit',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 800.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms),

                      SizedBox(height: screenHeight * 0.015),

                      Text(
                            'The result—products trusted for their performance, durability, and convenience.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFDB913),
                              height: 1.6,
                              fontFamily: 'Outfit',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 1000.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms),
                    ],
                  ),

                  // Bottom spacing
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Page 1: Energy Savings
class _OnboardingPage1 extends StatefulWidget {
  const _OnboardingPage1();

  @override
  State<_OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<_OnboardingPage1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _savingsAnimation;
  late Animation<int> _percentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _savingsAnimation = IntTween(
      begin: 0,
      end: 3500,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _percentAnimation = IntTween(
      begin: 0,
      end: 65,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F8F5), Color(0xFFFFCC80)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFDB913).withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFCC80).withOpacity(0.3),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.vertical),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),

                      // Main visual
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lightning bolt in circle
                          Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFDB913,
                                  ).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.3,
                                      height: screenWidth * 0.3,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFDB913,
                                        ).withOpacity(0.25),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Icon(
                                          Icons.bolt,
                                          size: screenWidth * 0.2,
                                          color: const Color(0xFFFDB913),
                                        )
                                        .animate(
                                          onPlay:
                                              (controller) => controller.repeat(
                                                reverse: true,
                                              ),
                                        )
                                        .scale(
                                          begin: const Offset(0.9, 0.9),
                                          end: const Offset(1.0, 1.0),
                                          duration: const Duration(
                                            milliseconds: 1500,
                                          ),
                                          curve: Curves.easeInOut,
                                        ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(delay: 200.ms, duration: 600.ms),

                          SizedBox(height: screenHeight * 0.04),

                          // Savings counter
                          AnimatedBuilder(
                            animation: _savingsAnimation,
                            builder: (context, child) {
                              return Text(
                                '₹${_savingsAnimation.value}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFDB913),
                                  height: 1,
                                  letterSpacing: -2,
                                  fontFamily: 'Outfit',
                                ),
                              );
                            },
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          Text(
                            'Average Yearly Savings',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF757575),
                              fontFamily: 'Outfit',
                            ),
                          ).animate().fadeIn(delay: 800.ms),

                          SizedBox(height: screenHeight * 0.03),

                          // Efficiency badge
                          Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFDB913,
                                      ).withOpacity(0.2),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: AnimatedBuilder(
                                  animation: _percentAnimation,
                                  builder: (context, child) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.eco,
                                          color: Color(0xFFFDB913),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${_percentAnimation.value}% More Efficient',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D2D2D),
                                            fontFamily: 'Outfit',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 1000.ms)
                              .slideY(begin: 0.3, end: 0, duration: 600.ms),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // Bottom text content
                      Column(
                        children: [
                          Text(
                                'Cut Your Electricity Bills',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2D2D),
                                  height: 1.2,
                                  fontFamily: 'Outfit',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideY(begin: 0.3, end: 0, duration: 600.ms),

                          SizedBox(height: screenHeight * 0.015),

                          Text(
                                'BLDC motors that consume 65% less power\nthan traditional fans',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: const Color(0xFF757575),
                                  height: 1.5,
                                  fontFamily: 'Outfit',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideY(begin: 0.3, end: 0, duration: 600.ms),

                          SizedBox(height: screenHeight * 0.1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Page 2: Smart Control
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFCC80), Color(0xFFFDB913)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: 100,
            left: 30,
            child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(duration: 2000.ms),
          ),
          Positioned(
            bottom: 200,
            right: 40,
            child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(duration: 2500.ms),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.vertical),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),

                      // Main visual
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Phone with connection rings
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulse rings
                              ...List.generate(3, (index) {
                                return Container(
                                      width: 200 + (index * 40.0),
                                      height: 200 + (index * 40.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.4),
                                          width: 2,
                                        ),
                                      ),
                                    )
                                    .animate(
                                      onPlay:
                                          (controller) => controller.repeat(),
                                    )
                                    .fadeOut(
                                      delay: Duration(
                                        milliseconds: index * 600,
                                      ),
                                      duration: const Duration(
                                        milliseconds: 1800,
                                      ),
                                    )
                                    .scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1.2, 1.2),
                                      delay: Duration(
                                        milliseconds: index * 600,
                                      ),
                                      duration: const Duration(
                                        milliseconds: 1800,
                                      ),
                                    );
                              }),

                              // Phone container
                              Container(
                                    width: screenWidth * 0.45,
                                    height: screenWidth * 0.45,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(screenWidth * 0.225),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                          Icons.smartphone_rounded,
                                          size: screenWidth * 0.25,
                                          color: const Color(0xFF2D2D2D),
                                        )
                                        .animate(
                                          onPlay:
                                              (controller) => controller.repeat(
                                                reverse: true,
                                              ),
                                        )
                                        .shimmer(
                                          duration: const Duration(
                                            milliseconds: 2000,
                                          ),
                                          color: const Color(
                                            0xFFFDB913,
                                          ).withOpacity(0.3),
                                        ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .scale(delay: 200.ms, duration: 600.ms),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Feature pills
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: const [
                              _FeaturePill(
                                icon: Icons.wifi,
                                label: 'WiFi Control',
                                delay: 400,
                              ),
                              _FeaturePill(
                                icon: Icons.bluetooth,
                                label: 'Bluetooth',
                                delay: 600,
                              ),
                              _FeaturePill(
                                icon: Icons.mic,
                                label: 'Voice Control',
                                delay: 800,
                              ),
                              _FeaturePill(
                                icon: Icons.schedule,
                                label: 'Smart Timers',
                                delay: 1000,
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // Bottom text content
                      Column(
                        children: [
                          Text(
                                'Control From Anywhere',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2D2D),
                                  height: 1.2,
                                  fontFamily: 'Outfit',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideY(begin: 0.3, end: 0, duration: 600.ms),

                          SizedBox(height: screenHeight * 0.015),

                          Text(
                                'Seamless IoT connectivity with timers,\nschedules, and voice commands',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: const Color(0xFF2D2D2D),
                                  height: 1.5,
                                  fontFamily: 'Outfit',
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideY(begin: 0.3, end: 0, duration: 600.ms),

                          SizedBox(height: screenHeight * 0.1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Page 3: Pan-India Service Network
class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F8F5), Color(0xFFFFCC80)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.vertical),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // India map
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFFFDB913).withOpacity(0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFDB913).withOpacity(0.08),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Image.asset(
                              'assets/images/india.png',
                              height: screenHeight * 0.3,
                              fit: BoxFit.contain,
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(delay: 200.ms, duration: 600.ms),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                    // 3 metrics in a single row
                    Row(
                          children: const [
                            Expanded(
                              child: _StatItem(
                                value: '3000+',
                                label: 'Daily Services',
                                delay: 600,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _StatItem(
                                value: '99%',
                                label: 'Pincodes',
                                delay: 800,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _StatItem(
                                value: '4.6★',
                                label: 'Rating',
                                delay: 1000,
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms),

                      SizedBox(height: screenHeight * 0.05),

                      // Bottom text content
                      Column(
                        children: [
                          Text(
                            'Service Across India',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D2D2D),
                              height: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          Text(
                            'Pan-India network with on-site warranty\nand doorstep service',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              color: const Color(0xFF757575),
                              height: 1.5,
                              fontFamily: 'Outfit',
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.1),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3, end: 0, duration: 600.ms),
                    ],
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

// Page 4: Trust & Quality
class _OnboardingPage4 extends StatelessWidget {
  const _OnboardingPage4();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFCC80), Color(0xFFFDB913)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.vertical),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Main visual
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge with stars
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating stars
                          ...List.generate(8, (index) {
                            final angle = (index * 45) * math.pi / 180;
                            final radius = 90.0;
                            return Positioned(
                              left: 80 + radius * math.cos(angle),
                              top: 80 + radius * math.sin(angle),
                              child: Icon(
                                    Icons.star,
                                    size: index % 2 == 0 ? 20 : 14,
                                    color: Colors.white.withOpacity(0.8),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .fadeIn(
                                    delay: Duration(milliseconds: index * 150),
                                    duration: const Duration(milliseconds: 800),
                                  )
                                  .fadeOut(
                                    delay: Duration(
                                      milliseconds: 800 + index * 150,
                                    ),
                                    duration: const Duration(milliseconds: 800),
                                  )
                                  .rotate(
                                    begin: 0,
                                    end: 1,
                                    duration: const Duration(
                                      milliseconds: 4000,
                                    ),
                                  ),
                            );
                          }),

                          // Main badge
                          Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: screenWidth * 0.15,
                                        color: const Color(0xFFFDB913),
                                      ),
                                      SizedBox(height: screenHeight * 0.005),
                                      Text(
                                        '#1 in India',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2D2D2D),
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(delay: 200.ms, duration: 600.ms),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Trust badges
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: const [
                          _TrustBadge(
                            icon: Icons.people,
                            value: '5M+',
                            label: 'Happy Users',
                            delay: 400,
                          ),
                          _TrustBadge(
                            icon: Icons.star,
                            value: '4.8★',
                            label: 'App Rating',
                            delay: 600,
                          ),
                          _TrustBadge(
                            icon: Icons.verified_user,
                            value: '3 Yrs',
                            label: 'Warranty',
                            delay: 800,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Bottom text content
                  Column(
                    children: [
                      Text(
                            'Trusted by Millions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D2D2D),
                              height: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms),

                      SizedBox(height: screenHeight * 0.015),

                      Text(
                            'Join India\'s largest community of\nsmart home enthusiasts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: const Color(0xFF2D2D2D),
                              height: 1.5,
                              fontFamily: 'Outfit',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .slideY(begin: 0.3, end: 0, duration: 600.ms),

                      SizedBox(height: screenHeight * 0.1),
                    ],
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

// Helper Widgets
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final int delay;

  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF2D2D2D)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF2D2D2D),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final int delay;
  final bool fullWidth;

  const _StatItem({
    required this.value,
    required this.label,
    required this.delay,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDB913),
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF757575),
                fontFamily: 'Outfit',
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideY(begin: 0.2, end: 0, duration: 600.ms);
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final int delay;

  const _TrustBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF2D2D2D)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF2D2D2D),
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .scale(
          begin: const Offset(0.8, 0.8),
          delay: Duration(milliseconds: delay),
          duration: 600.ms,
        );
  }
}
