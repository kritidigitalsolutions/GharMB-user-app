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

  Future<void> sendOtp({
    required void Function(String? otp) onSuccess,
    void Function(String message)? onAccountNotFound,
    void Function(String message)? onSuspended,
  }) async {
    final cleanPhone = state.phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length != 10) {
      state = state.copyWith(
        errorMessage: 'Please enter a valid 10-digit mobile number',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final res = await _authRepo.login(cleanPhone);

      if (res is Map && res["accountNotFound"] == true) {
        state = state.copyWith(isLoading: false, clearError: true);
        if (onAccountNotFound != null) {
          onAccountNotFound(
            res["message"]?.toString() ?? 'Please create a new account.',
          );
        }
        return;
      }

      final String? otp = res is Map
          ? (res["otp"]?.toString() ??
                (res["data"] is Map ? res["data"]["otp"]?.toString() : null))
          : null;

      state = state.copyWith(isLoading: false, clearError: true);
      onSuccess(otp);
    } on NotFoundException catch (e) {
      state = state.copyWith(isLoading: false, clearError: true);
      if (onAccountNotFound != null) {
        onAccountNotFound(e.message);
      } else {
        state = state.copyWith(errorMessage: e.message);
      }
    } on ForbiddenException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      if (onSuspended != null) {
        onSuspended(e.message);
      }
    } on AppException catch (e) {
      if (e.data is Map && e.data['accountNotFound'] == true) {
        state = state.copyWith(isLoading: false, clearError: true);
        if (onAccountNotFound != null) {
          onAccountNotFound(e.message);
          return;
        }
      }
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
