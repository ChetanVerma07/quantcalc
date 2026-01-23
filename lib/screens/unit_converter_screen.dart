import 'package:flutter/material.dart';
import 'dart:ui' as ui; // ✅ REQUIRED for ImageFilter

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String fromUnit = 'Meter (m)';
  String toUnit = 'Kilometer (km)';
  double result = 0;

  final Map<String, double> lengthUnits = {
    'Nanometer (nm)': 1e-9,
    'Micrometer (μm)': 1e-6,
    'Millimeter (mm)': 0.001,
    'Centimeter (cm)': 0.01,
    'Meter (m)': 1.0,
    'Kilometer (km)': 1000.0,
    'Inch (in)': 0.0254,
    'Foot (ft)': 0.3048,
    'Yard (yd)': 0.9144,
    'Mile (mi)': 1609.34,
  };

  void convertLength(String input) {
    final value = double.tryParse(input) ?? 0;
    if (value == 0) {
      setState(() => result = 0);
      return;
    }

    setState(() {
      final fromFactor = lengthUnits[fromUnit]!;
      final toFactor = lengthUnits[toUnit]!;
      result = value * (fromFactor / toFactor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          'Length Converter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
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
          // ✅ FIXED: Deep Black Blur Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF121212)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0), // ✅ FIXED: Added 'ui.' prefix
              child: Container(
                color: const Color(0xAA000000).withOpacity(0.95),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    decoration: InputDecoration(
                      labelText: 'Enter Length',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[850]!.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      prefixIcon: const Icon(Icons.straighten, color: Colors.cyan),
                    ),
                    onChanged: convertLength,
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[850]!.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[700]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: fromUnit,
                        isExpanded: true,
                        decoration: const InputDecoration.collapsed(hintText: 'From'),
                        items: lengthUnits.keys.map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit, style: const TextStyle(color: Colors.white)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => fromUnit = value);
                            convertLength(_inputController.text);
                          }
                        },
                        dropdownColor: Colors.grey[850],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey[850]!.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_downward, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[850]!.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[700]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: toUnit,
                        isExpanded: true,
                        decoration: const InputDecoration.collapsed(hintText: 'To'),
                        items: lengthUnits.keys.map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit, style: const TextStyle(color: Colors.white)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => toUnit = value);
                            convertLength(_inputController.text);
                          }
                        },
                        dropdownColor: Colors.grey[850],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (result > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.cyan[700]!, Colors.cyan[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${result.toStringAsFixed(6)} $toUnit',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_inputController.text.isEmpty ? '0' : _inputController.text} $fromUnit = ${result.toStringAsFixed(6)} $toUnit',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }
}
