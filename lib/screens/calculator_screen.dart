import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String output = '0';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        output = '0';
      } else if (value == '⌫') {
        input = input.isEmpty ? '' : input.substring(0, input.length - 1);
      } else if (value == '=') {
        try {
          String finalInput = input
              .replaceAll('×', '*')
              .replaceAll('÷', '/');
          Parser p = Parser();
          Expression exp = p.parse(finalInput);
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          output = result.toString();
          if (output.endsWith('.0')) {
            output = output.split('.')[0];
          }
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  Widget _buildButtonRow(List<String> buttons, {bool isZero = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: buttons.map((btn) {
          bool isOperator = ['+', '-', '×', '÷', '=', '%'].contains(btn);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: () => buttonPressed(btn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOperator
                      ? const Color(0xFFFF6B35)
                      : Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: isZero && btn == '0'
                      ? const EdgeInsets.fromLTRB(32, 16, 8, 16)
                      : const EdgeInsets.all(16),
                ),
                child: Text(
                  btn,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: const TextStyle(fontSize: 24, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(output, style: const TextStyle(fontSize: 48, color: Colors.white)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              _buildButtonRow(['C', '⌫', '%', '÷']),
              _buildButtonRow(['7', '8', '9', '×']),
              _buildButtonRow(['4', '5', '6', '-']),
              _buildButtonRow(['1', '2', '3', '+']),
              _buildButtonRow(['0', '.', '='], isZero: true),
            ],
          ),
        ],
      ),
    );
  }
}
