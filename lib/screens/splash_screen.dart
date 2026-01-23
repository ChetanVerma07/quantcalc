import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = ColorTween(
      begin: Colors.orange.withOpacity(0.3),
      end: Colors.orange.withOpacity(0.8),
    ).animate(_controller);

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background Glow
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.5),
                    colors: [
                      _glowAnimation.value ?? Colors.yellow.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo/Icon
                AnimatedBuilder(
                  animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 0.1,
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.6),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.calculate,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // App Name with bounce
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_scaleAnimation.value - 1.0) * 0.3,
                      child: const Text(
                        'QuantCalc',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.orange,
                              offset: Offset(0, 2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  'A Calculator For Everything',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,  // ✅ Changed to pure white
                    fontWeight: FontWeight.bold,  // ✅ Added bold
                    letterSpacing: 1,
                  ),
                ),


                const SizedBox(height: 50),



                Column(
                  children: [
                    const SizedBox(height: 30),

                    // ASR PRODUCT - Light yellow with neon outline
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.9),
                              Colors.orange.withValues(alpha: 0.7),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'An ASR PRODUCT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.yellow,
                                  offset: Offset(0, 0),
                                  blurRadius: 20,
                                ),
                                Shadow(
                                  color: Colors.orange,
                                  offset: Offset(0, 0),
                                  blurRadius: 15,
                                ),
                                Shadow(
                                  color: Colors.yellow,
                                  offset: Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Made by Anubhav Singh Rajput
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.yellow.withValues(alpha: 0.8),
                              Colors.amber.withValues(alpha: 0.6),
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'Made by Anubhav Singh Rajput',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.yellow,
                                  offset: Offset(0, 0),
                                  blurRadius: 15,
                                ),
                                Shadow(
                                  color: Colors.orange,
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                ),
                                Shadow(
                                  color: Colors.amber,
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    // Loading dots (keep existing)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ... existing loading dots code
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
