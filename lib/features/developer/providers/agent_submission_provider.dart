// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod/legacy.dart';

// import 'package:gharmb_app/core/data/exception/app_exception.dart';
// import 'package:gharmb_app/core/data/network/base_api_service.dart';
// import 'package:gharmb_app/core/data/network/network_api_service.dart';
// import 'package:gharmb_app/features/auth/models/request/upload_request.dart';
// import 'package:gharmb_app/features/auth/repo/auth_repo.dart';
// import 'package:gharmb_app/features/developer/model/payload/agent_register_payload.dart';
// import 'package:gharmb_app/features/developer/model/response/agent_response.dart';
// import 'package:gharmb_app/features/developer/providers/register_provider.dart';
// import 'package:gharmb_app/features/developer/repo/developer_repo.dart';

// enum AgentSubmissionStatus { idle, uploadingDocs, submitting, success, error }

// class AgentSubmissionState {
//   final AgentSubmissionStatus status;
//   final double uploadProgress; // 0.0–1.0, averaged across docs being sent
//   final AgentRegistrationResponse? response;
//   final String? errorMessage;

//   const AgentSubmissionState({
//     this.status = AgentSubmissionStatus.idle,
//     this.uploadProgress = 0,
//     this.response,
//     this.errorMessage,
//   });

//   bool get isBusy =>
//       status == AgentSubmissionStatus.uploadingDocs ||
//       status == AgentSubmissionStatus.submitting;
//   bool get isSuccess => status == AgentSubmissionStatus.success;
//   bool get isError => status == AgentSubmissionStatus.error;

//   AgentSubmissionState copyWith({
//     AgentSubmissionStatus? status,
//     double? uploadProgress,
//     AgentRegistrationResponse? response,
//     String? errorMessage,
//   }) {
//     return AgentSubmissionState(
//       status: status ?? this.status,
//       uploadProgress: uploadProgress ?? this.uploadProgress,
//       response: response ?? this.response,
//       errorMessage: errorMessage,
//     );
//   }
// }

// // ─── Repo Providers ──────────────────────────────────────────────
// final _networkApiServiceProvider = Provider<NetworkApiService>(
//   (ref) => NetworkApiService(),
// );

// final developerRepoProvider = Provider<DeveloperRepo>(
//   (ref) => DeveloperRepo(
//     networkApiService: ref.watch(_networkApiServiceProvider),
//   ),
// );

// final _uploadRepoProvider = Provider<AuthRepo>((ref) => AuthRepo());

// // ─── Document index constants (must match agentStep2Provider's order:
// // RERA certificate → 0, Aadhaar card → 1, Profile photo → 2) ─────────
// const int kReraCertIndex = 0;
// const int kAadharCardIndex = 1;
// const int kProfilePhotoIndex = 2;

// // ─── Notifier ────────────────────────────────────────────────────
// class AgentSubmissionNotifier extends StateNotifier<AgentSubmissionState> {
//   final AuthRepo _uploadRepo;
//   final DeveloperRepo _developerRepo;

//   AgentSubmissionNotifier(this._uploadRepo, this._developerRepo)
//     : super(const AgentSubmissionState());

//   /// Uploads RERA certificate / Aadhaar card / profile photo (whichever
//   /// are present in [pickedFiles]) then submits agent registration using
//   /// [step1] details. Returns true on success.
//   Future<bool> submit({
//     required RegistrationStep1State step1,
//     required Map<int, FileInfo> pickedFiles,
//   }) async {
//     state = state.copyWith(
//       status: AgentSubmissionStatus.uploadingDocs,
//       uploadProgress: 0,
//       errorMessage: null,
//     );

//     String? reraCertUrl;
//     String? aadharCardUrl;
//     String? profilePhotoUrl;

//     try {
//       final totalToUpload = pickedFiles.length;
//       var uploadedCount = 0;

//       Future<String?> uploadIfPresent(int index, String fieldName) async {
//         final fileInfo = pickedFiles[index];
//         if (fileInfo == null) return null;

//         final request = FileUploadRequest(
//           fields: {"type": fieldName},
//           files: [
//             MultipartFileData(
//               fieldName: fieldName,
//               filePath: fileInfo.path,
//               fileName: fileInfo.name,
//             ),
//           ],
//         );

//         final response = await _uploadRepo.uploadFile(
//           uploadRequest: request,
//           onSendProgress: (sent, total) {
//             if (total <= 0 || totalToUpload == 0) return;
//             // Rough combined progress across however many docs are queued.
//             final partial = sent / total;
//             state = state.copyWith(
//               uploadProgress: (uploadedCount + partial) / totalToUpload,
//             );
//           },
//         );

//         uploadedCount++;
//         state = state.copyWith(uploadProgress: uploadedCount / totalToUpload);

//         final urls = response?.data.fileUrls ?? [];
//         return urls.isNotEmpty ? urls.first : null;
//       }

//       reraCertUrl = await uploadIfPresent(kReraCertIndex, "reraCertificate");
//       aadharCardUrl = await uploadIfPresent(kAadharCardIndex, "aadharCard");
//       profilePhotoUrl = await uploadIfPresent(
//         kProfilePhotoIndex,
//         "profilePhoto",
//       );
//     } on AppException catch (e) {
//       state = state.copyWith(
//         status: AgentSubmissionStatus.error,
//         errorMessage: e.message,
//       );
//       return false;
//     } catch (e) {
//       state = state.copyWith(
//         status: AgentSubmissionStatus.error,
//         errorMessage: 'Document upload failed. Please try again.',
//       );
//       return false;
//     }

//     state = state.copyWith(status: AgentSubmissionStatus.submitting);

//     try {
//       // ── ASSUMPTION: AgentRegistrationPayload's constructor field names.
//       // Rename these named params to match your actual payload model if
//       // different — the *values* passed in are correct regardless.
//       final payload = AgentRegistrationPayload(
       
//         reraNumber: step1.reraNumber,
//         cityOfOperation: step1.cityOfOperation,
//         experience: step1.experience,
//         reraCertificate: reraCertUrl,
//         aadhaarCard: aadharCardUrl,
//         profilePhotoUrl: profilePhotoUrl, reraCertificate: '', aadhaarCard: '', profilePhoto: '',
//       );

//       final response = await _developerRepo.registerAgent(payload: payload);

//       if (response == null) {
//         state = state.copyWith(
//           status: AgentSubmissionStatus.error,
//           errorMessage: 'Registration failed. Please try again.',
//         );
//         return false;
//       }

//       state = state.copyWith(
//         status: AgentSubmissionStatus.success,
//         response: response,
//       );
//       return true;
//     } on AppException catch (e) {
//       state = state.copyWith(
//         status: AgentSubmissionStatus.error,
//         errorMessage: e.message,
//       );
//       return false;
//     } catch (e) {
//       state = state.copyWith(
//         status: AgentSubmissionStatus.error,
//         errorMessage: 'Something went wrong. Please try again.',
//       );
//       return false;
//     }
//   }

//   void reset() {
//     state = const AgentSubmissionState();
//   }
// }

// final agentSubmissionProvider =
//     StateNotifierProvider<AgentSubmissionNotifier, AgentSubmissionState>((
//       ref,
//     ) {
//       final uploadRepo = ref.watch(_uploadRepoProvider);
//       final developerRepo = ref.watch(developerRepoProvider);
//       return AgentSubmissionNotifier(uploadRepo, developerRepo);
//     });