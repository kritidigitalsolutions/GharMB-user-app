import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:gharmb_app/features/property/models/token_booking_model.dart';
import 'package:gharmb_app/features/property/repo/token_booking_repo.dart';

// ─── Repo Provider ─────────────────────────────────────────────
final tokenBookingRepoProvider = Provider<TokenBookingRepo>((ref) {
  return TokenBookingRepo();
});

// ─── Token Config FutureProvider ───────────────────────────────
final tokenConfigProvider =
    FutureProvider.family<TokenConfigModel?, String>((ref, propertyId) async {
  if (propertyId.isEmpty) return null;
  final repo = ref.read(tokenBookingRepoProvider);
  return repo.getTokenConfig(propertyId);
});

// ─── Booking Form State ────────────────────────────────────────

class BookingFormState {
  // Personal
  final String fullName;
  final String mobile;
  final String email;
  final String city;

  // Family
  final String familyMembers;
  final String adults;
  final String children;
  final String maritalStatus;

  // Occupation
  final String profession;
  final String company;
  final String monthlyIncome;

  // Document (ID Proof)
  final String idProofType;
  final String? uploadedFileName;
  final String? uploadedDocumentUrl;
  final File? selectedFile;
  final bool isUploadingDoc;

  // Token
  final int selectedToken;

  // Submission Status
  final bool isSubmitting;
  final String? errorMessage;
  final TokenRequestItem? bookingResult;

  const BookingFormState({
    this.fullName = '',
    this.mobile = '',
    this.email = '',
    this.city = '',
    this.familyMembers = '1',
    this.adults = '1',
    this.children = '0',
    this.maritalStatus = 'Single',
    this.profession = 'Salaried',
    this.company = '',
    this.monthlyIncome = '₹50,000 – ₹1,00,000',
    this.idProofType = 'Aadhaar',
    this.uploadedFileName,
    this.uploadedDocumentUrl,
    this.selectedFile,
    this.isUploadingDoc = false,
    this.selectedToken = 2000,
    this.isSubmitting = false,
    this.errorMessage,
    this.bookingResult,
  });

  BookingFormState copyWith({
    String? fullName,
    String? mobile,
    String? email,
    String? city,
    String? familyMembers,
    String? adults,
    String? children,
    String? maritalStatus,
    String? profession,
    String? company,
    String? monthlyIncome,
    String? idProofType,
    String? uploadedFileName,
    String? uploadedDocumentUrl,
    File? selectedFile,
    bool? isUploadingDoc,
    int? selectedToken,
    bool? isSubmitting,
    String? errorMessage,
    TokenRequestItem? bookingResult,
    bool clearError = false,
  }) {
    return BookingFormState(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      city: city ?? this.city,
      familyMembers: familyMembers ?? this.familyMembers,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      profession: profession ?? this.profession,
      company: company ?? this.company,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      idProofType: idProofType ?? this.idProofType,
      uploadedFileName: uploadedFileName ?? this.uploadedFileName,
      uploadedDocumentUrl: uploadedDocumentUrl ?? this.uploadedDocumentUrl,
      selectedFile: selectedFile ?? this.selectedFile,
      isUploadingDoc: isUploadingDoc ?? this.isUploadingDoc,
      selectedToken: selectedToken ?? this.selectedToken,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      bookingResult: bookingResult ?? this.bookingResult,
    );
  }
}

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  final TokenBookingRepo _repo;

  BookingFormNotifier(this._repo) : super(const BookingFormState());

  void initializeWithDefaults({
    String? name,
    String? phone,
    String? email,
    String? city,
    int? defaultToken,
  }) {
    state = state.copyWith(
      fullName: name?.isNotEmpty == true ? name : state.fullName,
      mobile: phone?.isNotEmpty == true ? phone : state.mobile,
      email: email?.isNotEmpty == true ? email : state.email,
      city: city?.isNotEmpty == true ? city : state.city,
      selectedToken: defaultToken ?? state.selectedToken,
    );
  }

  void update({
    String? fullName,
    String? mobile,
    String? email,
    String? city,
    String? familyMembers,
    String? adults,
    String? children,
    String? maritalStatus,
    String? profession,
    String? company,
    String? monthlyIncome,
    String? idProofType,
    String? uploadedFileName,
    String? uploadedDocumentUrl,
    File? selectedFile,
    int? selectedToken,
  }) {
    state = state.copyWith(
      fullName: fullName,
      mobile: mobile,
      email: email,
      city: city,
      familyMembers: familyMembers,
      adults: adults,
      children: children,
      maritalStatus: maritalStatus,
      profession: profession,
      company: company,
      monthlyIncome: monthlyIncome,
      idProofType: idProofType,
      uploadedFileName: uploadedFileName,
      uploadedDocumentUrl: uploadedDocumentUrl,
      selectedFile: selectedFile,
      selectedToken: selectedToken,
      clearError: true,
    );
  }

  Future<bool> uploadDocument(File file) async {
    state = state.copyWith(
      isUploadingDoc: true,
      selectedFile: file,
      uploadedFileName: file.path.split('/').last,
      clearError: true,
    );

    final url = await _repo.uploadIdProof(file);
    if (url != null) {
      state = state.copyWith(
        isUploadingDoc: false,
        uploadedDocumentUrl: url,
      );
      return true;
    } else {
      state = state.copyWith(
        isUploadingDoc: false,
        errorMessage: 'Failed to upload ID proof. Please retry.',
      );
      return false;
    }
  }

  Future<TokenRequestItem?> submitBooking({
    required String propertyId,
    required int monthlyRent,
    String? priceLabel,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      // If file was selected but not uploaded yet, try uploading first
      String docUrl = state.uploadedDocumentUrl ?? '';
      String docName = state.uploadedFileName ?? 'id_proof.pdf';

      if (docUrl.isEmpty && state.selectedFile != null) {
        final uploaded = await _repo.uploadIdProof(state.selectedFile!);
        if (uploaded != null) {
          docUrl = uploaded;
        }
      }

      final submission = TokenBookingSubmissionRequest(
        propertyId: propertyId,
        personalDetails: {
          'fullName': state.fullName.trim(),
          'mobileNumber': state.mobile.trim(),
          'email': state.email.trim(),
          'currentCity': state.city.trim(),
        },
        familyDetails: {
          'numberOfFamilyMembers': state.familyMembers,
          'adults': state.adults,
          'children': state.children,
          'maritalStatus': state.maritalStatus,
        },
        occupationDetails: {
          'profession': state.profession,
          'companyName': state.company.trim(),
          'monthlyIncome': state.monthlyIncome,
        },
        idProof: {
          'idProofType': state.idProofType,
          'documentUrl': docUrl.isNotEmpty ? docUrl : '/uploads/documents/$docName',
          'documentOriginalName': docName,
        },
        tokenAmount: state.selectedToken,
        monthlyRent: monthlyRent,
        totalAgreedPrice: priceLabel ?? '₹$monthlyRent',
        paymentMethod: 'upi',
        transactionId: 'UPI_${DateTime.now().millisecondsSinceEpoch}',
      );

      final response = await _repo.submitTokenBooking(submission);

      if (response != null) {
        final item = response.tokenRequest ??
            TokenRequestItem(
              id: propertyId,
              tokenRequestId: '#TKN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              propertyId: propertyId,
              tokenAmount: state.selectedToken,
              status: 'pending',
              escrowStatus: 'Escrow Held',
              paymentStatus: 'paid',
              paymentMethod: 'upi',
              utrRef: 'UPI_${DateTime.now().millisecondsSinceEpoch}',
              createdAt: DateTime.now(),
            );

        state = state.copyWith(
          isSubmitting: false,
          bookingResult: item,
        );
        return item;
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to submit token booking. Please try again.',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception:', '').trim(),
      );
      return null;
    }
  }

  void reset() {
    state = const BookingFormState();
  }
}

final bookingFormProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>((ref) {
  final repo = ref.watch(tokenBookingRepoProvider);
  return BookingFormNotifier(repo);
});

// ─── My Token Requests Provider (Buyer dashboard) ─────────────
final myTokenRequestsProvider =
    FutureProvider.autoDispose<List<TokenRequestItem>>((ref) async {
  final repo = ref.watch(tokenBookingRepoProvider);
  return repo.getMyTokenRequests();
});
