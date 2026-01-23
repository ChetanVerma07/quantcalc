import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int selectedTab = 0; // 0=Mortgage, 1=Simple Interest, 2=Compound Interest

  // Mortgage Controller
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController yearsController = TextEditingController();
  double mortgageEMI = 0;

  // Simple Interest Controller
  final TextEditingController siPrincipalController = TextEditingController();
  final TextEditingController siRateController = TextEditingController();
  final TextEditingController siTimeController = TextEditingController();
  double simpleInterest = 0;
  double siTotalAmount = 0;

  // Compound Interest Controller
  final TextEditingController ciPrincipalController = TextEditingController();
  final TextEditingController ciRateController = TextEditingController();
  final TextEditingController ciTimeController = TextEditingController();
  final TextEditingController ciCompoundsController = TextEditingController(text: '12');
  double compoundInterest = 0;
  double ciTotalAmount = 0;

  // Calculate Mortgage EMI
  void calculateMortgage() {
    double principal = double.tryParse(principalController.text) ?? 0;
    double monthlyRate = (double.tryParse(rateController.text) ?? 0) / 100 / 12;
    double months = (double.tryParse(yearsController.text) ?? 0) * 12;

    if (principal > 0 && monthlyRate > 0 && months > 0) {
      double emi = (principal * monthlyRate * math.pow(1 + monthlyRate, months)) /  // ✅ FIXED: math.pow()
          (math.pow(1 + monthlyRate, months) - 1);                                // ✅ FIXED: math.pow()
      setState(() => mortgageEMI = emi);
    }
  }

  // Calculate Simple Interest
  void calculateSimpleInterest() {
    double principal = double.tryParse(siPrincipalController.text) ?? 0;
    double rate = double.tryParse(siRateController.text) ?? 0;
    double time = double.tryParse(siTimeController.text) ?? 0;

    if (principal > 0 && rate > 0 && time > 0) {
      double interest = (principal * rate * time) / 100;
      double total = principal + interest;
      setState(() {
        simpleInterest = interest;
        siTotalAmount = total;
      });
    }
  }

  // Calculate Compound Interest
  void calculateCompoundInterest() {
    double principal = double.tryParse(ciPrincipalController.text) ?? 0;
    double rate = double.tryParse(ciRateController.text) ?? 0;
    double time = double.tryParse(ciTimeController.text) ?? 0;
    int compounds = int.tryParse(ciCompoundsController.text) ?? 12;

    if (principal > 0 && rate > 0 && time > 0) {
      double amount = principal * math.pow(1 + rate / 100 / compounds, compounds * time);  // ✅ FIXED: math.pow()
      double interest = amount - principal;
      setState(() {
        compoundInterest = interest;
        ciTotalAmount = amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Finance Calculator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Deep Black Blur Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF121212)],
              ),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(color: const Color(0xAA000000).withOpacity(0.95)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Tab Buttons
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTabButton(0, 'Mortgage', selectedTab == 0),
                        _buildTabButton(1, 'Simple Interest', selectedTab == 1),
                        _buildTabButton(2, 'Compound Interest', selectedTab == 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Content based on selected tab
                  if (selectedTab == 0) _buildMortgageCalculator(),
                  if (selectedTab == 1) _buildSimpleInterestCalculator(),
                  if (selectedTab == 2) _buildCompoundInterestCalculator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... rest of the methods remain EXACTLY THE SAME ...
  Widget _buildTabButton(int index, String title, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[850],
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? Colors.orange : Colors.black).withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMortgageCalculator() {
    return Column(
      children: [
        _buildInputField(principalController, 'Loan Amount', Icons.account_balance, TextInputType.number),
        _buildInputField(rateController, 'Interest Rate %', Icons.trending_up, TextInputType.number),
        _buildInputField(yearsController, 'Years', Icons.calendar_today, TextInputType.number),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: calculateMortgage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text('Calculate EMI', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        if (mortgageEMI > 0) ...[
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green[700]!, Colors.green[500]!]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 20)],
            ),
            child: Column(
              children: [
                Text('Monthly EMI: ₹${mortgageEMI.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Text('Total Payment: ₹${(mortgageEMI * (double.tryParse(yearsController.text) ?? 0) * 12).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSimpleInterestCalculator() {
    return Column(
      children: [
        _buildInputField(siPrincipalController, 'Principal', Icons.account_balance, TextInputType.number),
        _buildInputField(siRateController, 'Rate % per year', Icons.trending_up, TextInputType.number),
        _buildInputField(siTimeController, 'Time (years)', Icons.calendar_today, TextInputType.number),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: calculateSimpleInterest,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
          child: const Text('Calculate', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        if (simpleInterest > 0) ...[
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 20)],
            ),
            child: Column(
              children: [
                Text('Interest: ₹${simpleInterest.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Total: ₹${siTotalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompoundInterestCalculator() {
    return Column(
      children: [
        _buildInputField(ciPrincipalController, 'Principal', Icons.account_balance, TextInputType.number),
        _buildInputField(ciRateController, 'Rate % per year', Icons.trending_up, TextInputType.number),
        _buildInputField(ciTimeController, 'Time (years)', Icons.calendar_today, TextInputType.number),
        _buildInputField(ciCompoundsController, 'Compounds per year (12)', Icons.update, TextInputType.number),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: calculateCompoundInterest,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
          child: const Text('Calculate', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        if (compoundInterest > 0) ...[
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple[700]!, Colors.purple[500]!]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.4), blurRadius: 20)],
            ),
            child: Column(
              children: [
                Text('Interest: ₹${compoundInterest.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Total: ₹${ciTotalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18)),
              ],
            ),
          ),
        ],
      ],
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
          prefixIcon: Icon(icon, color: const Color(0xFFFF6B35)),
          filled: true,
          fillColor: Colors.grey[850]!.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
