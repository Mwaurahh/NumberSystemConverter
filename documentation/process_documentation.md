# Number System Converter — Process Documentation

## Project Information
- Project Name: Number System Converter Application
- Platform: Flutter/Dart
- Document Version: 1.0
- Last Updated: October 14, 2025

Team Members:
- Alex Mwangi — https://github.com/Aleckqhie
- Anthony Chege - 
- Samson Mwaurah — https://github.com/Mwaurahh
- Alvin Mugo — https://github.com/Tamperke42
- Mike Moreti — https://github.com/garisonmike

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [System Architecture](#2-system-architecture)
3. [Application Flow](#3-application-flow)
4. [Core Components](#4-core-components)
5. [Conversion Logic](#5-conversion-logic)
6. [User Interface Design](#6-user-interface-design)
7. [Error Handling](#7-error-handling)
8. [Testing Guidelines](#8-testing-guidelines)
9. [Future Enhancements](#9-future-enhancements)
10. [Development Notes](#10-development-notes)
11. [Team Contributions](#11-team-contributions)
12. [Build & Run](#12-build--run)
13. [Code Quality](#13-code-quality)

---

## 1. Project Overview

### Purpose
The Number System Converter is a mobile application built with Flutter that converts numbers between Decimal, Binary, Octal, and Hexadecimal systems.

### Key Features
- Real-time number system conversion
- Support for four number systems (Decimal, Binary, Octal, Hexadecimal)
- Input validation and clear error messages
- Clean and intuitive UI with dark theme
- Support for large numbers using BigInt
- Quick clear/reset functionality

### Target Users
Students, developers, and anyone needing cross-base conversions for educational or professional use.

---

## 2. System Architecture

### Application Structure
1. NumberConverterApp (StatelessWidget)
2. ConverterScreen (StatefulWidget)
3. ConverterScreenState (State)
   - Input Controller
   - System Selectors
   - Conversion Logic
   - Result Display

### Component Hierarchy
- NumberConverterApp: Root widget configuring MaterialApp and theme.
- ConverterScreen: Hosts the converter UI and interactions.
- ConverterScreenState: Manages state and implements conversion logic.

### Repository Structure
- lib/
  - main.dart (app entry; defines NumberConverterApp)
  - screens/
    - converter_screen.dart (ConverterScreen, ConverterScreenState)
  - widgets/ (shared UI components, if any)
  - theme/ (theme definitions, if any)
- test/ (unit and widget tests)
- assets/ (if used)
- documentation/ (this document)

---

## 3. Application Flow

### User Journey
1. Launch application
2. Display Converter Screen
3. Enter number (input validation occurs)
4. Select source system (From)
5. Select target system (To)
6. Tap Convert → Execute conversion
7. Show result or error
8. Option to clear and start again

### State Management Flow
1. User inputs a number
2. User selects source number system
3. User selects target number system
4. Validate input for the selected source system
5. Convert input to decimal (base 10)
6. Convert decimal to target system
7. Display the result

---

## 4. Core Components

### State Variables

| Variable           | Type                  | Purpose                                         |
|-------------------|-----------------------|-------------------------------------------------|
| _inputController  | TextEditingController | Manages the text input field                    |
| _fromSystem       | String                | Selected source number system                   |
| _toSystem         | String                | Selected target number system                   |
| _result           | String                | Conversion result or error message              |
| _systems          | List<String>          | Available number systems list                   |

### Number Systems Supported

| System       | Base | Valid Characters     |
|--------------|------|----------------------|
| DECIMAL      | 10   | 0–9                  |
| BINARY       | 2    | 0–1                  |
| OCTAL        | 8    | 0–7                  |
| HEXADECIMAL  | 16   | 0–9, A–F (case-insensitive) |

---

## 5. Conversion Logic

### Process Overview
Two-step conversion:
1. Input → Decimal (parse using source base)
2. Decimal → Target (format using target base)

### Base Determination
- DECIMAL → 10
- BINARY → 2
- OCTAL → 8
- HEXADECIMAL → 16

### Algorithm
1. Parse input to decimal
   - Use `BigInt.tryParse(input, radix: sourceBase)`
   - Reject invalid characters per source system
   - If parsing fails, return an error
2. Convert decimal to target system
   - Use `decimal.toRadixString(targetBase)`
   - Uppercase the result for hexadecimal
   - Update UI

### Example Conversion
Converting Binary "1010" to Hexadecimal:
1. Input: "1010" (Binary)
2. Decimal: `BigInt.tryParse("1010", radix: 2)` → 10
3. Hex: `BigInt.from(10).toRadixString(16).toUpperCase()` → "A"
4. Result: "A"

### Notes
- Same-system optimization: if fromSystem == toSystem, return a normalized form of input (trimmed, uppercased for HEX) without reformatting errors.

### Reference Dart Snippet
```dart
int _baseFor(String system) {
  switch (system.toUpperCase()) {
    case 'BINARY': return 2;
    case 'OCTAL': return 8;
    case 'DECIMAL': return 10;
    case 'HEXADECIMAL': return 16;
    default: throw ArgumentError('Unsupported system: $system');
  }
}

String convert(String input, String fromSystem, String toSystem) {
  final fromBase = _baseFor(fromSystem);
  final toBase = _baseFor(toSystem);

  final decimal = BigInt.tryParse(input.trim(), radix: fromBase);
  if (decimal == null) {
    throw FormatException('ERROR!! invalid input for $fromSystem system.');
  }

  final out = decimal.toRadixString(toBase);
  return toBase == 16 ? out.toUpperCase() : out;
}
```

---

## 6. User Interface Design

### Color Scheme
- Background: Grey[850]
- App Bar: Grey[900]
- Text: White
- Success: Green[700]
- Error: Red

### UI Components
- Input Field
  - Label: "Enter Number to Convert"
  - Clear button (X icon) to reset input and result
- Dropdown Selectors
  - Two dropdowns: "Convert From:" and "Convert To:"
  - Auto-recalculate on system change (optional)
- Convert Button
  - Elevated button labeled "CONVERT"
  - Triggers conversion
- Result Display
  - "Result:" header with divider
  - Selectable output text
  - Color-coded output (green for success, red for errors)
  - Default: "Awaiting input..."

---

## 7. Error Handling

### Input Validation
- Empty Input
  - Trigger: Convert pressed with empty field
  - Response: "Please enter a number."
- Invalid Characters
  - Trigger: Characters not valid for selected system (e.g., 'A' in Binary)
  - Response: "ERROR!! invalid input for [SYSTEM] system."
- Parsing Failures
  - Trigger: `BigInt.tryParse()` returns null
  - Response: Error message mentioning the system

### Error Message Format
- Clear "ERROR!!" prefix
- Specific mention of the problematic system
- User-friendly language

---

## 8. Testing Guidelines

### Unit Testing Scenarios
- Input Validation
  1. Empty input handling
  2. Valid input per system
  3. Invalid characters per system
  4. Boundary values (very large numbers)
- Conversion Accuracy
  - Cross-conversions between Decimal, Binary, Octal, Hexadecimal
  - Hexadecimal to all systems covered
- Edge Cases
  1. Maximum BigInt scale inputs
  2. Zero value conversions
  3. Single-digit conversions
  4. System-to-same-system conversion

### UI Testing Checklist
- Input field accepts text
- Clear button removes input and result
- Dropdown menus show all systems
- System changes optionally trigger auto-conversion
- Convert button is responsive
- Result displays correctly
- Error messages are visible and clear
- Colors match design specs

### Visual (Golden) Tests
- Optional: add golden tests for the converter screen to prevent UI regressions.

### Test Data Examples

| Input | From System   | To System     | Expected Output    |
|------:|---------------|---------------|--------------------|
| 255   | DECIMAL       | BINARY        | 11111111           |
| 1010  | BINARY        | DECIMAL       | 10                 |
| 777   | OCTAL         | HEXADECIMAL   | 1FF                |
| FF    | HEXADECIMAL   | DECIMAL       | 255                |
| ABC   | HEXADECIMAL   | BINARY        | 101010111100       |

---

## 9. Future Enhancements
- Conversion history
- Support for fractional numbers
- Additional base systems
- Scientific notation support
- Dark and light themes
- Share/export conversion results

---

## 10. Development Notes

### Key Dart/Flutter Features
- StatefulWidget for state management
- TextEditingController for input handling
- BigInt for large-number support
- Switch statements for base mapping
- Try-catch for robust error handling

### Best Practices
- Encapsulation of state variables
- Proper disposal of controllers
- Consistent naming conventions
- Comprehensive, user-friendly error messages
- Responsive UI design

---

## 11. Team Contributions
Mike, Alex, Anthony, Mwaurah, and Alvin contributed to design, implementation, and testing of the Number System Converter application.

## 12. Build & Run
- Prereqs: Flutter SDK installed; run flutter doctor to verify setup.
- Get dependencies: flutter pub get
- Run (debug): flutter run
- Build (Android): flutter build apk --release
- Build (iOS): flutter build ios --release
- Web (if enabled): flutter build web

## 13. Code Quality
- Format: dart format .
- Static analysis: flutter analyze
- Tests: flutter test
- Suggested lints: use package:flutter_lints and enable strong-mode checks.