// Data layer — HTTP client + serialization. Keeps all `dart:io` /
// dart:convert specifics behind a single seam so the repository can
// stay testable.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../domain/entities.dart';

class ApiClient {
  final String apiKey;
  final String apiUrl;
  final HttpClient _http = HttpClient();

  ApiClient({required this.apiKey, required this.apiUrl});

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? idempotencyKey,
    String? branchId,
  }) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.postUrl(uri);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    req.headers.set('x-api-key', apiKey);
    req.headers.set('idempotency-key', idempotencyKey ?? _generateIdempotencyKey());
    if (branchId != null) req.headers.set('x-branch-id', branchId);
    req.write(jsonEncode(body));
    final resp = await req.close();
    final raw = await resp.transform(utf8.decoder).join();
    final parsed = raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
    if (resp.statusCode >= 400) {
      throw SdkError(
        (parsed['code'] as String?) ?? 'HTTP_${resp.statusCode}',
        (parsed['message'] as String?) ?? 'HTTP ${resp.statusCode}',
      );
    }
    return parsed;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.getUrl(uri);
    req.headers.set('x-api-key', apiKey);
    final resp = await req.close();
    final raw = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 400) {
      throw SdkError('HTTP_${resp.statusCode}', raw);
    }
    return raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getList(String path) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.getUrl(uri);
    req.headers.set('x-api-key', apiKey);
    final resp = await req.close();
    final raw = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 400) {
      throw SdkError('HTTP_${resp.statusCode}', raw);
    }
    final decoded = jsonDecode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> delete(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.deleteUrl(uri);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    req.headers.set('x-api-key', apiKey);
    if (body != null) req.write(jsonEncode(body));
    final resp = await req.close();
    await resp.drain<void>();
  }

  static final _random = Random.secure();

  String _generateIdempotencyKey() {
    final bytes = List<int>.generate(8, (_) => _random.nextInt(256));
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return 'iqidem_flutter_$hex';
  }
}
