// ─── State ────────────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/legacy.dart';

class BookingFormState {
  // Personal
  final String fullName;
  final String mobile;
  final String email;
  final String city;

  // Family
  final String familyMembers;
  final String adults;
  final String children;
  final String maritalStatus;

  // Occupation
  final String profession;
  final String company;
  final String monthlyIncome;

  // Document
  final String? uploadedFileName;

  // Token
  final int selectedToken; // 2000 or 5000

  const BookingFormState({
    this.fullName = '',
    this.mobile = '',
    this.email = '',
    this.city = '',
    this.familyMembers = '',
    this.adults = '',
    this.children = '',
    this.maritalStatus = '',
    this.profession = '',
    this.company = '',
    this.monthlyIncome = '',
    this.uploadedFileName,
    this.selectedToken = 5000,
  });

  BookingFormState copyWith({
    String? fullName,
    String? mobile,
    String? email,
    String? city,
    String? familyMembers,
    String? adults,
    String? children,
    String? maritalStatus,
    String? profession,
    String? company,
    String? monthlyIncome,
    String? uploadedFileName,
    int? selectedToken,
  }) {
    return BookingFormState(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      city: city ?? this.city,
      familyMembers: familyMembers ?? this.familyMembers,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      profession: profession ?? this.profession,
      company: company ?? this.company,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      uploadedFileName: uploadedFileName ?? this.uploadedFileName,
      selectedToken: selectedToken ?? this.selectedToken,
    );
  }
}

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  BookingFormNotifier() : super(const BookingFormState());

  void update({
    String? fullName,
    String? mobile,
    String? email,
    String? city,
    String? familyMembers,
    String? adults,
    String? children,
    String? maritalStatus,
    String? profession,
    String? company,
    String? monthlyIncome,
    String? uploadedFileName,
    int? selectedToken,
  }) {
    state = state.copyWith(
      fullName: fullName,
      mobile: mobile,
      email: email,
      city: city,
      familyMembers: familyMembers,
      adults: adults,
      children: children,
      maritalStatus: maritalStatus,
      profession: profession,
      company: company,
      monthlyIncome: monthlyIncome,
      uploadedFileName: uploadedFileName,
      selectedToken: selectedToken,
    );
  }
}

final bookingFormProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>(
      (_) => BookingFormNotifier(),
    );

// ─── Dropdown options ─────────────────────────────────────────────────────────
