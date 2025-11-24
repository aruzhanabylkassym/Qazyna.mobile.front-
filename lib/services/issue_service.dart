import '../core/http_client.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/issue.dart';

class IssueService {
  IssueService(this._http);
  final HttpClient _http;

  Future<ApiResult<String>> requestIssue(RequestIssue issue) async {
    final res = await _http.postJson(Env.requestIssue, issue.toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final msg = res.data?["payload"]?["response_message"]?.toString() ?? "";
    return ApiResult(data: msg, status: res.status);
  }

  Future<ApiResult<List<Issue>>> listIssues(String userLogin) async {
    final res = await _http.getJsonList(Env.listIssues, {"user_login": userLogin});
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final arr = (res.data ?? []);
    final items = arr.map<Issue>((e) => Issue.fromJson(e)).toList();
    return ApiResult(data: items, status: res.status);
  }
}
