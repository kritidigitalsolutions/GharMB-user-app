import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';

import 'package:gharmb_app/features/auth/models/request/upload_request.dart';
import 'package:gharmb_app/features/auth/models/response/file_upload_model.dart';
import 'package:gharmb_app/features/auth/repo/auth_repo.dart';
import 'package:riverpod/legacy.dart';

enum UploadStatus { idle, uploading, success, error }

class UploadState {
  final UploadStatus status;
  final double progress; // 0.0 to 1.0
  final UploadResponse? response;
  final String? errorMessage;

  const UploadState({
    this.status = UploadStatus.idle,
    this.progress = 0,
    this.response,
    this.errorMessage,
  });

  bool get isUploading => status == UploadStatus.uploading;
  bool get isSuccess => status == UploadStatus.success;
  bool get isError => status == UploadStatus.error;

  UploadState copyWith({
    UploadStatus? status,
    double? progress,
    UploadResponse? response,
    String? errorMessage,
  }) {
    return UploadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      response: response ?? this.response,
      errorMessage: errorMessage,
    );
  }
}

// ─── Repo Provider ─────────────────────────────────────────────
final uploadRepoProvider = Provider<AuthRepo>((ref) => AuthRepo());

// ─── Upload Notifier ─────────────────────────────────────────────
class UploadNotifier extends StateNotifier<UploadState> {
  final AuthRepo _repo;

  UploadNotifier(this._repo) : super(const UploadState());

  Future<void> upload(FileUploadRequest request) async {
    state = state.copyWith(
      status: UploadStatus.uploading,
      progress: 0,
      errorMessage: null,
    );

    try {
      final response = await _repo.uploadFile(
        uploadRequest: request,
        onSendProgress: (sent, total) {
          if (total <= 0) return;
          state = state.copyWith(progress: sent / total);
        },
      );

      if (response == null) {
        state = state.copyWith(
          status: UploadStatus.error,
          errorMessage: 'Upload failed. Please try again.',
        );
        return;
      }

      state = state.copyWith(
        status: UploadStatus.success,
        progress: 1,
        response: response,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: UploadStatus.error,
        errorMessage: e.toString(),
      );
    } catch (e) {
      state = state.copyWith(
        status: UploadStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void reset() {
    state = const UploadState();
  }
}

// ─── Main Provider ──────────────────────────────────────────────
final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((
  ref,
) {
  final repo = ref.watch(uploadRepoProvider);
  return UploadNotifier(repo);
});
