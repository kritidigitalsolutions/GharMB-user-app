import 'dart:math';

import 'package:riverpod/legacy.dart';

// ─── Loan Calculator ──────────────────────────────────────────
class LoanState {
  final double loanAmount; // in lakhs
  final double interestRate; // in %
  final double tenure; // in years

  const LoanState({
    this.loanAmount = 50,
    this.interestRate = 8.0,
    this.tenure = 20,
  });

  double get monthlyEMI {
    final p = loanAmount * 100000;
    final r = interestRate / 12 / 100;
    final n = tenure * 12;
    if (r == 0) return p / n;
    return p * r * pow(1 + r, n) / (pow(1 + r, n) - 1);
  }

  double get totalPayable => monthlyEMI * tenure * 12;
  double get totalInterest => totalPayable - (loanAmount * 100000);
  double get processingFees => loanAmount * 100000 * 0.004; // 0.4%
  double get otherCharges => loanAmount * 100000 * 0.008; // 0.8%

  bool get isAffordable => monthlyEMI <= 50000;

  LoanState copyWith({
    double? loanAmount,
    double? interestRate,
    double? tenure,
  }) {
    return LoanState(
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      tenure: tenure ?? this.tenure,
    );
  }
}

final loanProvider = StateNotifierProvider<LoanNotifier, LoanState>(
  (ref) => LoanNotifier(),
);

class LoanNotifier extends StateNotifier<LoanState> {
  LoanNotifier() : super(const LoanState());

  void setLoanAmount(double v) => state = state.copyWith(loanAmount: v);
  void setInterestRate(double v) => state = state.copyWith(interestRate: v);
  void setTenure(double v) => state = state.copyWith(tenure: v);
}

// ─── Unit Converter ───────────────────────────────────────────
enum UnitCategory { area, length, volume, weight }

class UnitConverterState {
  final UnitCategory category;
  final String inputUnit;
  final double inputValue;

  const UnitConverterState({
    this.category = UnitCategory.area,
    this.inputUnit = 'Sq Ft',
    this.inputValue = 1000,
  });

  UnitConverterState copyWith({
    UnitCategory? category,
    String? inputUnit,
    double? inputValue,
  }) {
    return UnitConverterState(
      category: category ?? this.category,
      inputUnit: inputUnit ?? this.inputUnit,
      inputValue: inputValue ?? this.inputValue,
    );
  }
}

final unitConverterProvider =
    StateNotifierProvider<UnitConverterNotifier, UnitConverterState>(
      (ref) => UnitConverterNotifier(),
    );

class UnitConverterNotifier extends StateNotifier<UnitConverterState> {
  UnitConverterNotifier() : super(const UnitConverterState());

  void setCategory(UnitCategory c) {
    final defaultUnit = _defaultUnits[c]!;
    state = state.copyWith(
      category: c,
      inputUnit: defaultUnit,
      inputValue: 1000,
    );
  }

  void setInputUnit(String unit) => state = state.copyWith(inputUnit: unit);
  void setInputValue(double v) => state = state.copyWith(inputValue: v);

  static const _defaultUnits = {
    UnitCategory.area: 'Sq Ft',
    UnitCategory.length: 'Meter',
    UnitCategory.volume: 'Liter',
    UnitCategory.weight: 'Kg',
  };
}

// ─── Conversion Logic ─────────────────────────────────────────
Map<String, double> convertArea(double value, String fromUnit) {
  // Convert to sq ft first
  double sqFt;
  switch (fromUnit) {
    case 'Sq Ft':
      sqFt = value;
      break;
    case 'Sq Meter':
      sqFt = value * 10.7639;
      break;
    case 'Sq Yard':
      sqFt = value * 9;
      break;
    case 'Acre':
      sqFt = value * 43560;
      break;
    case 'Hectare':
      sqFt = value * 107639;
      break;
    default:
      sqFt = value;
  }
  return {
    'Sq Meter': double.parse((sqFt / 10.7639).toStringAsFixed(2)),
    'Sq Yard': double.parse((sqFt / 9).toStringAsFixed(2)),
    'Acre': double.parse((sqFt / 43560).toStringAsFixed(2)),
    'Hectare': double.parse((sqFt / 107639).toStringAsFixed(2)),
  };
}

Map<String, double> convertLength(double value, String fromUnit) {
  double meters;
  switch (fromUnit) {
    case 'Meter':
      meters = value;
      break;
    case 'Feet':
      meters = value * 0.3048;
      break;
    case 'Inch':
      meters = value * 0.0254;
      break;
    case 'Km':
      meters = value * 1000;
      break;
    default:
      meters = value;
  }
  return {
    'Feet': double.parse((meters / 0.3048).toStringAsFixed(2)),
    'Inch': double.parse((meters / 0.0254).toStringAsFixed(2)),
    'Km': double.parse((meters / 1000).toStringAsFixed(2)),
    'Cm': double.parse((meters * 100).toStringAsFixed(2)),
  };
}

Map<String, double> convertVolume(double value, String fromUnit) {
  double liters;
  switch (fromUnit) {
    case 'Liter':
      liters = value;
      break;
    case 'Gallon':
      liters = value * 3.78541;
      break;
    case 'ML':
      liters = value / 1000;
      break;
    case 'Cu Ft':
      liters = value * 28.3168;
      break;
    default:
      liters = value;
  }
  return {
    'Gallon': double.parse((liters / 3.78541).toStringAsFixed(2)),
    'ML': double.parse((liters * 1000).toStringAsFixed(2)),
    'Cu Ft': double.parse((liters / 28.3168).toStringAsFixed(2)),
    'Cu Meter': double.parse((liters / 1000).toStringAsFixed(2)),
  };
}

Map<String, double> convertWeight(double value, String fromUnit) {
  double kg;
  switch (fromUnit) {
    case 'Kg':
      kg = value;
      break;
    case 'Gram':
      kg = value / 1000;
      break;
    case 'Pound':
      kg = value * 0.453592;
      break;
    case 'Tonne':
      kg = value * 1000;
      break;
    default:
      kg = value;
  }
  return {
    'Gram': double.parse((kg * 1000).toStringAsFixed(2)),
    'Pound': double.parse((kg / 0.453592).toStringAsFixed(2)),
    'Tonne': double.parse((kg / 1000).toStringAsFixed(2)),
    'Quintal': double.parse((kg / 100).toStringAsFixed(2)),
  };
}

Map<String, List<String>> unitOptions = {
  'area': ['Sq Ft', 'Sq Meter', 'Sq Yard', 'Acre', 'Hectare'],
  'length': ['Meter', 'Feet', 'Inch', 'Km', 'Cm'],
  'volume': ['Liter', 'Gallon', 'ML', 'Cu Ft', 'Cu Meter'],
  'weight': ['Kg', 'Gram', 'Pound', 'Tonne', 'Quintal'],
};
