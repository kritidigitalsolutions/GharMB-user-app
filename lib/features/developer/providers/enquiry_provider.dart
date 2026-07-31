// enquiry_provider.dart (or add to your existing provider file)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/features/developer/repo/developer_repo.dart';

import 'detail_developer_provider.dart';

// ---------------------------------------------------------------------------
// Enquiry State
// ---------------------------------------------------------------------------
class EnquiryState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const EnquiryState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  EnquiryState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EnquiryState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ---------------------------------------------------------------------------
// Enquiry Notifier
// ---------------------------------------------------------------------------
class EnquiryNotifier extends StateNotifier<EnquiryState> {
  final DeveloperRepo _repo;

  EnquiryNotifier(this._repo) : super(const EnquiryState());

  Future<bool> submitEnquiry({
    required String developerId,
    required String message,
  }) async {
    // Reset state, show loading
    state = state.copyWith(isLoading: true, isSuccess: false, clearError: true);

    try {
      final success = await _repo.submitEnquiry(
        developerId: developerId,
        message: message,
      );

      if (success) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Failed to submit enquiry. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: 'An error occurred: $e',
      );
      return false;
    }
  }

  // Reset the state (e.g., after showing a success message)
  void reset() {
    state = const EnquiryState();
  }
}

// ---------------------------------------------------------------------------
// Enquiry Provider
// ---------------------------------------------------------------------------
final enquiryProvider = StateNotifierProvider<EnquiryNotifier, EnquiryState>((ref) {
  final repo = ref.watch(developerRepoProvider);
  return EnquiryNotifier(repo);
});