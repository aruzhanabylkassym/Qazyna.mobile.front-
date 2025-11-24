import '../core/http_client.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/link.dart';

class LinkService {
  LinkService(this._http);
  final HttpClient _http;

  Future<ApiResult<String>> requestLink(LinkRequest req) async {
    final res = await _http.postJson(Env.requestLink, req.toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final msg = res.data?["payload"]?["response_message"]?.toString() ?? "";
    return ApiResult(data: msg, status: res.status);
  }

  Future<ApiResult<List<Link>>> listLinks(String userLogin) async {
    final res = await _http.getJsonList(Env.listLinks, LoginContainer(userLogin: userLogin).toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final arr = (res.data ?? []);
    final items = arr.map<Link>((e) => Link.fromJson(e)).toList();
    return ApiResult(data: items, status: res.status);
  }
}
