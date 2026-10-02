import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/services/google_sign_in_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/auth/providers/basic_info_provider.dart';
import 'package:gharmb_app/features/auth/repo/auth_repo.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/legacy.dart';

class GoogleAuthState {
  final bool isLoading;
  final String? errorMessage;

  const GoogleAuthState({this.isLoading = false, this.errorMessage});

  GoogleAuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GoogleAuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GoogleAuthNotifier extends StateNotifier<GoogleAuthState> {
  final AuthRepo _authRepo;

  GoogleAuthNotifier({AuthRepo? authRepo})
    : _authRepo = authRepo ?? AuthRepo(),
      super(const GoogleAuthState());

  /// Handles complete Google Sign-In & Onboarding Flow
  Future<void> signInWithGoogle({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    debugPrint('🔵 [GoogleAuthNotifier] Starting Google Sign-In flow...');

    try {
      final googleResult = await GoogleSignInService.signIn();
      if (googleResult == null) {
        debugPrint('🟡 [GoogleAuthNotifier] User cancelled account selection');
        state = state.copyWith(isLoading: false);
        return;
      }

      debugPrint('🟢 [GoogleAuthNotifier] Google Sign-In SDK Success:');
      debugPrint('   - Email: ${googleResult.email}');
      debugPrint('   - Name: ${googleResult.name}');
      debugPrint('   - PhotoUrl: ${googleResult.photoUrl}');
      debugPrint(
        '   - Token: ${googleResult.token.isNotEmpty ? "${googleResult.token.substring(0, googleResult.token.length > 25 ? 25 : googleResult.token.length)}..." : "EMPTY"}',
      );

      debugPrint('🔵 [GoogleAuthNotifier] Calling Backend Google Login API...');
      final res = await _authRepo.googleLogin(
        token: googleResult.token,
        email: googleResult.email,
        name: googleResult.name,
        photoUrl: googleResult.photoUrl,
      );

      debugPrint('🟢 [GoogleAuthNotifier] Backend Response Received:');
      // debugPrint('   - Success: ${res.success}');
      debugPrint('   - Message: ${res.message}');
      debugPrint('   - Token: ${res.token != null ? "Present" : "Null"}');
      debugPrint('   - NextScreen: ${res.nextScreen}');
      debugPrint('   - NeedsBasicInfo: ${res.needsBasicInfo}');
      debugPrint('   - User Data: ${res.data?.user?.toJson()}');

      if (res.token != null && res.token!.isNotEmpty) {
        await LocalStorageService.saveAuthResponse(res);
      }

      state = state.copyWith(isLoading: false, clearError: true);

      if (!context.mounted) return;

      final user = res.data?.user;
      final bool needsBasicInfo =
          res.needsBasicInfo == true ||
          res.nextScreen == 'basic_info' ||
          (user?.phone == null || (user?.phone?.isEmpty ?? true)) ||
          user?.isBasicInfoCompleted == false;

      if (needsBasicInfo) {
        // Pre-fill user data into basic info provider
        ref
            .read(basicInfoProvider.notifier)
            .prefillFromGoogle(
              name: googleResult.name ?? user?.name ?? '',
              email: googleResult.email ?? user?.email ?? '',
              address: user?.address?.formattedAddress ?? '',
            );

        context.pushNamed(AppPage.basicInfoName);
      } else if (res.isOnboardingCompleted == true ||
          user?.isOnboardingCompleted == true ||
          res.nextScreen == 'home' ||
          res.nextScreen == 'dashboard') {
        context.pushReplacementNamed(AppPage.myHomeName);
      } else {
        context.pushNamed(AppPage.roleSelectionName);
      }
    } on AppException catch (e, stackTrace) {
      debugPrint('🔴 [GoogleAuthNotifier] AppException in Google Sign-In:');
      debugPrint('   - Error Type: ${e.runtimeType}');
      debugPrint('   - Message: ${e.message}');
      debugPrint('   - StackTrace: $stackTrace');

      state = state.copyWith(isLoading: false, errorMessage: e.message);
      if (context.mounted) {
        AppSnackBar.showError(context, message: e.message);
      }
    } catch (e, stackTrace) {
      debugPrint('🔴 [GoogleAuthNotifier] Unexpected error in Google Sign-In:');
      debugPrint('   - Error: $e');
      debugPrint('   - StackTrace: $stackTrace');

      // Silently ignore user cancellations
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('cancel') || errStr.contains('dismissed')) {
        state = state.copyWith(isLoading: false, clearError: true);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google sign-in failed: $e',
      );
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          message: 'Google sign-in failed. Please try again.',
        );
      }
    }
  }
}

final googleAuthProvider =
    StateNotifierProvider.autoDispose<GoogleAuthNotifier, GoogleAuthState>(
      (ref) => GoogleAuthNotifier(),
    );
