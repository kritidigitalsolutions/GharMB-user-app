abstract class BaseApiService {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(String url, dynamic data);

  Future<dynamic> pacthApi(String url, dynamic data);

  Future<dynamic> putApi(String url, dynamic data);

  Future<dynamic> deleteApi(String url, dynamic data);

  Future<dynamic> uploadMultipartApi(
    String url,
    Map<String, dynamic> fields, {
    List<MultipartFileData>? files,
  });
}

class MultipartFileData {
  final String fieldName; // e.g. "images", "files"
  final String filePath; // local path on device
  final String? fileName; // optional override, else basename is used

  MultipartFileData({
    required this.fieldName,
    required this.filePath,
    this.fileName,
  });
}
