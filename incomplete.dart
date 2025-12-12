import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../../config/constants.dart';
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
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
              _OnboardingPage1(),
              _OnboardingPage2(),
              _OnboardingPage3(),
              _OnboardingPage4(),
            ],
          ),
          
          // Skip button
          SafeArea(
            child: Positioned(
              top: 16,
              right: 20,
              child: TextButton(
                onPressed: _completeOnboarding,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D2D).withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      children: List.generate(4, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index 
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
                          if (_currentPage < 3) {
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
                          _currentPage < 3 ? 'Next' : 'Get Started',
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

// Page 1: Energy Savings
class _OnboardingPage1 extends StatefulWidget {
  const _OnboardingPage1();

  @override
  State<_OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<_OnboardingPage1> with SingleTickerProviderStateMixin {
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
    _savingsAnimation = IntTween(begin: 0, end: 3500).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _percentAnimation = IntTween(begin: 0, end: 65).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F8F5),
            Color(0xFFFFCC80),
          ],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Main visual
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lightning bolt in circle
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDB913).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDB913).withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Icon(
                                  Icons.bolt,
                                  size: 80,
                                  color: Color(0xFFFDB913),
                                )
                                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1.0, 1.0),
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeInOut,
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scale(delay: 200.ms, duration: 600.ms),
                          
                          const SizedBox(height: 56),
                          
                          // Savings counter
                          AnimatedBuilder(
                            animation: _savingsAnimation,
                            builder: (context, child) {
                              return Text(
                                '₹${_savingsAnimation.value}',
                                style: const TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFDB913),
                                  height: 1,
                                  letterSpacing: -2,
                                  fontFamily: 'Outfit',
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: 12),
                          
                          const Text(
                            'Average Yearly Savings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF757575),
                              fontFamily: 'Outfit',
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 800.ms),
                          
                          const SizedBox(height: 32),
                          
                          // Efficiency badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFDB913).withOpacity(0.2),
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
                    ),
                  ),
                  
                  // Bottom text content
                  Padding(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Column(
                      children: [
                        const Text(
                          'Cut Your Electricity Bills',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                            height: 1.2,
                            fontFamily: 'Outfit',
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'BLDC motors that consume 65% less power\nthan traditional fans',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF757575),
                            height: 1.5,
                            fontFamily: 'Outfit',
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms),
                      ],
                    ),
                  ),
                ],
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFCC80),
            Color(0xFFFDB913),
          ],
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
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
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
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(duration: 2500.ms),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Main visual
                  Expanded(
                    child: Center(
                      child: Column(
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
                                .animate(onPlay: (controller) => controller.repeat())
                                .fadeOut(
                                  delay: Duration(milliseconds: index * 600),
                                  duration: const Duration(milliseconds: 1800),
                                )
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.2, 1.2),
                                  delay: Duration(milliseconds: index * 600),
                                  duration: const Duration(milliseconds: 1800),
                                );
                              }),
                              
                              // Phone container
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.smartphone_rounded,
                                  size: 100,
                                  color: Color(0xFF2D2D2D),
                                )
                                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                .shimmer(
                                  duration: const Duration(milliseconds: 2000),
                                  color: const Color(0xFFFDB913).withOpacity(0.3),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(delay: 200.ms, duration: 600.ms),
                            ],
                          ),
                          
                          const SizedBox(height: 56),
                          
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
                    ),
                  ),
                  
                  // Bottom text content
                  Padding(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Column(
                      children: [
                        const Text(
                          'Control From Anywhere',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                            height: 1.2,
                            fontFamily: 'Outfit',
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Seamless IoT connectivity with timers,\nschedules, and voice commands',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2D2D2D),
                            height: 1.5,
                            fontFamily: 'Outfit',
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.3, end: 0, duration: 600.ms),
                      ],
                    ),
                  ),
                ],
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F8F5),
            Color(0xFFFFCC80),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // Main visual
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // India map with network
                      SizedBox(
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Map with animated connections
                            CustomPaint(
                              size: const Size(280, 280),
                              painter: _IndiaMapPainter(),
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(delay: 200.ms, duration: 600.ms),
                            
                            // Network dots
                            ..._buildNetworkDots(),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Stats grid
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFDB913).withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Expanded(
                                  child: _StatItem(
                                    value: '3000+',
                                    label: 'Daily Services',
                                    delay: 600,
                                  ),
                                ),
                                SizedBox(
                                  width: 1,
                                  height: 40,
                                  child: ColoredBox(color: Color(0xFFFFCC80)),
                                ),
                                Expanded(
                                  child: _StatItem(
                                    value: '99%',
                                    label: 'Pincodes Covered',
                                    delay: 800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 1,
                              color: const Color(0xFFFFCC80),
                            ),
                            const SizedBox(height: 16),
                            const _StatItem(
                              value: '4.6★',
                              label: 'Customer Service Rating',
                              delay: 1000,
                              fullWidth: true,
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3, end: 0, duration: 600.ms),
                    ],
                  ),
                ),
              ),
              
              // Bottom text content
              Padding(
                padding: const EdgeInsets.only(bottom: 140),
                child: Column(
                  children: [
                    const Text(
                      'Service Across India',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                        height: 1.2,
                        fontFamily: 'Outfit',
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Pan-India network with on-site warranty\nand doorstep service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                        height: 1.5,
                        fontFamily: 'Outfit',
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNetworkDots() {
    // Major city positions on India map (approximate)
    final cities = [
      const Offset(0.3, 0.25), // Delhi
      const Offset(0.7, 0.3),  // Kolkata
      const Offset(0.2, 0.5),  // Mumbai
      const Offset(0.35, 0.55), // Pune
      const Offset(0.5, 0.7),  // Bangalore
      const Offset(0.6, 0.75), // Chennai
      const Offset(0.45, 0.5), // Hyderabad
      const Offset(0.25, 0.35), // Ahmedabad
    ];

    return cities.asMap().entries.map((entry) {
      final index = entry.key;
      final position = entry.value;
      
      return Positioned(
        left: 140 + (position.dx * 140) - 6,
        top: 140 + (position.dy * 140) - 6,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFFDB913),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFDB913).withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(
          delay: Duration(milliseconds: 800 + index * 100),
          duration: const Duration(milliseconds: 500),
        )
        .then()
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.5, 1.5),
          duration: const Duration(milliseconds: 1000),
        )
        .then()
        .scale(
          begin: const Offset(1.5, 1.5),
          end: const Offset(1.0, 1.0),
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }).toList();
  }
}

// Page 4: Trust & Quality
class _OnboardingPage4 extends StatelessWidget {
  const _OnboardingPage4();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFCC80),
            Color(0xFFFDB913),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // Main visual
              Expanded(
                child: Center(
                  child: Column(
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
                              .animate(onPlay: (controller) => controller.repeat())
                              .fadeIn(
                                delay: Duration(milliseconds: index * 150),
                                duration: const Duration(milliseconds: 800),
                              )
                              .fadeOut(
                                delay: Duration(milliseconds: 800 + index * 150),
                                duration: const Duration(milliseconds: 800),
                              )
                              .rotate(
                                begin: 0,
                                end: 1,
                                duration: const Duration(milliseconds: 4000),
                              ),
                            );
                          }),
                          
                          // Main badge
                          Container(
                            width: 160,
                            height: 160,
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
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 60,
                                    color: Color(0xFFFDB913),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '#1 in India',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D2D2D),
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
                      
                      const SizedBox(height: 56),
                      
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
                ),
              ),
              
              // Bottom text content
              Padding(
                padding: const EdgeInsets.only(bottom: 140),
                child: Column(
                  children: [
                    const Text(
                      'Trusted by Millions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                        height: 1.2,
                        fontFamily: 'Outfit',
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Join India\'s largest community of\nsmart home enthusiasts',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2D2D2D),
                        height: 1.5,
                        fontFamily: 'Outfit',
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.3, end: 0, duration: 600.ms),
                  ],
                ),
              ),
            ],
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
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
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
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
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
    .scale(begin: const Offset(0.8, 0.8), delay: Duration(milliseconds: delay), duration: 600.ms);
  }
}

// Custom Painter for India Map
class _IndiaMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFDB913)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = const Color(0xFFFDB913).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Simplified India outline
    final path = Path();
    
    // Starting from top (Kashmir)
    path.moveTo(size.width * 0.35, size.height * 0.1);
    
    // Northern border
    path.quadraticBezierTo(
      size.width * 0.45, size.height * 0.05,
      size.width * 0.55, size.height * 0.15,
    );
    
    // Northeast
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.2,
      size.width * 0.8, size.height * 0.35,
    );
    
    // Eastern coast
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.5,
      size.width * 0.7, size.height * 0.7,
    );
    
    // Southern tip
    path.quadraticBezierTo(
      size.width * 0.55, size.height * 0.95,
      size.width * 0.4, size.height * 0.85,
    );
    
    // Western coast
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.6,
      size.width * 0.15, size.height * 0.4,
    );
    
    // Back to start
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.2,
      size.width * 0.35, size.height * 0.1,
    );
    
    path.close();
    
    // Draw filled map
    canvas.drawPath(path, fillPaint);
    // Draw outline
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
