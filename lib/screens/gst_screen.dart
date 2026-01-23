import 'package:flutter/material.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});

  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cgstController = TextEditingController();
  final TextEditingController sgstController = TextEditingController();
  double total = 0;

  void calculateGST() {
    double amount = double.tryParse(amountController.text) ?? 0;
    double cgstRate = double.tryParse(cgstController.text) ?? 0;
    double sgstRate = double.tryParse(sgstController.text) ?? 0;

    double cgstAmount = (amount * cgstRate) / 100;
    double sgstAmount = (amount * sgstRate) / 100;
    total = amount + cgstAmount + sgstAmount;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GST Calculator'), backgroundColor: const Color(0xFFFF6B35)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cgstController,
              decoration: const InputDecoration(labelText: 'CGST %', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: sgstController,
              decoration: const InputDecoration(labelText: 'SGST %', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateGST,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
              child: const Text('Calculate', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            if (total > 0) ...[
              Text('Total Amount: ₹${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('CGST: ₹${((double.tryParse(amountController.text) ?? 0) * (double.tryParse(cgstController.text) ?? 0) / 100).toStringAsFixed(2)}'),
              Text('SGST: ₹${((double.tryParse(amountController.text) ?? 0) * (double.tryParse(sgstController.text) ?? 0) / 100).toStringAsFixed(2)}'),
            ],
          ],
        ),
      ),
    );
  }
}
