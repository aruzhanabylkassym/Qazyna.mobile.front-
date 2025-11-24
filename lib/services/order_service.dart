import '../core/http_client.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/order.dart';

class OrderService {
  OrderService(this._http);
  final HttpClient _http;

  Future<ApiResult<String>> requestOrder(RequestOrder order) async {
    final res = await _http.postJson(Env.requestOrder, order.toJson());
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final msg = res.data?["payload"]?["response_message"]?.toString() ?? "";
    return ApiResult(data: msg, status: res.status);
  }

  Future<ApiResult<List<Order>>> listOrders(String userLogin) async {
    final res = await _http.getJsonList(Env.listOrders, {"user_login": userLogin});
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final arr = (res.data ?? []);
    final items = arr.map<Order>((e) => Order.fromJson(e)).toList();
    return ApiResult(data: items, status: res.status);
  }
}
