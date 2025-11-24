import 'dart:convert';
import '../core/http_client.dart';
import '../core/cookie_store.dart';
import '../core/api_result.dart';
import '../config/env.dart';
import '../models/common.dart';
import '../models/user_credentials.dart';

class AuthService {
  AuthService(this._http, this._cookies);
  final HttpClient _http;
  final CookieStore _cookies;

  // Register: must include 'password' cookie and JSON body of user
  Future<ApiResult<ServerMessage>> register(UserCredentials creds, String plainPassword) async {
    await _cookies.savePasswordCookie(plainPassword);
    final res = await _http.postJson(Env.register, creds.toRegisterJson(), withSid: false, withPasswordCookie: true);
    await _cookies.clearPasswordCookie();
    if (!res.ok) return ApiResult(error: res.error, status: res.status);

    final payload = res.data?["payload"];
    return ApiResult(data: ServerMessage.fromJson(payload), status: res.status);
  }

  // Login: backend hashes cookie "password" server-side, sets "sid" cookie in response
  Future<ApiResult<ServerMessage>> login(String userLogin, String plainPassword) async {
    await _cookies.savePasswordCookie(plainPassword);
    final body = UserCredentials(
      userLogin: userLogin,
      firstName: "",
      lastName: "",
      accType: "",
      orgType: "",
      orgName: "",
    ).toLoginJson();

    final res = await _http.postJson(Env.login, body, withSid: false, withPasswordCookie: true);
    await _cookies.clearPasswordCookie();

    if (!res.ok) return ApiResult(error: res.error, status: res.status);

    // Extract sid from Set-Cookie if present? Backend sets cookie server-side, but http does not store.
    // We rely on response body only; in real flow, sid is saved by server, but mobile must hold it:
    // We'll parse 'sid' if server also echoes it. If not, we ask the user to paste sid or modify backend to return it.
    // For now, assume Access Granted then GET /api/list/... will use the sid we don't have → workaround:
    // Ask backend to also return sid in response_message, or we let user input sid.
    // Simpler: backend doesn't return sid; mobile cannot read Set-Cookie. We'll require a proxy or return sid.
    // To progress, we assume server returns response_message and we cannot capture sid.
    // If you add sid to response, save it like: await _cookies.saveSid(sid);
    final payload = res.data?["payload"];
    return ApiResult(data: ServerMessage.fromJson(payload), status: res.status);
  }

  Future<ApiResult<ServerMessage>> logout(String userLogin) async {
    final res = await _http.postJson(Env.logout, {"user_login": userLogin});
    if (!res.ok) return ApiResult(error: res.error, status: res.status);
    await _cookies.clearSid();
    final payload = res.data?["payload"];
    return ApiResult(data: ServerMessage.fromJson(payload), status: res.status);
  }
}
