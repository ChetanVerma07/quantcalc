import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';
import 'calculator_screen.dart';
import 'gst_screen.dart';
import 'bmi_screen.dart';
import 'unit_converter_screen.dart';
import 'temp_converter_screen.dart';
import 'finance_screen.dart';
import 'sip_calculator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuantCalc',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildNavButton(context, 'Basic Calculator', Icons.calculate, () => const CalculatorScreen()),
            _buildNavButton(context, 'GST\nCalculator', Icons.receipt, () => const GstScreen()),
            _buildNavButton(context, 'B.M.I', Icons.fitness_center, () => const BmiScreen()),
            _buildNavButton(context, 'Units\nConverter', Icons.straighten, () => const UnitConverterScreen()),
            _buildNavButton(context, 'Temp Scale\nConverter', Icons.thermostat_auto_outlined, () => const TempConverterScreen()),
            _buildNavButton(context, 'Finance', Icons.account_balance_wallet, () => const FinanceScreen()),
            _buildNavButton(context, 'SIP and M.F\nReturns', Icons.trending_up, () => const SIPCalculatorScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, IconData icon, Widget Function() navigate) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => navigate())
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface.withValues(alpha: 0.3),
              theme.colorScheme.surface.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
