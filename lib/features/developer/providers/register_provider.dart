import 'package:flutter_riverpod/legacy.dart';

// ─── Registration Type ────────────────────────────────────────
enum RegistrationType { agent, developer }

// ─── Step 1 State ─────────────────────────────────────────────
class RegistrationStep1State {
  final RegistrationType type;
  final String companyName;
  final String reraNumber;
  final String gstNumber;
  final String yearsInBusiness;
  final String cityOfOperation;

  // Agent specific
  final String agentName;
  final String mobile;
  final String experience;

  const RegistrationStep1State({
    this.type = RegistrationType.developer,
    this.companyName = '',
    this.reraNumber = '',
    this.gstNumber = '',
    this.yearsInBusiness = '',
    this.cityOfOperation = '',
    this.agentName = '',
    this.mobile = '',
    this.experience = '',
  });

  RegistrationStep1State copyWith({
    RegistrationType? type,
    String? companyName,
    String? reraNumber,
    String? gstNumber,
    String? yearsInBusiness,
    String? cityOfOperation,
    String? agentName,
    String? mobile,
    String? experience,
  }) => RegistrationStep1State(
    type: type ?? this.type,
    companyName: companyName ?? this.companyName,
    reraNumber: reraNumber ?? this.reraNumber,
    gstNumber: gstNumber ?? this.gstNumber,
    yearsInBusiness: yearsInBusiness ?? this.yearsInBusiness,
    cityOfOperation: cityOfOperation ?? this.cityOfOperation,
    agentName: agentName ?? this.agentName,
    mobile: mobile ?? this.mobile,
    experience: experience ?? this.experience,
  );

  bool get isStep1Valid {
    if (type == RegistrationType.developer) {
      return companyName.isNotEmpty &&
          reraNumber.isNotEmpty &&
          cityOfOperation.isNotEmpty &&
          yearsInBusiness.isNotEmpty;
    } else {
      return agentName.isNotEmpty &&
          mobile.isNotEmpty &&
          reraNumber.isNotEmpty &&
          cityOfOperation.isNotEmpty;
    }
  }
}

class RegistrationStep1Notifier extends StateNotifier<RegistrationStep1State> {
  RegistrationStep1Notifier(RegistrationType type)
    : super(RegistrationStep1State(type: type));

  void setCompanyName(String v) => state = state.copyWith(companyName: v);
  void setReraNumber(String v) => state = state.copyWith(reraNumber: v);
  void setGstNumber(String v) => state = state.copyWith(gstNumber: v);
  void setYearsInBusiness(String v) =>
      state = state.copyWith(yearsInBusiness: v);
  void setCityOfOperation(String v) =>
      state = state.copyWith(cityOfOperation: v);
  void setAgentName(String v) => state = state.copyWith(agentName: v);
  void setMobile(String v) => state = state.copyWith(mobile: v);
  void setExperience(String v) => state = state.copyWith(experience: v);
}

// ─── Document keys ─────────────────────────────────────────────
// Stable identifiers shared between DocumentStatus, pickedFilesProvider,
// and uploadProvider(key) — this is what lets each document upload
// independently without index-based mismatches between developer/agent flows.
class DocumentKeys {
  static const reraCertificate = 'reraCertificate';
  static const panCard = 'panCard';
  static const companyLogo = 'companyLogo';
  static const aadhaarCard = 'aadhaarCard';
  static const profilePhoto = 'profilePhoto';
}

// ─── Step 2 State ─────────────────────────────────────────────
class DocumentStatus {
  final String key;
  final String name;
  final String subtitle;
  final bool isRequired;
  final bool isUploaded;

  const DocumentStatus({
    required this.key,
    required this.name,
    required this.subtitle,
    this.isRequired = true,
    this.isUploaded = false,
  });

  DocumentStatus copyWith({bool? isUploaded}) => DocumentStatus(
    key: key,
    name: name,
    subtitle: subtitle,
    isRequired: isRequired,
    isUploaded: isUploaded ?? this.isUploaded,
  );
}

class RegistrationStep2State {
  final List<DocumentStatus> documents;
  const RegistrationStep2State({required this.documents});

  bool get canSubmit =>
      documents.where((d) => d.isRequired).every((d) => d.isUploaded);

  DocumentStatus? byKey(String key) {
    for (final d in documents) {
      if (d.key == key) return d;
    }
    return null;
  }
}

class RegistrationStep2Notifier extends StateNotifier<RegistrationStep2State> {
  RegistrationStep2Notifier(RegistrationType type)
    : super(
        RegistrationStep2State(
          documents: type == RegistrationType.developer
              ? const [
                  DocumentStatus(
                    key: DocumentKeys.reraCertificate,
                    name: 'RERA certificate',
                    subtitle: 'PDF or image, max 5 MB',
                    isRequired: true,
                    isUploaded: false,
                  ),
                  DocumentStatus(
                    key: DocumentKeys.panCard,
                    name: 'PAN card',
                    subtitle: 'Company or proprietor PAN',
                    isRequired: true,
                    isUploaded: false,
                  ),
                  DocumentStatus(
                    key: DocumentKeys.companyLogo,
                    name: 'Company logo',
                    subtitle: 'PNG / JPG, shown on listings',
                    isRequired: false,
                    isUploaded: false,
                  ),
                ]
              : const [
                  DocumentStatus(
                    key: DocumentKeys.reraCertificate,
                    name: 'RERA certificate',
                    subtitle: 'PDF or image, max 5 MB',
                    isRequired: true,
                    isUploaded: false,
                  ),
                  DocumentStatus(
                    key: DocumentKeys.aadhaarCard,
                    name: 'Aadhaar card',
                    subtitle: 'Front & back, max 5 MB',
                    isRequired: true,
                    isUploaded: false,
                  ),
                  DocumentStatus(
                    key: DocumentKeys.profilePhoto,
                    name: 'Profile photo',
                    subtitle: 'PNG / JPG, shown on listings',
                    isRequired: false,
                    isUploaded: false,
                  ),
                ],
        ),
      );

  void toggleUpload(String key) {
    final updated = state.documents
        .map((d) => d.key == key ? d.copyWith(isUploaded: !d.isUploaded) : d)
        .toList();
    state = RegistrationStep2State(documents: updated);
  }

  /// Set upload status explicitly for a document, driven by real upload
  /// results rather than a manual UI toggle.
  void setUploaded(String key, bool uploaded) {
    final updated = state.documents
        .map((d) => d.key == key ? d.copyWith(isUploaded: uploaded) : d)
        .toList();
    state = RegistrationStep2State(documents: updated);
  }
}

// ─── Providers (developer) ────────────────────────────────────
final developerStep1Provider =
    StateNotifierProvider.autoDispose<
      RegistrationStep1Notifier,
      RegistrationStep1State
    >((ref) => RegistrationStep1Notifier(RegistrationType.developer));

final developerStep2Provider =
    StateNotifierProvider.autoDispose<
      RegistrationStep2Notifier,
      RegistrationStep2State
    >((ref) => RegistrationStep2Notifier(RegistrationType.developer));

// ─── Providers (agent) ────────────────────────────────────────
final agentStep1Provider =
    StateNotifierProvider.autoDispose<
      RegistrationStep1Notifier,
      RegistrationStep1State
    >((ref) => RegistrationStep1Notifier(RegistrationType.agent));

final agentStep2Provider =
    StateNotifierProvider.autoDispose<
      RegistrationStep2Notifier,
      RegistrationStep2State
    >((ref) => RegistrationStep2Notifier(RegistrationType.agent));

// ─── Year options ─────────────────────────────────────────────
const developerYearOptions = ['< 2 yrs', '2–5 yrs', '5–10 yrs', '10+ yrs'];
const agentExperienceOptions = ['< 1 yr', '1–3 yrs', '3–5 yrs', '5+ yrs'];

// ─── Per-document file state ──────────────────────────────────
class FileInfo {
  final String path;
  final String name;
  final int sizeBytes;
  const FileInfo({
    required this.path,
    required this.name,
    required this.sizeBytes,
  });
}

// ─── Provider for picked files (key → FileInfo) ────────────────
// Keyed by DocumentKeys.* instead of a list index, matching uploadProvider.
final pickedFilesProvider = StateProvider<Map<String, FileInfo>>((ref) => {});
