import 'dart:io';
import '../core/http_client.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/photo.dart';

class PictureService {
  PictureService(this._http);
  final HttpClient _http;

  // Backend expects header user_login and body is raw bytes, Content-Type octet-stream
  Future<ApiResult<String>> uploadPicture({
    required String userLogin,
    required File file,
  }) async {
    final bytes = await file.readAsBytes();
    final res = await _http.uploadBytes(
      Env.uploadPictures,
      bytes,
      extraHeaders: {"user_login": userLogin},
    );
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final msg = res.data?["payload"]?["response_message"]?.toString() ?? "";
    return ApiResult(data: msg, status: res.status);
  }

  // Backend GET expects JSON body: { who_uploaded, who_requested }
  Future<ApiResult<List<PhotoItem>>> listPictures(GetPhotos spec) async {
    final res = await _http.getJsonList(Env.listPictures, spec.toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final arr = (res.data ?? []);
    final items = arr.map<PhotoItem>((e) => PhotoItem.fromJson(e)).toList();
    return ApiResult(data: items, status: res.status);
  }
}
