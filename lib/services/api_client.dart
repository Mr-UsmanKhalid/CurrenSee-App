import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

/// Thrown for any non-2xx response, carrying the backend's error message
/// (e.g. "Invalid email or password") when one was provided.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

/// Single place that knows how to call the Node/MySQL backend: attaches the
/// JWT, encodes/decodes JSON, and turns error responses into ApiException.
class ApiClient {
  ApiClient._();

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAuthToken);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyAuthToken, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAuthToken);
  }

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static dynamic _unwrap(http.Response res) {
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    final message = (body is Map && body['error'] != null)
        ? body['error'] as String
        : 'Request failed (${res.statusCode})';
    throw ApiException(res.statusCode, message);
  }

  static Future<dynamic> get(String url) async {
    final res = await http.get(Uri.parse(url), headers: await _headers());
    return _unwrap(res);
  }

  static Future<dynamic> post(String url, Map<String, dynamic> body, {bool auth = true}) async {
    final res = await http.post(
      Uri.parse(url),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _unwrap(res);
  }

  static Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _unwrap(res);
  }

  static Future<void> delete(String url) async {
    final res = await http.delete(Uri.parse(url), headers: await _headers());
    _unwrap(res);
  }
}
