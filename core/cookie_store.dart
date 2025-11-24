import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CookieStore {
  static const _sidKey = "cookie_sid";
  static const _passwordKey = "cookie_password";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveSid(String sid) async {
    await _storage.write(key: _sidKey, value: sid);
  }

  Future<String?> loadSid() async {
    return _storage.read(key: _sidKey);
  }

  Future<void> clearSid() async {
    await _storage.delete(key: _sidKey);
  }

  // Backend expects a 'password' cookie pre-login/register.
  Future<void> savePasswordCookie(String plainPassword) async {
    await _storage.write(key: _passwordKey, value: plainPassword);
  }

  Future<String?> loadPasswordCookie() async {
    return _storage.read(key: _passwordKey);
  }

  Future<void> clearPasswordCookie() async {
    await _storage.delete(key: _passwordKey);
  }

  // Build Cookie header: "password=...; sid=..."
  Future<String?> buildCookieHeader({bool includePassword = false}) async {
    final sid = await loadSid();
    final pwd = includePassword ? await loadPasswordCookie() : null;

    final parts = <String>[];
    if (pwd != null && pwd.isNotEmpty) parts.add("password=$pwd");
    if (sid != null && sid.isNotEmpty) parts.add("sid=$sid");
    if (parts.isEmpty) return null;
    return parts.join("; ");
  }
}
