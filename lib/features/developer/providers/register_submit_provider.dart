import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/data/network/base_api_service.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/auth/models/request/upload_request.dart';
import 'package:gharmb_app/features/auth/providers/upload_provider.dart';
import 'package:gharmb_app/features/developer/model/payload/agent_register_payload.dart';
import 'package:gharmb_app/features/developer/model/payload/developer_register_payload.dart';
import 'package:gharmb_app/features/developer/model/response/agent_response.dart';
import 'package:gharmb_app/features/developer/model/response/developer_register_response.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/features/developer/repo/developer_repo.dart';
import 'package:riverpod/legacy.dart';

// ─── Repo provider ───────────────────────────────────────────────
// TODO: if you already have a shared provider for NetworkApiService
// elsewhere in the app, watch that one instead of constructing a new
// instance here so auth interceptors / base URL config stay consistent.
final developerRepoProvider = Provider<DeveloperRepo>((ref) {
  return DeveloperRepo(networkApiService: NetworkApiService());
});

// ─── Submit state ─────────────────────────────────────────────────
class RegistrationSubmitState {
  final bool isUploadingFiles;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final DeveloperRegistrationResponse? developerResponse;
  final AgentRegistrationResponse? agentResponse;

  const RegistrationSubmitState({
    this.isUploadingFiles = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.developerResponse,
    this.agentResponse,
  });

  bool get isBusy => isUploadingFiles || isSubmitting;

  RegistrationSubmitState copyWith({
    bool? isUploadingFiles,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    DeveloperRegistrationResponse? developerResponse,
    AgentRegistrationResponse? agentResponse,
  }) {
    return RegistrationSubmitState(
      isUploadingFiles: isUploadingFiles ?? this.isUploadingFiles,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      developerResponse: developerResponse ?? this.developerResponse,
      agentResponse: agentResponse ?? this.agentResponse,
    );
  }
}

// ─── Notifier ───────────────────────────────────────────────────
class RegistrationSubmitNotifier
    extends StateNotifier<RegistrationSubmitState> {
  final Ref ref;
  final RegistrationType type;
  final DeveloperRepo _repo;

  RegistrationSubmitNotifier(this.ref, this.type, this._repo)
    : super(const RegistrationSubmitState());

  Future<bool> submit() async {
    state = const RegistrationSubmitState().copyWith(isUploadingFiles: true);

    final step1 = type == RegistrationType.developer
        ? ref.read(developerStep1Provider)
        : ref.read(agentStep1Provider);
    final step2Notifier = ref.read(
      (type == RegistrationType.developer
              ? developerStep2Provider
              : agentStep2Provider)
          .notifier,
    );
    final step2 = type == RegistrationType.developer
        ? ref.read(developerStep2Provider)
        : ref.read(agentStep2Provider);
    final pickedFiles = ref.read(pickedFilesProvider);

    if (!step1.isStep1Valid) {
      state = state.copyWith(
        isUploadingFiles: false,
        errorMessage: 'Please complete all required fields.',
      );
      return false;
    }

    // ── 1. Upload every picked document, one at a time ──────────────
    final Map<String, String> uploadedUrls = {};

    for (final doc in step2.documents) {
      final file = pickedFiles[doc.key];

      if (file == null) {
        if (doc.isRequired) {
          state = state.copyWith(
            isUploadingFiles: false,
            errorMessage: '${doc.name} is required.',
          );
          return false;
        }
        continue; // optional and not picked — skip
      }

      final notifier = ref.read(uploadProvider.notifier);

      // TODO: MultipartFileData's constructor isn't available to me — adjust
      // the field name(s) below (e.g. `field`, `filePath`) to match your
      // actual class. This assumes a shape like:
      //   MultipartFileData({required String field, required String filePath})
      await notifier.upload(
        FileUploadRequest(
          files: [MultipartFileData(fieldName: file.name, filePath: file.path)],
        ),
      );

      final uploadState = ref.read(uploadProvider);

      if (!uploadState.isSuccess ||
          uploadState.response == null ||
          uploadState.response!.data.fileUrls.isEmpty) {
        state = state.copyWith(
          isUploadingFiles: false,
          errorMessage:
              uploadState.errorMessage ?? 'Failed to upload ${doc.name}.',
        );
        return false;
      }

      uploadedUrls[doc.key] = uploadState.response!.data.fileUrls.first;
      step2Notifier.setUploaded(doc.key, true);
    }

    state = state.copyWith(isUploadingFiles: false, isSubmitting: true);

    // ── 2. Build the payload and call the repo ───────────────────────
    if (type == RegistrationType.developer) {
      final payload = DeveloperRegistrationPayload(
        companyName: step1.companyName,
        reraNumber: step1.reraNumber,
        gstNumber: step1.gstNumber,
        yearsInBusiness: step1.yearsInBusiness,
        cityOfOperation: step1.cityOfOperation,
        reraCertificate: uploadedUrls[DocumentKeys.reraCertificate] ?? '',
        panCard: uploadedUrls[DocumentKeys.panCard] ?? '',
        companyLogo: uploadedUrls[DocumentKeys.companyLogo] ?? '',
      );

      final res = await _repo.registerDeveloper(payload: payload);
      if (res == null) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        );
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        developerResponse: res,
      );
      return true;
    } else {
      final payload = AgentRegistrationPayload(
        name: step1.agentName,
        phone: step1.mobile,
        reraNumber: step1.reraNumber,
        experience: step1.experience,
        cityOfOperation: step1.cityOfOperation,
        reraCertificate: uploadedUrls[DocumentKeys.reraCertificate] ?? '',
        aadhaarCard: uploadedUrls[DocumentKeys.aadhaarCard] ?? '',
        profilePhoto: uploadedUrls[DocumentKeys.profilePhoto] ?? '',
      );

      final res = await _repo.registerAgent(payload: payload);
      if (res == null) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        );
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        agentResponse: res,
      );
      return true;
    }
  }

  void reset() => state = const RegistrationSubmitState();
}

// ─── Provider (family keyed by RegistrationType) ─────────────────
final registrationSubmitProvider = StateNotifierProvider.autoDispose
    .family<
      RegistrationSubmitNotifier,
      RegistrationSubmitState,
      RegistrationType
    >((ref, type) {
      final repo = ref.watch(developerRepoProvider);
      return RegistrationSubmitNotifier(ref, type, repo);
    });
