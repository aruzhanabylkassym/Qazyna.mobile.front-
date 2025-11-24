import '../core/http_client.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/user_credentials.dart';

class SupplierService {
  SupplierService(this._http);
  final HttpClient _http;

  Future<ApiResult<List<UserCredentials>>> listSuppliersOwners() async {
    final res = await _http.getJsonList(Env.listSuppliers, null);
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    final arr = (res.data ?? []);
    final items = arr.map<UserCredentials>((e) => UserCredentials.fromSupplierOwnerRow(e)).toList();
    return ApiResult(data: items, status: res.status);
  }
}
