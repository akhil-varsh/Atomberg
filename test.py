# import 'package:flutter/material.dart';
# import 'package:flutter_animate/flutter_animate.dart';
# import 'package:shared_preferences/shared_preferences.dart';
# import '../../../config/constants.dart';
# import '../../auth/presentation/login_screen.dart';

# class OnboardingScreen extends StatefulWidget {
#   const OnboardingScreen({super.key});

#   @override
#   State<OnboardingScreen> createState() => _OnboardingScreenState();
# }

# class _OnboardingScreenState extends State<OnboardingScreen> {
#   final PageController _pageController = PageController();
#   int _currentPage = 0;

#   @override
#   void dispose() {
#     _pageController.dispose();
#     super.dispose();
#   }

#   Future<void> _completeOnboarding() async {
#     final prefs = await SharedPreferences.getInstance();
#     await prefs.setBool('hasSeenOnboarding', true);
#     if (mounted) {
#       Navigator.of(context).pushReplacement(
#         MaterialPageRoute(builder: (_) => const LoginScreen()),
#       );
#     }
#   }

#   @override
#   Widget build(BuildContext context) {
#     return Scaffold(
#       body: Stack(
#         children: [
#           PageView(
#             controller: _pageController,
#             onPageChanged: (index) => setState(() => _currentPage = index),
#             children: const [
#               _OnboardingPage1(),
#               _OnboardingPage2(),
#               _OnboardingPage3(),
#             ],
#           ),
          
#           // Skip button
#           SafeArea(
#             child: Positioned(
#               top: 16,
#               right: 20,
#               child: TextButton(
#                 onPressed: _completeOnboarding,
#                 style: TextButton.styleFrom(
#                   backgroundColor: Colors.white.withOpacity(0.2),
#                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
#                   shape: RoundedRectangleBorder(
#                     borderRadius: BorderRadius.circular(20),
#                   ),
#                 ),
#                 child: const Text(
#                   'Skip',
#                   style: TextStyle(
#                     fontSize: 15,
#                     fontWeight: FontWeight.w600,
#                     color: Colors.white,
#                   ),
#                 ),
#               ),
#             ),
#           ),
          
#           // Bottom section with indicators and button
#           SafeArea(
#             child: Align(
#               alignment: Alignment.bottomCenter,
#               child: Container(
#                 padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
#                 child: Column(
#                   mainAxisSize: MainAxisSize.min,
#                   children: [
#                     // Page indicators
#                     Row(
#                       mainAxisAlignment: MainAxisAlignment.center,
#                       children: List.generate(3, (index) {
#                         return AnimatedContainer(
#                           duration: const Duration(milliseconds: 300),
#                           margin: const EdgeInsets.symmetric(horizontal: 4),
#                           width: _currentPage == index ? 32 : 8,
#                           height: 8,
#                           decoration: BoxDecoration(
#                             color: _currentPage == index 
#                                 ? Colors.white
#                                 : Colors.white.withOpacity(0.4),
#                             borderRadius: BorderRadius.circular(4),
#                           ),
#                         );
#                       }),
#                     ),
                    
#                     const SizedBox(height: 32),
                    
#                     // Action button
#                     SizedBox(
#                       width: double.infinity,
#                       height: 56,
#                       child: ElevatedButton(
#                         onPressed: () {
#                           if (_currentPage < 2) {
#                             _pageController.nextPage(
#                               duration: const Duration(milliseconds: 400),
#                               curve: Curves.easeInOut,
#                             );
#                           } else {
#                             _completeOnboarding();
#                           }
#                         },
#                         style: ElevatedButton.styleFrom(
#                           backgroundColor: Colors.white,
#                           foregroundColor: AppColors.atombergOrange,
#                           elevation: 0,
#                           shape: RoundedRectangleBorder(
#                             borderRadius: BorderRadius.circular(16),
#                           ),
#                         ),
#                         child: Text(
#                           _currentPage < 2 ? 'Next' : 'Get Started',
#                           style: const TextStyle(
#                             fontSize: 17,
#                             fontWeight: FontWeight.bold,
#                             letterSpacing: 0.5,
#                           ),
#                         ),
#                       ),
#                     ),
#                   ],
#                 ),
#               ),
#             ),
#           ),
#         ],
#       ),
#     );
#   }
# }

# // Page 1: Save Power, Save Money
# class _OnboardingPage1 extends StatefulWidget {
#   const _OnboardingPage1();

#   @override
#   State<_OnboardingPage1> createState() => _OnboardingPage1State();
# }

# class _OnboardingPage1State extends State<_OnboardingPage1> with SingleTickerProviderStateMixin {
#   late AnimationController _controller;
#   late Animation<int> _savingsAnimation;

#   @override
#   void initState() {
#     super.initState();
#     _controller = AnimationController(
#       duration: const Duration(milliseconds: 2500),
#       vsync: this,
#     );
#     _savingsAnimation = IntTween(begin: 0, end: 3500).animate(
#       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
#     );
#     Future.delayed(const Duration(milliseconds: 300), () {
#       if (mounted) _controller.forward();
#     });
#   }

#   @override
#   void dispose() {
#     _controller.dispose();
#     super.dispose();
#   }

#   @override
#   Widget build(BuildContext context) {
#     return Container(
#       decoration: BoxDecoration(
#         gradient: LinearGradient(
#           begin: Alignment.topLeft,
#           end: Alignment.bottomRight,
#           colors: [
#             const Color(0xFF00C853),
#             const Color(0xFF69F0AE),
#           ],
#         ),
#       ),
#       child: Stack(
#         children: [
#           // Background pattern
#           Positioned.fill(
#             child: CustomPaint(
#               painter: _CirclePatternPainter(Colors.white.withOpacity(0.1)),
#             ),
#           ),
          
#           SafeArea(
#             child: Padding(
#               padding: const EdgeInsets.symmetric(horizontal: 32),
#               child: Column(
#                 children: [
#                   const SizedBox(height: 80),
                  
#                   // Main visual
#                   Expanded(
#                     child: Center(
#                       child: Column(
#                         mainAxisSize: MainAxisSize.min,
#                         children: [
#                           // Animated money icon
#                           Container(
#                             width: 160,
#                             height: 160,
#                             decoration: BoxDecoration(
#                               color: Colors.white.withOpacity(0.2),
#                               shape: BoxShape.circle,
#                             ),
#                             child: Center(
#                               child: Icon(
#                                 Icons.currency_rupee_rounded,
#                                 size: 100,
#                                 color: Colors.white,
#                               )
#                               .animate(onPlay: (controller) => controller.repeat(reverse: true))
#                               .scale(
#                                 begin: const Offset(0.9, 0.9),
#                                 end: const Offset(1.0, 1.0),
#                                 duration: const Duration(milliseconds: 1500),
#                                 curve: Curves.easeInOut,
#                               ),
#                             ),
#                           )
#                           .animate()
#                           .fadeIn(duration: 600.ms)
#                           .scale(delay: 200.ms, duration: 600.ms),
                          
#                           const SizedBox(height: 48),
                          
#                           // Counter
#                           AnimatedBuilder(
#                             animation: _savingsAnimation,
#                             builder: (context, child) {
#                               return Text(
#                                 '₹${_savingsAnimation.value}',
#                                 style: const TextStyle(
#                                   fontSize: 72,
#                                   fontWeight: FontWeight.bold,
#                                   color: Colors.white,
#                                   height: 1,
#                                   letterSpacing: -2,
#                                 ),
#                               );
#                             },
#                           ),
                          
#                           const SizedBox(height: 12),
                          
#                           Text(
#                             'Average Yearly Savings',
#                             style: TextStyle(
#                               fontSize: 18,
#                               fontWeight: FontWeight.w600,
#                               color: Colors.white.withOpacity(0.9),
#                             ),
#                           )
#                           .animate()
#                           .fadeIn(delay: 800.ms),
#                         ],
#                       ),
#                     ),
#                   ),
                  
#                   // Bottom text content
#                   Padding(
#                     padding: const EdgeInsets.only(bottom: 140),
#                     child: Column(
#                       children: [
#                         const Text(
#                           'Cut Your Electricity Bills',
#                           textAlign: TextAlign.center,
#                           style: TextStyle(
#                             fontSize: 32,
#                             fontWeight: FontWeight.bold,
#                             color: Colors.white,
#                             height: 1.2,
#                           ),
#                         )
#                         .animate()
#                         .fadeIn(delay: 400.ms)
#                         .slideY(begin: 0.3, end: 0, duration: 600.ms),
                        
#                         const SizedBox(height: 16),
                        
#                         Text(
#                           'Our BLDC motors consume 65% less power\nthan traditional fans',
#                           textAlign: TextAlign.center,
#                           style: TextStyle(
#                             fontSize: 16,
#                             color: Colors.white.withOpacity(0.9),
#                             height: 1.5,
#                           ),
#                         )
#                         .animate()
#                         .fadeIn(delay: 600.ms)
#                         .slideY(begin: 0.3, end: 0, duration: 600.ms),
#                       ],
#                     ),
#                   ),
#                 ],
#               ),
#             ),
#           ),
#         ],
#       ),
#     );
#   }
# }

# // Page 2: Smart Control
# class _OnboardingPage2 extends StatelessWidget {
#   const _OnboardingPage2();

#   @override
#   Widget build(BuildContext context) {
#     return Container(
#       decoration: const BoxDecoration(
#         gradient: LinearGradient(
#           begin: Alignment.topLeft,
#           end: Alignment.bottomRight,
#           colors: [
#             Color(0xFF2196F3),
#             Color(0xFF64B5F6),
#           ],
#         ),
#       ),
#       child: Stack(
#         children: [
#           // Background pattern
#           Positioned.fill(
#             child: CustomPaint(
#               painter: _CirclePatternPainter(Colors.white.withOpacity(0.1)),
#             ),
#           ),
          
#           SafeArea(
#             child: Padding(
#               padding: const EdgeInsets.symmetric(horizontal: 32),
#               child: Column(
#                 children: [
#                   const SizedBox(height: 80),
                  
#                   // Main visual
#                   Expanded(
#                     child: Center(
#                       child: Column(
#                         mainAxisSize: MainAxisSize.min,
#                         children: [
#                           // Phone mockup with fan control
#                           Stack(
#                             alignment: Alignment.center,
#                             children: [
#                               // Pulse rings
#                               ...List.generate(3, (index) {
#                                 return Container(
#                                   width: 200 + (index * 40.0),
#                                   height: 200 + (index * 40.0),
#                                   decoration: BoxDecoration(
#                                     shape: BoxShape.circle,
#                                     border: Border.all(
#                                       color: Colors.white.withOpacity(0.3),
#                                       width: 2,
#                                     ),
#                                   ),
#                                 )
#                                 .animate(onPlay: (controller) => controller.repeat())
#                                 .fadeOut(
#                                   delay: Duration(milliseconds: index * 600),
#                                   duration: const Duration(milliseconds: 1800),
#                                 )
#                                 .scale(
#                                   begin: const Offset(0.8, 0.8),
#                                   end: const Offset(1.2, 1.2),
#                                   delay: Duration(milliseconds: index * 600),
#                                   duration: const Duration(milliseconds: 1800),
#                                 );
#                               }),
                              
#                               // Phone
#                               Container(
#                                 width: 180,
#                                 height: 180,
#                                 decoration: BoxDecoration(
#                                   color: Colors.white,
#                                   borderRadius: BorderRadius.circular(90),
#                                   boxShadow: [
#                                     BoxShadow(
#                                       color: Colors.black.withOpacity(0.2),
#                                       blurRadius: 30,
#                                       spreadRadius: 5,
#                                     ),
#                                   ],
#                                 ),
#                                 child: Icon(
#                                   Icons.smartphone_rounded,
#                                   size: 100,
#                                   color: AppColors.atombergOrange,
#                                 )
#                                 .animate(onPlay: (controller) => controller.repeat(reverse: true))
#                                 .shimmer(
#                                   duration: const Duration(milliseconds: 2000),
#                                   color: Colors.white.withOpacity(0.5),
#                                 ),
#                               )
#                               .animate()
#                               .fadeIn(duration: 600.ms)
#                               .scale(delay: 200.ms, duration: 600.ms),
#                             ],
#                           ),
                          
#                           const SizedBox(height: 48),
                          
#                           // Feature pills
#                           Row(
#                             mainAxisAlignment: MainAxisAlignment.center,
#                             children: [
#                               _FeaturePill(
#                                 icon: Icons.wifi,
#                                 label: 'WiFi',
#                                 delay: 400,
#                               ),
#                               const SizedBox(width: 12),
#                               _FeaturePill(
#                                 icon: Icons.bluetooth,
#                                 label: 'Bluetooth',
#                                 delay: 600,
#                               ),
#                               const SizedBox(width: 12),
#                               _FeaturePill(
#                                 icon: Icons.voice_chat,
#                                 label: 'Voice',
#                                 delay: 800,
#                               ),
#                             ],
#                           ),
#                         ],
#                       ),
#                     ),
#                   ),
                  
#                   // Bottom text content
#                   Padding(
#                     padding: const EdgeInsets.only(bottom: 140),
#                     child: Column(
#                       children: [
#                         const Text(
#                           'Control From Anywhere',
#                           textAlign: TextAlign.center,
#                           style: TextStyle(
#                             fontSize: 32,
#                             fontWeight: FontWeight.bold,
#                             color: Colors.white,
#                             height: 1.2,
#                           ),
#                         )
#                         .animate()
#                         .fadeIn(delay: 400.ms)
#                         .slideY(begin: 0.3, end: 0, duration: 600.ms),
                        
#                         const SizedBox(height: 16),
                        
#                         Text(
#                           'Adjust speed, set timers, and create schedules\nfrom your phone or voice assistant',
#                           textAlign: TextAlign.center,
#                           style: TextStyle(
#                             fontSize: 16,
#                             color: Colors.white.withOpacity(0.9),
#                             height: 1.5,
#                           ),
#                         )
#                         .animate()
#                         .fadeIn(delay: 600.ms)
#                         .slideY(begin: 0.3, end: 0, duration: 600.ms),
#                       ],
#                     ),
#                   ),
#                 ],
#               ),
#             ),
#           ),
#         ],
#       ),
#     );
#   }
# }

# // Page 3: Trusted Quality
# class _OnboardingPage3 extends StatelessWidget {
#   const _OnboardingPage3();

#   @override
#   Widget build(BuildContext context) {
#     return Container(
#       decoration: BoxDecoration(
#         gradient: LinearGradient(
#           begin: Alignment.topLeft,
#           end: Alignment.bottomRight,
#           colors: [
#             AppColors.atombergOrange,
#             const Color(0xFFFF6F00),
#           ],
#         ),
#       ),
#       child: Stack(
#         children: [
#           // Background pattern
#           Positioned.fill(
#             child: CustomPaint(
#               painter: _CirclePatternPainter(Colors.white.withOpacity(0.1)),
#             ),
#           ),
          
#           SafeArea(
#             child: Padding(
#               padding: const EdgeInsets.symmetric(horizontal: 32),
#               child: Column(
#                 children: [
#                   const SizedBox(height: 80),
                  
#                   // Main visual
#                   Expanded(
#                     child: Center(
#                       child: Column(
#                         mainAxisSize: MainAxisSize.min,
#                         children: [
#                           // Badge with stars
#                           Stack(
#                             alignment: Alignment.center,
#                             children: [
#                               // Rotating stars
#                               ...List.generate(8, (index) {
#                                 final angle = (index * 45) * 3.14159 / 180;
#                                 final radius = 90.0;
#                                 return Positioned(
#                                   left: 80 + radius * (index % 2 == 0 ? 1 : 0.7),
#                                   top: 80 + radius * (index % 3 == 0 ? 1 : 0.7),
#                                   child: Icon(
#                                     Icons.star,
#                                     size: index % 2 == 0 ? 24 : 16,
#                                     color: Colors.white,
#                                   )
#                                   .animate(onPlay: (controller) => controller.repeat())
#                                   .fadeIn(
#                                     delay: Duration(milliseconds: index * 150),
#                                     duration: const Duration(milliseconds: 800),
#                                   )
#                                   .fadeOut(
#                                     delay: Duration(milliseconds: 800 + index * 150),
#                                     duration: const Duration(milliseconds: 800),
#                                   ),
#                                 );
#                               }),
                              
#                               // Main badge
#                               Container(
#                                 width: 160,
#                                 height: 160,
#                                 decoration: BoxDecoration(
#                                   color: Colors.white,
#                                   shape: BoxShape.circle,
#                                   boxShadow: [
#                                     BoxShadow(
#                                       color: Colors.black.withOpacity(0.2),
#                                       blurRadius: 30,
#                                       spreadRadius: 5,
#                                     ),
#                                   ],
#                                 ),
#                                 child: Center(
#                                   child: Column(
#                                     mainAxisSize: MainAxisSize.min,
#                                     children: [
#                                       Icon(
#                                         Icons.verified,
#                                         size: 60,
#                                         color: AppColors.atombergOrange,
#                                       ),
#                                       const SizedBox(height: 4),
#                                       Text(
#                                         '#1 in India',
#                                         style: TextStyle(
#                                           fontSize: 16,
#                                           fontWeight: FontWeight.bold,
#                                           color: AppColors.atombergOrange,
#                                         ),
#                                       ),
#                                     ],
#                                   ),
#                                 ),
#                               )
#                               .animate()
#                               .fadeIn(duration: 600.ms)
#                               .scale(delay: 200.ms, duration: 600.ms)
#                               .then()
#                               .shimmer(
#                                 duration: const Duration(milliseconds: 2000),
#                                 color: Colors.white.withOpacity(0.3),
#                               ),
#                             ],
#                           ),
                          
#                           const SizedBox(height: 56),
                          
#                           // Stats row
#                           Row(
#                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
#                             children: [
#                               _StatCard(
#                                 value: '5M+',
#                                 label: 'Happy Users',
#                                 delay: 400,
#                               ),
#                               _StatCard(
#                                 value: '4.8★',
#                                 label: 'App Rating',
#                                 delay: 600,
#                               ),
#                               _StatCard(
#                                 value: '3 Yrs',
#                                 label: 'Warranty',
#                                 delay: 800,
#                               ),
#                             ],
#                           ),
#                         ],
#                       ),
#                     ),
#                   ),
                  
#                   // Bottom text content
#                   Padding(
#                     padding: const EdgeInsets.only(bottom: 140),
#                     child: Column(
#                       children: [
#                         const Text(
#                           'Trusted by Millions',
#                           textAlign: TextAlign.center,
#                           style: TextStyle(
#                             fontSize: 32,
#                             fontWeight: FontWeight.bold,
#                             color: Colors.white,
#                             height: 1.2,
#                           ),
#                         )
#                         .animate()
#                         .fadeIn(delay: 400.ms)
#                         .slideY(begin: 0.3, end: 0, duration: 600.ms),
                        
#                         const SizedBox(height: 16),
                        
#                         Text(
#                           'Join India\'s largest community of\nsmart home enthusiasts',
#                           textAlign: TextAlign.center,
#                           style: TextStyle(
#                             fontSize: 16,
#                             color: Colors.white.withOpacity(0.9),
#                             height: 1.5,
#                           ),
#                         )
#                         .animate()
#                         .fadeIn(delay: 600.ms)
#                         .slideY(begin: 0.3, end: 0, duration: 600.ms),
#                       ],
#                     ),
#                   ),
#                 ],
#               ),
#             ),
#           ),
#         ],
#       ),
#     );
#   }
# }

# // Helper widgets
# class _FeaturePill extends StatelessWidget {
#   final IconData icon;
#   final String label;
#   final int delay;

#   const _FeaturePill({
#     required this.icon,
#     required this.label,
#     required this.delay,
#   });

#   @override
#   Widget build(BuildContext context) {
#     return Container(
#       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
#       decoration: BoxDecoration(
#         color: Colors.white.withOpacity(0.2),
#         borderRadius: BorderRadius.circular(20),
#         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
#       ),
#       child: Row(
#         mainAxisSize: MainAxisSize.min,
#         children: [
#           Icon(icon, size: 18, color: Colors.white),
#           const SizedBox(width: 6),
#           Text(
#             label,
#             style: const TextStyle(
#               color: Colors.white,
#               fontSize: 13,
#               fontWeight: FontWeight.w600,
#             ),
#           ),
#         ],
#       ),
#     )
#     .animate()
#     .fadeIn(delay: Duration(milliseconds: delay))
#     .slideY(begin: 0.3, end: 0, duration: 600.ms);
#   }
# }

# class _StatCard extends StatelessWidget {
#   final String value;
#   final String label;
#   final int delay;

#   const _StatCard({
#     required this.value,
#     required this.label,
#     required this.delay,
#   });

#   @override
#   Widget build(BuildContext context) {
#     return Container(
#       padding: const EdgeInsets.all(16),
#       decoration: BoxDecoration(
#         color: Colors.white.withOpacity(0.2),
#         borderRadius: BorderRadius.circular(16),
#         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
#       ),
#       child: Column(
#         children: [
#           Text(
#             value,
#             style: const TextStyle(
#               fontSize: 24,
#               fontWeight: FontWeight.bold,
#               color: Colors.white,
#             ),
#           ),
#           const SizedBox(height: 4),
#           Text(
#             label,
#             style: TextStyle(
#               fontSize: 12,
#               color: Colors.white.withOpacity(0.9),
#             ),
#           ),
#         ],
#       ),
#     )
#     .animate()
#     .fadeIn(delay: Duration(milliseconds: delay))
#     .scale(begin: const Offset(0.8, 0.8), delay: Duration(milliseconds: delay), duration: 600.ms);
#   }
# }

# // Custom painter for background pattern
# class _CirclePatternPainter extends CustomPainter {
#   final Color color;

#   _CirclePatternPainter(this.color);

#   @override
#   void paint(Canvas canvas, Size size) {
#     final paint = Paint()
#       ..color = color
#       ..style = PaintingStyle.stroke
#       ..strokeWidth = 2;

#     for (var i = 0; i < 5; i++) {
#       for (var j = 0; j < 5; j++) {
#         canvas.drawCircle(
#           Offset(i * size.width / 4, j * size.height / 4),
#           30,
#           paint,
#         );
#       }
#     }
#   }

#   @override
#   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
# }