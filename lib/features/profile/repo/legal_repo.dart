import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/profile/models/about_us_response.dart';
import 'package:gharmb_app/features/profile/models/help_response_model.dart';
import 'package:gharmb_app/features/profile/models/privacy_policy_model.dart';
import 'package:gharmb_app/features/profile/models/term_and_condtion_model.dart';

class LegalRepo {
  final NetworkApiService _api = NetworkApiService();

  Future<AboutUsResponse?> aboutUs() async {
    final url = await _api.getApi(AppUrls.legalAboutUs);
    if (url == null) {
      return null;
    }
    return AboutUsResponse.fromJson(url);
  }

  Future<TermsConditionResponse?> termAndCondtion() async {
    final url = await _api.getApi(AppUrls.legalTerms);
    if (url == null) {
      return null;
    }
    return TermsConditionResponse.fromJson(url);
  }

  Future<PrivacyPolicyResponse?> privacyPolicy() async {
    final url = await _api.getApi(AppUrls.legalPrivacyPolicy);
    if (url == null) {
      return null;
    }
    return PrivacyPolicyResponse.fromJson(url);
  }

  Future<HelpSupportResponse?> helpSupportResponse() async {
    final url = await _api.getApi(AppUrls.legalHelp);
    if (url == null) {
      return null;
    }
    return HelpSupportResponse.fromJson(url);
  }
}
