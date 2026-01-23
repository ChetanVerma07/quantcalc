import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class SIPCalculatorScreen extends StatefulWidget {
  const SIPCalculatorScreen({super.key});

  @override
  State<SIPCalculatorScreen> createState() => _SIPCalculatorScreenState();
}

class _SIPCalculatorScreenState extends State<SIPCalculatorScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _resultController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Controllers
  final TextEditingController monthlyInvestmentController =
  TextEditingController();
  final TextEditingController annualReturnController =
  TextEditingController(text: '12');
  final TextEditingController investmentYearsController =
  TextEditingController();

  double futureValue = 0;
  double totalInvested = 0;
  double totalInterest = 0;
  List<double> yearlyReturns = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _resultController.dispose();
    monthlyInvestmentController.dispose();
    annualReturnController.dispose();
    investmentYearsController.dispose();
    super.dispose();
  }

  void calculateSIP() {
    double monthlyInvestment = double.tryParse(monthlyInvestmentController.text) ?? 0;
    double annualReturn = double.tryParse(annualReturnController.text) ?? 0;
    double years = double.tryParse(investmentYearsController.text) ?? 0;

    if (monthlyInvestment > 0 && annualReturn > 0 && years > 0) {
      double monthlyRate = annualReturn / 12 / 100;
      int totalMonths = (years * 12).round();

      // SIP Future Value Formula
      futureValue = monthlyInvestment *
          ((math.pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) *
          (1 + monthlyRate);

      totalInvested = monthlyInvestment * totalMonths;
      totalInterest = futureValue - totalInvested;

      // Calculate yearly returns for chart
      yearlyReturns.clear();
      for (int year = 1; year <= years; year++) {
        int months = year * 12;
        double yearValue = monthlyInvestment *
            ((math.pow(1 + monthlyRate, months) - 1) / monthlyRate) *
            (1 + monthlyRate);
        yearlyReturns.add(yearValue);
      }

      setState(() {});
      _resultController.forward().then((_) => _resultController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'SIP and Mutual Fund Calculator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4)],
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.green.withValues(alpha: 0.3),
        backgroundColor: Colors.transparent,
        flexibleSpace: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2E7D32).withValues(alpha: 0.95 + _controller.value * 0.05),
                    Color(0xFF4CAF50),
                    Color(0xFF81C784).withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Animated Green Gradient Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A3C34).withValues(alpha: 1 - _controller.value * 0.2),
                      Color(0xFF2E7D32),
                      Color(0xFF4CAF50).withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 2.0 + _controller.value * 3,
                    sigmaY: 2.0 + _controller.value * 3,
                  ),
                  child: Container(color: const Color(0xAA000000).withValues(alpha: 0.95)),
                ),
              );
            },
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // Animated Title
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _controller.value)),
                        child: Opacity(
                          opacity: _controller.value,
                          child: const Text(
                            'Calculate Your SIP Returns',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              shadows: [Shadow(color: Colors.green, blurRadius: 10)],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Input Fields
                  _buildAnimatedInputField(monthlyInvestmentController, 'Monthly Investment (₹)', Icons.account_balance_wallet, TextInputType.number),
                  _buildAnimatedInputField(annualReturnController, 'Expected (Annual) Return % (in Percentage)', Icons.trending_up, TextInputType.number),
                  _buildAnimatedInputField(investmentYearsController, 'Investment Period (Years)', Icons.calendar_today, TextInputType.number),

                  const SizedBox(height: 35),

                  // Calculate Button
                  _buildAnimatedCalculateButton('Calculate Returns', calculateSIP, Colors.green),

                  // Results
                  if (futureValue > 0) ...[
                    const SizedBox(height: 34),
                    AnimatedBuilder(
                      animation: _resultController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: _buildResultsCard(),
                          ),
                        );
                      },
                    ),

                    // Yearly Growth Chart
                    if (yearlyReturns.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      _buildGrowthChart(),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedInputField(TextEditingController controller, String label, IconData icon, TextInputType type) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: _buildInputField(controller, label, icon, type));
      },
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
          filled: true,
          fillColor: Colors.grey[850]!.withValues(alpha: 0.92),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCalculateButton(String text, VoidCallback onPressed, Color color) {
    return GestureDetector(
      onTapDown: (_) => _resultController.forward(),
      onTapUp: (_) => _resultController.reverse(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2)],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onPressed,
            child: Center(
              child: Text(text, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.withValues(alpha: 0.9), Colors.green]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.6), blurRadius: 30, spreadRadius: 3)],
      ),
      child: Column(
        children: [
          Text('Future Value', style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('₹${futureValue.toStringAsFixed(0)}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildResultChip('Invested', '₹${totalInvested.toStringAsFixed(0)}', Colors.grey)),
              Expanded(child: _buildResultChip('Returns', '₹${totalInterest.toStringAsFixed(0)}', Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomPaint(
        painter: GrowthChartPainter(yearlyReturns),
      ),
    );
  }
}

class GrowthChartPainter extends CustomPainter {
  final List<double> data;
  GrowthChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxValue = data.reduce(math.max);

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] / maxValue * size.height * 0.8);

      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
