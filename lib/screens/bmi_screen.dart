import 'package:flutter/material.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  double bmi = 0;
  String result = '';

  void calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0 / 100;

    if (weight > 0 && height > 0) {
      bmi = weight / (height * height);
      String status;
      if (bmi < 18.5) status = 'Underweight';
      else if (bmi < 25) status = 'Normal';
      else if (bmi < 30) status = 'Overweight';
      else status = 'Obese';
      result = status;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator'), backgroundColor: const Color(0xFFFF6B35)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
              child: const Text('Calculate BMI', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            if (bmi > 0)
              Column(
                children: [
                  Text('BMI: ${bmi.toStringAsFixed(1)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(result, style: TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
