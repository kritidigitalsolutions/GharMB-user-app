// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class OtpState {
  final List<String> digits;
  final bool isVerified;
  final bool hasError;
  final bool isLoading;
  final int resendCountdown; // seconds remaining

  const OtpState({
    this.digits = const ['', '', '', '', '', ''],
    this.isVerified = false,
    this.hasError = false,
    this.isLoading = false,
    this.resendCountdown = 30,
  });

  OtpState copyWith({
    List<String>? digits,
    bool? isVerified,
    bool? hasError,
    bool? isLoading,
    int? resendCountdown,
  }) {
    return OtpState(
      digits: digits ?? this.digits,
      isVerified: isVerified ?? this.isVerified,
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
      resendCountdown: resendCountdown ?? this.resendCountdown,
    );
  }

  bool get isFilled => digits.every((d) => d.isNotEmpty);
  String get otpCode => digits.join();
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class OtpNotifier extends StateNotifier<OtpState> {
  Timer? _timer;

  OtpNotifier() : super(const OtpState()) {
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    state = state.copyWith(resendCountdown: 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.resendCountdown <= 1) {
        t.cancel();
        state = state.copyWith(resendCountdown: 0);
      } else {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      }
    });
  }

  void setDigit(int index, String value) {
    final newDigits = List<String>.from(state.digits);
    newDigits[index] = value;
    state = state.copyWith(
      digits: newDigits,
      hasError: false,
      isVerified: false,
    );
  }

  Future<void> verify(VoidCallback onSuccess) async {
    if (!state.isFilled) return;
    state = state.copyWith(isLoading: true, hasError: false);
    await Future.delayed(const Duration(seconds: 1));

    // Simulate success for demo (code == '2222')
    if (state.otpCode.length == 6) {
      state = state.copyWith(isLoading: false, isVerified: true);
      onSuccess();
    } else {
      state = state.copyWith(isLoading: false, hasError: true);
    }
  }

  Future<void> resend() async {
    if (state.resendCountdown > 0) return;
    state = state.copyWith(
      digits: const ['', '', '', '', '', ''],
      hasError: false,
      isVerified: false,
    );
    _startCountdown();
    // Trigger resend OTP API
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final otpProvider = StateNotifierProvider.autoDispose<OtpNotifier, OtpState>(
  (ref) => OtpNotifier(),
);

// You'd pass phone number via route arguments; using a simple provider here
final otpPhoneProvider = StateProvider<String>((ref) => '+91 98765 43210');
