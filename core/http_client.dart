import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import 'cookie_store.dart';
import 'api_result.dart';

class HttpClient {
  HttpClient(this._cookies);

  final CookieStore _cookies;

  Uri _u(String path) => Uri.parse("${Env.baseUrl}$path");

  Map<String, String> _jsonHeaders({String? cookie, Map<String, String>? extra}) {
    final headers = <String, String>{
      "Content-Type": "application/json",
    };
    if (cookie != null) headers["Cookie"] = cookie;
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  Future<ApiResult<Map<String, dynamic>>> postJson(
    String path,
    Map<String, dynamic> body, {
    bool withSid = true,
    bool withPasswordCookie = false,
    Map<String, String>? extraHeaders,
  }) async {
    final cookieHeader = await _cookies.buildCookieHeader(includePassword: withPasswordCookie);
    final headers = _jsonHeaders(cookie: withSid ? cookieHeader : cookieHeader, extra: extraHeaders);
    final res = await http.post(_u(path), headers: headers, body: jsonEncode(body));
    return _wrap(res);
  }

  Future<ApiResult<List<dynamic>>> getJsonList(
    String path,
    Map<String, dynamic>? bodyForBackendGetRequiresJson, {
    bool withSid = true,
    Map<String, String>? extraHeaders,
  }) async {
    // Your backend GET expects JSON body (non-standard). We'll send with http.Request.
    final cookieHeader = await _cookies.buildCookieHeader();
    final req = http.Request("GET", _u(path));
    req.headers.addAll(_jsonHeaders(cookie: withSid ? cookieHeader : cookieHeader, extra: extraHeaders));
    if (bodyForBackendGetRequiresJson != null) {
      req.body = jsonEncode(bodyForBackendGetRequiresJson);
    }
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final parsed = _wrap(res);

    if (!parsed.ok || parsed.data == null) {
      return ApiResult<List<dynamic>>(error: parsed.error, status: parsed.status);
    }
    final data = parsed.data!;
    if (data is List) {
      return ApiResult<List<dynamic>>(data: data, status: parsed.status);
    }
    return ApiResult<List<dynamic>>(error: "Expected a JSON array", status: parsed.status);
  }

  Future<ApiResult<Map<String, dynamic>>> uploadBytes(
    String path,
    List<int> bytes, {
    required Map<String, String> extraHeaders,
    bool withSid = true,
  }) async {
    final cookieHeader = await _cookies.buildCookieHeader();
    final headers = {
      "Content-Type": "application/octet-stream",
      if (withSid && cookieHeader != null) "Cookie": cookieHeader,
      ...extraHeaders,
    };
    final res = await http.post(_u(path), headers: headers, body: bytes);
    return _wrap(res);
  }

  ApiResult<Map<String, dynamic>> _wrap(http.Response res) {
    final status = res.statusCode;
    try {
      final json = jsonDecode(res.body);
      if (json is Map<String, dynamic> || json is List) {
        return ApiResult<Map<String, dynamic>>(data: {"payload": json}, status: status);
      }
      return ApiResult<Map<String, dynamic>>(error: "Invalid JSON", status: status);
    } catch (_) {
      return ApiResult<Map<String, dynamic>>(error: "Failed to parse JSON", status: status);
    }
  }
}
