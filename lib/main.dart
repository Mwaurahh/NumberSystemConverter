import 'package:flutter/material.dart';
//where the app starts by calling the runApp function with the root widget
void main() {
  runApp(const NumberConverterApp());
}


class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConverterScreen(),
    );
  }
}

// The main screen of the converter
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}
class _ConverterScreenState extends State<ConverterScreen> {
  // Controller to get the user's input from the TextField
  final TextEditingController _inputController = TextEditingController();
  
  // State variables for the selected number systems
  //tracks which number system is being converted from and to
  String _fromSystem = 'Decimal';
  String _toSystem = 'Binary';
  String _result = ''; 

  // List of supported number systems
  final List<String> _systems = ['Decimal', 'Binary', 'Octal', 'Hexadecimal'];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  // Helper function to get the numerical base from the system name
  int _getBase(String systemName) {
    //if else statement to determine the base
    switch (systemName) {
      case 'Decimal':
        return 10;
      case 'Binary':
        return 2;
      case 'Octal':
        return 8;
      case 'Hexadecimal':
        return 16;
      default:
        return 10; 
    }
  }

  // --- CORE CONVERSION FUNCTION ---
  void _convertNumber() {
    String input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _result = 'Please enter a number.';
      });
      return;
    }

    // Step 1: Convert input to an intermediate Decimal integer
    int fromBase = _getBase(_fromSystem);
    BigInt? decimalValue;

    try {
      // Use BigInt.tryParse to handle potentially large numbers and different bases
      decimalValue = BigInt.tryParse(input, radix: fromBase);
    } catch (e) {
      // Catch any parsing error (e.g., user enters 'G' while in Binary mode)
      setState(() {
        _result = 'Error: Invalid input for $_fromSystem system.';
      });
      return;
    }

    if (decimalValue == null) {
       setState(() {
        _result = 'Error: Invalid input for $_fromSystem system.';
      });
      return;
    }

    // Step 2: Convert the Decimal integer to the target system
    int toBase = _getBase(_toSystem);
    String finalResult = '';
    //the radix string method is used to convert the decimal value to the desired base\
    // and the toUpperCase method is used to convert the hexadecimal letters to uppercase
    //make work easier cleans the code 

    if (toBase == 10) {
      // To Decimal
      finalResult = decimalValue.toString();
    } else if (toBase == 2) {
      // To Binary
      finalResult = decimalValue.toRadixString(2);
    } else if (toBase == 8) {
      // To Octal
      finalResult = decimalValue.toRadixString(8);
    } else if (toBase == 16) {
      // To Hexadecimal
      finalResult = decimalValue.toRadixString(16).toUpperCase();
    }
    
    // Step 3: Update the UI with the result
    setState(() {
      _result = finalResult;
    });
  }

  // --- REST OF THE BUILD METHOD IS THE SAME ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: false,
      // ... (AppBar and SafeArea body structure)
      appBar: AppBar(
        title: const Text(
          'Number System Converter',
        ),
      backgroundColor: Colors.grey[900],
        
     foregroundColor: Colors.white,
      ),
    backgroundColor: Colors.grey[850],
    
      body: SafeArea(
        child: SingleChildScrollView(
          
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Input Field
              TextField(
                style: TextStyle(color:Colors.white),
                 controller: _inputController,
                // Removed specific keyboardType to allow Hex input (A-F)
                // We'll rely on the conversion logic for validation
                decoration: InputDecoration(
                  labelText: 'Enter Number to Convert',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.numbers, color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 20),

              // 2. 'From' System Selection
              const Text('Convert From:', style: TextStyle(fontSize: 16,
            
                  color: Colors.white)),
              DropdownButton<String>(
                dropdownColor: Colors.grey[800] ,
                value: _fromSystem,
                isExpanded: true,
                items: _systems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color:Colors.white)
                  ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _fromSystem = newValue!;
                    _convertNumber(); // Recalculate if systems change
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // 3. 'To' System Selection
              const Text('Convert To:', style: TextStyle(fontSize: 16,
                  color: Colors.white)),
              DropdownButton<String>(
                dropdownColor: Colors.grey[800] ,
                value: _toSystem,
                isExpanded: true,
                // giving the button its functionality
                items: _systems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color:Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _toSystem = newValue!;
                    _convertNumber(); // Recalculate if systems change
                  });
                },
              ),

              const SizedBox(height: 30),

              // 4. Convert Button
              ElevatedButton(
                onPressed: _convertNumber,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.grey[900],
                ),
                child: const Text(
                  'CONVERT',
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),

              const SizedBox(height: 40),

              // 5. Result Display
              const Text(
                'Result:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const Divider(),
              // Display result text with appropriate styling
              SelectableText(
                _result.isEmpty ? 'Awaiting input...' : _result,
                style: TextStyle(fontSize: 24, color: _result.contains('Error') ? Colors.red : Colors.green[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

