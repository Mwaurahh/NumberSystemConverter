import 'package:flutter/material.dart';
void main (){
  runApp(const NumberConverterApp());
}
//main app class
class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NUMBER CONVERTER APP',
      theme: ThemeData(
        // Define the default brightness and colors.
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      //we call the converter screen function here
      home: const ConverterScreen(),
    );
  }
}
//convert screen function 
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // where the user gets to input the number 
  final TextEditingController _inputController =TextEditingController();
// encapsulate the variables to ensure that external changes wount break the logic 
  String _fromSystem = 'DECIMAL';
  String _toSystem = 'BINARY';
  String _result = '';

final List<String> _systems = ['DECIMAL','BINARY','OCTAL','HEXADECIMAL'];

//clean the text editor 
 @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  // if else statements for the base values
  int _getBase(String systemName){
    switch (systemName) {
      case 'DECIMAL':
        return 10;
      case 'BINARY':
        return 2;
      case 'OCTAL':
        return 8;
      case 'HEXADECIMAL':
        return 16;
      default:
        return 10;
    }
  }

  void _convertNumber(){
    String input = _inputController.text.trim();
    if (input.isEmpty){
      setState((){
        _result = 'please enter a number';
      });
      return;
    }
    //get the base value of the from system
    int fromBase=_getBase(_fromSystem);
    //convert the input value to decimal first
    BigInt? decimalValue;
    //parse the input value and handle invalid input like letters in binary
    try{
      //converts the input value to bigint
      decimalValue = BigInt.tryParse(input,radix:fromBase);
    }
    //if an error occurs during parsing
    catch(e){
      setState((){
        _result='ERROR!! invalid input for $_fromSystem system.';
      });
      return;
    }
    //if parsing returns null
    if (decimalValue==null){
      setState((){
        _result='ERROR!! invalid input for $_fromSystem system.';
      });
      return;
    }

    //convert the decimal value to the target system
    int toBase = _getBase(_toSystem);
    String finalResult = '';

   if (toBase == 16) {
      finalResult = decimalValue.toRadixString(16).toUpperCase();
    } else {
      finalResult = decimalValue.toRadixString(toBase);
    }
    setState(() {
      _result = finalResult;
    });
  }

 
  void _clearInput() {
    setState(() {
      _inputController.clear();
      _result = '';
    });
  }

  @override
 Widget build(BuildContext context) {
   return Scaffold(
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
                 //button to clear the input field
                 suffixIcon: IconButton(
                   icon: const Icon(Icons.cancel, color: Colors.white),
                   onPressed: _clearInput, // Link to the new clearing function
                 ),
               ),
             ),
            
             const SizedBox(height: 20),

             // 2. FROM SYSTEM SELECTION 
             const Text('Convert From:', style: TextStyle(fontSize: 16,
          
                 color: Colors.white)),
             DropdownButton<String>(
               dropdownColor: Colors.grey[800] ,
               //shows the current selected value
               value: _fromSystem,
               isExpanded: true,
               //list _systems is mapped to create dropdown items
               items: _systems.map<DropdownMenuItem<String>>((String value) {
                //map through the list of systems to create dropdown items
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value, style: const TextStyle(color:Colors.white)),
                 );
               }).toList(),//creates a list of dropdown menu items
               //checks if the user changes the system 
               onChanged: (String? newValue) {
                 setState(() {
                  //checks if the new value is not null
                   _fromSystem = newValue!;
                   _convertNumber(); // Recalculate if systems change
                 });
               },
             ),
            
             const SizedBox(height: 20),

             // 3. TO SYSTEM SELECTION
             const Text('Convert To:', style: TextStyle(fontSize: 16,
                 color: Colors.white)),
             DropdownButton<String>(
               dropdownColor: Colors.grey[800] ,
               //shows the current selected value
               value: _toSystem,
               isExpanded: true,
               //list _systems is mapped to create dropdown items
               items: _systems.map<DropdownMenuItem<String>>((String value) {
                 return DropdownMenuItem<String>(
                   value: value,
                   child: Text(value, style: const TextStyle(color:Colors.white)),
                 );
               }).toList(),//creates a list of dropdown menu items
               //checks if the user changes the system
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