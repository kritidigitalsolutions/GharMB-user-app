import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class LoginState {
  final String phone;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.phone = '',
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    String? phone,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isValid => phone.trim().length == 10;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  void setPhone(String value) {
    state = state.copyWith(
      phone: value.replaceAll(RegExp(r'\D'), ''),
      clearError: true,
    );
  }

  Future<void> sendOtp({required VoidCallback onSuccess}) async {
    if (!state.isValid) return;

    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1)); // Replace with API call

    state = state.copyWith(isLoading: false);
    onSuccess();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(),
    );
