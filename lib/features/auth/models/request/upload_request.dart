import 'package:gharmb_app/core/data/network/base_api_service.dart';

/// Request payload for a multipart file upload.
/// Kept separate from UploadData (which is the *response* model)
/// to avoid a naming collision.
class FileUploadRequest {
  final Map<String, dynamic> fields; // e.g. { "listingId": "abc123" }
  final List<MultipartFileData> files;

  FileUploadRequest({this.fields = const {}, required this.files});
}
