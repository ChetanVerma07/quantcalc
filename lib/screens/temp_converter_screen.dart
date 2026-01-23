import 'package:flutter/material.dart';

class TempConverterScreen extends StatefulWidget {
  const TempConverterScreen({super.key});

  @override
  State<TempConverterScreen> createState() => _TempConverterScreenState();
}

class _TempConverterScreenState extends State<TempConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String fromUnit = 'Celsius';
  String toUnit = 'Fahrenheit';

  double celsiusResult = 0;

  final List<String> tempUnits = ['Celsius', 'Fahrenheit', 'Kelvin'];

  void convertTemp(String input) {
    final value = double.tryParse(input) ?? 0;
    if (value == 0) return;

    setState(() {
      // Convert to Celsius first
      double celsius;
      switch (fromUnit) {
        case 'Celsius':
          celsius = value;
          break;
        case 'Fahrenheit':
          celsius = (value - 32) * 5 / 9;
          break;
        case 'Kelvin':
          celsius = value - 273.15;
          break;
        default:
          celsius = value;
      }

      // Convert from Celsius to target
      switch (toUnit) {
        case 'Celsius':
          celsiusResult = celsius;
          break;
        case 'Fahrenheit':
          celsiusResult = (celsius * 9 / 5) + 32;
          break;
        case 'Kelvin':
          celsiusResult = celsius + 273.15;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Temperature Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Input Field
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 24),
                decoration: InputDecoration(
                  labelText: 'Enter Temperature',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  prefixIcon: const Icon(Icons.thermostat, color: Colors.orange),
                ),
                onChanged: convertTemp,
              ),
              const SizedBox(height: 30),

              // FROM Dropdown
              DropdownButtonFormField<String>(
                value: fromUnit,
                decoration: InputDecoration(
                  labelText: 'From',
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                items: tempUnits.map((unit) => DropdownMenuItem(
                  value: unit,
                  child: Text(unit, style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => fromUnit = value);
                    convertTemp(_inputController.text);
                  }
                },
                dropdownColor: Colors.grey[850],
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Arrow
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_downward, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),

              // TO Dropdown
              DropdownButtonFormField<String>(
                value: toUnit,
                decoration: InputDecoration(
                  labelText: 'To',
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                items: tempUnits.map((unit) => DropdownMenuItem(
                  value: unit,
                  child: Text(unit, style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => toUnit = value);
                    convertTemp(_inputController.text);
                  }
                },
                dropdownColor: Colors.grey[850],
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),

              // Result
              if (celsiusResult != 0)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.orange[700],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${celsiusResult.toStringAsFixed(2)} $toUnit',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$fromUnit → $toUnit',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
