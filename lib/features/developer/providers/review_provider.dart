import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/features/developer/model/payload/review_payload.dart';
import 'package:gharmb_app/features/developer/repo/developer_repo.dart';

import 'detail_developer_provider.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class ReviewState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const ReviewState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ReviewState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class ReviewNotifier extends StateNotifier<ReviewState> {
  final DeveloperRepo _repo;

  ReviewNotifier(this._repo) : super(const ReviewState());

  Future<bool> submitReview({
    required String developerId,
    required ReviewPayload payload,
  }) async {
    // Reset state and show loading
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
    );

    try {
      final success = await _repo.addReviewDeveloper(
        developerId: developerId,
        payload: payload,
      );

      if (success) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Failed to submit review. Please try again.',
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

  // Reset state (e.g., after showing success message)
  void reset() {
    state = const ReviewState();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final reviewProvider = StateNotifierProvider<ReviewNotifier, ReviewState>((ref) {
  final repo = ref.watch(developerRepoProvider); // make sure this provider exists
  return ReviewNotifier(repo);
});