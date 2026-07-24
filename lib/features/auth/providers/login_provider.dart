import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/features/auth/repo/auth_repo.dart';

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
  final AuthRepo _authRepo = AuthRepo();

  void setPhone(String value) {
    state = state.copyWith(
      phone: value.replaceAll(RegExp(r'\D'), ''),
      clearError: true,
    );
  }

  Future<void> sendOtp({required VoidCallback onSuccess}) async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Please fill the phone number');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _authRepo.login(state.phone.trim());
      state = state.copyWith(isLoading: false, clearError: true);
      onSuccess();
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(),
    );
