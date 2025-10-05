# Number System Converter

A Flutter mobile application that converts numbers between different number systems including Decimal, Binary, Octal, and Hexadecimal.

## Features

- **Multi-System Support**: Convert between Decimal, Binary, Octal, and Hexadecimal number systems
- **Bidirectional Conversion**: Choose any system as source or target
- **Real-time Conversion**: Automatic recalculation when switching number systems
- **Large Number Support**: Uses BigInt for handling large numbers
- **Input Validation**: Proper error handling for invalid inputs
- **Dark Theme UI**: Modern dark-themed interface for comfortable viewing
- **Selectable Results**: Copy conversion results easily

## Supported Number Systems

| System | Base | Valid Characters |
|--------|------|------------------|
| Decimal | 10 | 0-9 |
| Binary | 2 | 0-1 |
| Octal | 8 | 0-7 |
| Hexadecimal | 16 | 0-9, A-F |

## How It Works

The conversion process follows a two-step approach:

1. **Input to Decimal**: The input number is first parsed from its source number system into a decimal (base-10) integer using `BigInt.tryParse()` with the appropriate radix
2. **Decimal to Target**: The decimal value is then converted to the target number system using `toRadixString()` method

This intermediate conversion through decimal simplifies the logic and ensures accuracy across all conversion types.

## Installation

### Prerequisites

- Flutter SDK (2.0 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)
- Android Emulator/iOS Simulator or physical device

### Steps

1. Clone the repository:
```bash
git clone <repository-url>
cd number-converter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

1. **Enter a Number**: Type the number you want to convert in the input field
2. **Select Source System**: Use the "Convert From" dropdown to select the number system of your input
3. **Select Target System**: Use the "Convert To" dropdown to select the desired output number system
4. **Convert**: Click the "CONVERT" button to see the result
5. **View Result**: The converted number appears below, with error messages displayed in red if the input is invalid

### Example Conversions

- **Decimal to Binary**: Input `42` (Decimal) → Output `101010` (Binary)
- **Hexadecimal to Decimal**: Input `FF` (Hex) → Output `255` (Decimal)
- **Binary to Octal**: Input `11001` (Binary) → Output `31` (Octal)

## Project Structure

```
lib/
└── main.dart
    ├── NumberConverterApp (Root Widget)
    ├── ConverterScreen (Stateful Widget)
    └── _ConverterScreenState
    ├── _convertNumber() - Core conversion logic
    ├── _getBase() - Returns numerical base for system
    └── build() - UI layout
```

## Key Functions

### `_getBase(String systemName)`
Returns the numerical base (radix) for a given number system name.

### `_convertNumber()`
The core conversion function that:
- Validates input
- Parses input from source system to decimal
- Converts decimal to target system
- Updates UI with result or error message

## Error Handling

The app handles various error scenarios:
- Empty input fields
- Invalid characters for selected number system
- Parsing errors

All errors are displayed to the user with descriptive messages.

## Technologies Used

- **Flutter**: UI framework
- **Dart**: Programming language
- **BigInt**: For handling large number conversions
- **Material Design**: UI components and styling

## Future Enhancements

- [ ] Add conversion history
- [ ] Support for fractional numbers
- [ ] Add more number systems (Base-64, Base-32, etc.)
- [ ] Scientific notation support
- [ ] Dark/Light theme toggle
- [ ] Share conversion results

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).

## Author

Created as a learning project to demonstrate Flutter development and number system conversion algorithms.

## Support

For issues, questions, or suggestions, please open an issue in the repository.
