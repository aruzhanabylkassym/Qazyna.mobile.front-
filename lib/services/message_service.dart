import '../core/http_client.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/message.dart';

class MessageService {
  MessageService(this._http);
  final HttpClient _http;

  Future<ApiResult<String>> sendMessage(SendMessage msg) async {
    final res = await _http.postJson(Env.sendMessage, msg.toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final m = res.data?["payload"]?["response_message"]?.toString() ?? "";
    return ApiResult(data: m, status: res.status);
  }

  Future<ApiResult<List<Message>>> loadMessages(GetMessage spec) async {
    final res = await _http.getJsonList(Env.loadMessage, spec.toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final arr = (res.data ?? []);
    final items = arr.map<Message>((e) => Message.fromJson(e)).toList();
    return ApiResult(data: items, status: res.status);
  }
}
