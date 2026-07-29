import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/property/models/owner_properties_listing_model.dart';
import 'package:gharmb_app/features/property/models/payload/owner_propert_listing_payload.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';

class PropertyRepo {
  final NetworkApiService _api = NetworkApiService();

  Future<PropertyListingResponse?> addPropertyListing({
    required OwnerPropertListingPayload ownerPropertListingPayload,
  }) async {
    try {
      // Get token from storage
      final String token = await LocalStorageService.getToken() ?? "";

      if (token.isEmpty) {
        print("Token is empty");
        throw FetchDataException(
          "Authentication token not found. Please login again.",
        );
      }

      // Set token in API service
      _api.setToken(token);

      // Make API call
      final res = await _api.postApi(
        AppUrls.addProperties,
        ownerPropertListingPayload.toJson(),
      );

      print("Add Property Response: $res");

      // Check if response is successful
      if (res is Map<String, dynamic>) {
        // Check for success status
        if (res['status'] == 'success') {
          // Parse response
          final response = PropertyListingResponse.fromJson(res);
          print("Property added successfully: ${response.data?.submissionId}");
          return response;
        } else {
          // Handle API error
          final message =
              res['message']?.toString() ?? 'Failed to add property';
          print("API Error: $message");
          throw FetchDataException(message);
        }
      }

      // If response is not a Map, throw error
      throw FetchDataException("Invalid response format from server");
    } on AppException {
      // Re-throw AppExceptions (like FetchDataException)
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      print("Unexpected error in addPropertyListing: $e");
      throw FetchDataException("Failed to add property: ${e.toString()}");
    }
  }

  Future<NearPropertiesResponse?> nearAllProperties({String? city}) async {
    final res = await _api.getApi(AppUrls.nearProperties(city));
    if (res == null) {
      print("not response!");
      return null;
    }
    return NearPropertiesResponse.fromJson(res);
  }
}
