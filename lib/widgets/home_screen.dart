import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeButton(this.title, this.icon, this.onTap, {super.key});

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pressAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse().then((_) => widget.onTap());
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFFF6B35);
    final deepBlack = Color(0xFF0A0A0A);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective for 3D effect
              ..rotateX(_pressAnimation.value * math.pi / 12)
              ..translate(0.0, _pressAnimation.value * 8),
            alignment: Alignment.center,
            child: Container(
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    deepBlack,
                    deepBlack.withOpacity(0.9),
                    deepBlack,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  // Main glow shadow
                  BoxShadow(
                    color: orange.withOpacity(_glowAnimation.value),
                    blurRadius: 25,
                    spreadRadius: _pressAnimation.value * 2,
                    offset: const Offset(0, 12),
                  ),
                  // Deep inner shadow for 3D depth
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 8,
                    offset: const Offset(2, 6),
                  ),
                  // Outer edge highlight
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(-2, -4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 3D Side panel effect
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Transform(
                      transform: Matrix4.skewY(0.3),
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 8 + _pressAnimation.value * 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              deepBlack.withOpacity(0.7),
                              deepBlack.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateY(_pressAnimation.value * math.pi / 20),
                          alignment: Alignment.center,
                          child: Icon(
                            widget.icon,
                            size: 40,
                            color: orange.withOpacity(
                              0.9 - _pressAnimation.value * 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: const Offset(1, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Example AppBar with 3D text effect
class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AnimatedAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFFF6B35);

    return Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [orange, orange.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-math.pi / 12),
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        offset: const Offset(2, 4),
                        blurRadius: 8,
                      ),
                      Shadow(
                        color: Colors.orangeAccent,
                        offset: const Offset(-1, -1),
                        blurRadius: 12,
                      ),
                    ],
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
