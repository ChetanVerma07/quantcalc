import 'package:flutter/material.dart';

class BasicCalcScreen extends StatefulWidget {
  const BasicCalcScreen({super.key});

  @override
  State<BasicCalcScreen> createState() => _BasicCalcScreenState();
}

class _BasicCalcScreenState extends State<BasicCalcScreen> {
  String expression = '';
  String result = '0';

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        expression = '';
        result = '0';
      } else if (buttonText == '=') {
        try {
          result = _evaluateExpression(expression).toString();
        } catch (e) {
          result = 'Error';
        }
      } else if (buttonText == '⌫') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else {
        expression += buttonText;
      }
    });
  }

  double _evaluateExpression(String expr) {
    // Simple expression evaluator (basic arithmetic)
    expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
    return eval(expr);
  }

  double eval(String expr) {
    // Basic eval implementation - in production use math_expressions package
    // This is simplified version
    final parts = expr.split(RegExp(r'([\+\-\*\/])'));
    double result = double.parse(parts[0]);

    for (int i = 1; i < parts.length; i += 2) {
      final operator = parts[i];
      final num = double.parse(parts[i + 1]);

      switch (operator) {
        case '+': result += num; break;
        case '-': result -= num; break;
        case '*': result *= num; break;
        case '/':
          if (num == 0) throw Exception('Division by zero');
          result /= num;
          break;
      }
    }
    return result;
  }

  Widget buildButton(String text, Color color, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () => buttonPressed(text),
          child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Calculator')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(expression, style: const TextStyle(fontSize: 24, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(result, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [buildButton('C', Colors.grey, Colors.white), buildButton('⌫', Colors.grey, Colors.white), buildButton('÷', Colors.orange, Colors.white)]),
              Row(children: [buildButton('7', Colors.white, Colors.black), buildButton('8', Colors.white, Colors.black), buildButton('9', Colors.white, Colors.black), buildButton('×', Colors.orange, Colors.white)]),
              Row(children: [buildButton('4', Colors.white, Colors.black), buildButton('5', Colors.white, Colors.black), buildButton('6', Colors.white, Colors.black), buildButton('-', Colors.orange, Colors.white)]),
              Row(children: [buildButton('1', Colors.white, Colors.black), buildButton('2', Colors.white, Colors.black), buildButton('3', Colors.white, Colors.black), buildButton('+', Colors.orange, Colors.white)]),
              Row(children: [buildButton('0', Colors.white, Colors.black), buildButton('.', Colors.white, Colors.black), buildButton('=', Colors.blue, Colors.white)]),
            ],
          ),
        ],
      ),
    );
  }
}
