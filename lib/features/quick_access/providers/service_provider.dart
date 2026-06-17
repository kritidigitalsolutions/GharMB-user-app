import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─────────────────────────────────────────────
// HOME LOAN
// ─────────────────────────────────────────────
class HomeLoanState {
  final double monthlyIncome;
  final double propertyValue;
  final double existingEmi;

  const HomeLoanState({
    this.monthlyIncome = 120000,
    this.propertyValue = 895000,
    this.existingEmi = 0,
  });

  double get minEligibility => propertyValue * 0.68;
  double get maxEligibility => propertyValue * 0.72;

  HomeLoanState copyWith({
    double? monthlyIncome,
    double? propertyValue,
    double? existingEmi,
  }) => HomeLoanState(
    monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    propertyValue: propertyValue ?? this.propertyValue,
    existingEmi: existingEmi ?? this.existingEmi,
  );
}

class HomeLoanNotifier extends StateNotifier<HomeLoanState> {
  HomeLoanNotifier() : super(const HomeLoanState());
  void setMonthlyIncome(double v) => state = state.copyWith(monthlyIncome: v);
  void setPropertyValue(double v) => state = state.copyWith(propertyValue: v);
  void setExistingEmi(double v) => state = state.copyWith(existingEmi: v);
}

final homeLoanProvider = StateNotifierProvider<HomeLoanNotifier, HomeLoanState>(
  (ref) => HomeLoanNotifier(),
);

class LenderModel {
  final String name;
  final String logo;
  final String rate;
  final String tag;
  final String tagline;
  const LenderModel({
    required this.name,
    required this.logo,
    required this.rate,
    required this.tag,
    required this.tagline,
  });
}

final lendersProvider = Provider<List<LenderModel>>(
  (ref) => const [
    LenderModel(
      name: 'SBI Home Loan',
      logo: 'SBI',
      rate: '8.50%',
      tag: 'Best',
      tagline: '0.5% processing - No prepay',
    ),
    LenderModel(
      name: 'HDFC Bank',
      logo: 'HDFC',
      rate: '8.75%',
      tag: '',
      tagline: 'Fast approval - digital process',
    ),
    LenderModel(
      name: 'ICICI',
      logo: 'ICICI',
      rate: '8.90%',
      tag: '',
      tagline: '48hr disbursal',
    ),
  ],
);

// ─────────────────────────────────────────────
// INTERIOR DESIGN
// ─────────────────────────────────────────────
enum InteriorStyle { allStyles, modern, minimal, classic, luxury }

class InteriorDesignState {
  final InteriorStyle selectedStyle;
  const InteriorDesignState({this.selectedStyle = InteriorStyle.allStyles});
  InteriorDesignState copyWith({InteriorStyle? selectedStyle}) =>
      InteriorDesignState(selectedStyle: selectedStyle ?? this.selectedStyle);
}

class InteriorDesignNotifier extends StateNotifier<InteriorDesignState> {
  InteriorDesignNotifier() : super(const InteriorDesignState());
  void setStyle(InteriorStyle s) => state = state.copyWith(selectedStyle: s);
}

final interiorDesignProvider =
    StateNotifierProvider<InteriorDesignNotifier, InteriorDesignState>(
      (ref) => InteriorDesignNotifier(),
    );

class InteriorPackage {
  final String name;
  final String price;
  final String description;
  final Color color;
  const InteriorPackage({
    required this.name,
    required this.price,
    required this.description,
    required this.color,
  });
}

final interiorPackagesProvider = Provider<List<InteriorPackage>>(
  (ref) => [
    InteriorPackage(
      name: 'Basic',
      price: '₹2.5 Lakhs',
      description: 'Essential design for comfortable living',
      color: const Color(0xFF2D9CDB),
    ),
    InteriorPackage(
      name: 'Premium',
      price: '₹5.0 Lakhs',
      description: 'Stylish design with premium quality Luxury',
      color: const Color(0xFFF35402),
    ),
    InteriorPackage(
      name: 'Luxury',
      price: '₹10.0 Lakhs',
      description: 'High-end luxury custom interiors',
      color: const Color(0xFFDBBC00),
    ),
  ],
);

// ─────────────────────────────────────────────
// LEGAL SERVICES
// ─────────────────────────────────────────────
class LegalService {
  final String title;
  final String subtitle;
  final String price;
  final bool isFree;
  final String icon;
  const LegalService({
    required this.title,
    required this.subtitle,
    required this.price,
    this.isFree = false,
    required this.icon,
  });
}

final legalServicesProvider = Provider<List<LegalService>>(
  (ref) => const [
    LegalService(
      title: 'Sale deed drafting',
      subtitle: 'Lawyer prepares your sale agreement',
      price: '₹2,999',
      icon: 'document',
    ),
    LegalService(
      title: 'Title search & verification',
      subtitle: 'Check for disputes / legal dues',
      price: '₹1,999',
      icon: 'search',
    ),
    LegalService(
      title: 'Property registration',
      subtitle: 'Complete registrar office support',
      price: '₹4,999',
      icon: 'home',
    ),
    LegalService(
      title: 'Stamp duty calculation',
      subtitle: 'State-specific accurate estimate',
      price: 'Free',
      isFree: true,
      icon: 'calculate',
    ),
    LegalService(
      title: 'Power of attorney',
      subtitle: 'NRI or absent owner cases',
      price: '₹3,499',
      icon: 'person',
    ),
    LegalService(
      title: 'Agreement Verification',
      subtitle: 'Verify any property agreement',
      price: '₹3,499',
      icon: 'verify',
    ),
  ],
);

// ─────────────────────────────────────────────
// PACKERS & MOVERS
// ─────────────────────────────────────────────
class PackersMoverState {
  final String fromLocation;
  final String toLocation;
  final DateTime? moveDate;
  final String homeSize;

  const PackersMoverState({
    this.fromLocation = 'Move from Sector 62, Noida',
    this.toLocation = '',
    this.moveDate,
    this.homeSize = '3 BHK',
  });

  PackersMoverState copyWith({
    String? fromLocation,
    String? toLocation,
    DateTime? moveDate,
    String? homeSize,
  }) => PackersMoverState(
    fromLocation: fromLocation ?? this.fromLocation,
    toLocation: toLocation ?? this.toLocation,
    moveDate: moveDate ?? this.moveDate,
    homeSize: homeSize ?? this.homeSize,
  );
}

class PackersMoverNotifier extends StateNotifier<PackersMoverState> {
  PackersMoverNotifier() : super(const PackersMoverState());
  void setFrom(String v) => state = state.copyWith(fromLocation: v);
  void setTo(String v) => state = state.copyWith(toLocation: v);
  void setDate(DateTime v) => state = state.copyWith(moveDate: v);
  void setHomeSize(String v) => state = state.copyWith(homeSize: v);
}

final packersMoverProvider =
    StateNotifierProvider<PackersMoverNotifier, PackersMoverState>(
      (ref) => PackersMoverNotifier(),
    );

class MoverCompany {
  final String name;
  final String rating;
  final String reviews;
  final String coverage;
  final String price;
  final String tag;
  const MoverCompany({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.coverage,
    required this.price,
    this.tag = '',
  });
}

final moverCompaniesProvider = Provider<List<MoverCompany>>(
  (ref) => const [
    MoverCompany(
      name: 'SafeMove Packers',
      rating: '4.8',
      reviews: '700+',
      coverage: 'Noida & Delhi NCR',
      price: '₹8,500',
      tag: 'est.',
    ),
    MoverCompany(
      name: 'QuickShift Movers',
      rating: '4.6',
      reviews: '500+',
      coverage: 'pan NCR',
      price: '₹7,200',
      tag: 'est.',
    ),
    MoverCompany(
      name: 'ReliCargo Services',
      rating: '4.5',
      reviews: '300+',
      coverage: 'NCR',
      price: '₹5,800',
      tag: 'est.',
    ),
  ],
);

final selectedHomeSizeProvider = StateProvider<String>((ref) => '3 BHK');
