import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/auth/repo/auth_repo.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class OtpState {
  final List<String> digits;
  final bool isVerified;
  final bool hasError;
  final String? errorMessage;
  final bool isLoading;
  final bool isResending;
  final int resendCountdown; // seconds remaining

  const OtpState({
    this.digits = const ['', '', '', '', '', ''],
    this.isVerified = false,
    this.hasError = false,
    this.errorMessage,
    this.isLoading = false,
    this.isResending = false,
    this.resendCountdown = 30,
  });

  OtpState copyWith({
    List<String>? digits,
    bool? isVerified,
    bool? hasError,
    String? errorMessage,
    bool? isLoading,
    bool? isResending,
    int? resendCountdown,
    bool clearError = false,
  }) {
    return OtpState(
      digits: digits ?? this.digits,
      isVerified: isVerified ?? this.isVerified,
      hasError: clearError ? false : (hasError ?? this.hasError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
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
  final String phone;
  final AuthRepo _authRepo;
  Timer? _timer;

  OtpNotifier(this.phone, {AuthRepo? authRepo})
    : _authRepo = authRepo ?? AuthRepo(),
      super(const OtpState()) {
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
      isVerified: false,
      clearError: true,
    );
  }

  Future<void> verify(VoidCallback onSuccess) async {
    if (!state.isFilled) return;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final res = await _authRepo.verifyOTP(phone, state.otpCode);
      if (res.status == "success") {
        await LocalStorageService.saveAuthResponse(res);
      }
      state = state.copyWith(isLoading: false, isVerified: true);
      onSuccess();
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> resend() async {
    if (state.resendCountdown > 0) return;

    state = state.copyWith(isResending: true, clearError: true);
    try {
      await _authRepo.login(phone); // login API OTP trigger karta hai
      state = state.copyWith(
        isResending: false,
        digits: const ['', '', '', '', '', ''],
        isVerified: false,
      );
      _startCountdown();
    } on AppException catch (e) {
      state = state.copyWith(
        isResending: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isResending: false,
        hasError: true,
        errorMessage: 'Could not resend OTP. Please try again.',
      );
    }
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

// Route ke through phone number set hoga is provider ke through
final otpPhoneProvider = StateProvider<String>((ref) => '');

final otpProvider = StateNotifierProvider.autoDispose<OtpNotifier, OtpState>((
  ref,
) {
  final phone = ref.watch(otpPhoneProvider);
  return OtpNotifier(phone);
});
