import 'package:flutter/foundation.dart';
import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/property/models/visit_request_model.dart';

class VisitRequestRepo {
  final NetworkApiService _api = NetworkApiService();

  Future<void> _ensureToken() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isNotEmpty) {
      _api.setToken(token);
    }
  }

  /// 🚀 Schedule a new site visit
  Future<VisitRequestSingleResponse?> scheduleVisit({
    required ScheduleVisitPayload payload,
  }) async {
    try {
      await _ensureToken();
      final res = await _api.postApi(
        AppUrls.scheduleVisit,
        payload.toJson(),
      );
      if (res == null) return null;
      return VisitRequestSingleResponse.fromJson(res);
    } catch (e) {
      debugPrint("Error scheduling visit: $e");
      rethrow;
    }
  }

  /// 📥 Fetch visit requests received for owner's properties
  Future<VisitRequestListResponse?> getReceivedVisitRequests({
    String? status,
    String? propertyId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await _ensureToken();
      final url = AppUrls.receivedVisitRequests(
        status: status,
        propertyId: propertyId,
        page: page,
        limit: limit,
      );
      final res = await _api.getApi(url);
      if (res == null) return null;
      return VisitRequestListResponse.fromJson(res);
    } catch (e) {
      debugPrint("Error fetching received visit requests: $e");
      rethrow;
    }
  }

  /// 📤 Fetch visit requests submitted by the logged-in user
  Future<VisitRequestListResponse?> getMyVisitRequests({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      await _ensureToken();
      final url = AppUrls.myVisitRequests(
        status: status,
        page: page,
        limit: limit,
      );
      final res = await _api.getApi(url);
      if (res == null) return null;
      return VisitRequestListResponse.fromJson(res);
    } catch (e) {
      debugPrint("Error fetching my visit requests: $e");
      rethrow;
    }
  }

  /// 🔍 Fetch single visit request details
  Future<VisitRequestSingleResponse?> getVisitRequestDetail(String id) async {
    try {
      await _ensureToken();
      final res = await _api.getApi(AppUrls.visitRequestDetail(id: id));
      if (res == null) return null;
      return VisitRequestSingleResponse.fromJson(res);
    } catch (e) {
      debugPrint("Error fetching visit request detail: $e");
      rethrow;
    }
  }

  /// 🟢 Accept a visit request (Owner action)
  Future<VisitRequestSingleResponse?> acceptVisitRequest(
    String id, {
    String? message,
  }) async {
    try {
      await _ensureToken();
      final data = <String, dynamic>{
        if (message != null && message.trim().isNotEmpty)
          'message': message.trim(),
      };
      final res = await _api.patchApi(
        AppUrls.acceptVisitRequest(id: id),
        data,
      );
      if (res == null) return null;
      return VisitRequestSingleResponse.fromJson(res);
    } catch (e) {
      debugPrint("Error accepting visit request: $e");
      rethrow;
    }
  }

  /// 🔴 Reject a visit request with owner's message (Owner action)
  Future<VisitRequestSingleResponse?> rejectVisitRequest(
    String id, {
    required String ownerMessage,
  }) async {
    try {
      await _ensureToken();
      final data = {
        'ownerMessage': ownerMessage.trim(),
      };
      final res = await _api.patchApi(
        AppUrls.rejectVisitRequest(id: id),
        data,
      );
      if (res == null) return null;
      return VisitRequestSingleResponse.fromJson(res);
    } catch (e) {
      debugPrint("Error rejecting visit request: $e");
      rethrow;
    }
  }
}
