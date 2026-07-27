import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/models/about_us_response.dart';
import 'package:gharmb_app/features/profile/models/help_response_model.dart';
import 'package:gharmb_app/features/profile/models/privacy_policy_model.dart';
import 'package:gharmb_app/features/profile/models/term_and_condtion_model.dart';
import 'package:gharmb_app/features/profile/repo/legal_repo.dart';

final legalRepoProvider = Provider<LegalRepo>((ref) {
  return LegalRepo();
});

final aboutUsProvider = FutureProvider<AboutUsResponse?>((ref) async {
  final repo = ref.read(legalRepoProvider);
  return repo.aboutUs();
});

final termsConditionProvider = FutureProvider<TermsConditionResponse?>((
  ref,
) async {
  final repo = ref.read(legalRepoProvider);
  return repo.termAndCondtion();
});

final privacyPolicyProvider = FutureProvider<PrivacyPolicyResponse?>((
  ref,
) async {
  final repo = ref.read(legalRepoProvider);
  return repo.privacyPolicy();
});

final helpSupportProvider = FutureProvider<HelpSupportResponse?>((ref) async {
  final repo = ref.read(legalRepoProvider);
  return repo.helpSupportResponse();
});
