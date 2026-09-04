// Data layer — HTTP client + serialization. Keeps all `dart:io` /
// dart:convert specifics behind a single seam so the repository can
// stay testable.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../domain/entities.dart';
import '../generated/build_config.dart';

class ApiClient {
  final String apiKey;
  final String apiUrl;
  final HttpClient _http = HttpClient();

  ApiClient({required this.apiKey, required this.apiUrl});

  /// Auth plus SDK identity, on every request.
  ///
  /// `x-sdk-name`/`x-sdk-version` let the server tell platforms and versions
  /// apart. The version comes from [kSdkVersion], baked from `pubspec.yaml`,
  /// so it cannot drift from the published package the way the hardcoded
  /// '0.3.0' in `AddressIQApi` did while the package shipped 0.12.0.
  void _setIdentifyingHeaders(HttpClientRequest req) {
    req.headers.set('x-api-key', apiKey);
    req.headers.set('x-sdk-name', 'addressiq-flutter');
    req.headers.set('x-sdk-version', kSdkVersion);
  }

  /// Reads an error body the same way regardless of method.
  ///
  /// `get`/`getList`/`delete` used to throw `SdkError('HTTP_$code', raw)`,
  /// dumping the whole body as the message, while `post` parsed the server's
  /// own `code` and `message`. Same client, same API, two different error
  /// shapes reaching the integrator.
  Never _throwHttp(int statusCode, String raw) {
    Map<String, dynamic> parsed;
    try {
      parsed = raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      parsed = <String, dynamic>{};
    } on TypeError {
      parsed = <String, dynamic>{};
    }
    throw SdkError(
      (parsed['code'] as String?) ?? 'HTTP_$statusCode',
      (parsed['message'] as String?) ?? (raw.isEmpty ? 'HTTP $statusCode' : raw),
    );
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? idempotencyKey,
    String? branchId,
  }) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.postUrl(uri);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    _setIdentifyingHeaders(req);
    req.headers.set('idempotency-key', idempotencyKey ?? _generateIdempotencyKey());
    if (branchId != null) req.headers.set('x-branch-id', branchId);
    req.write(jsonEncode(body));
    final resp = await req.close();
    final raw = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 400) _throwHttp(resp.statusCode, raw);
    return raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.getUrl(uri);
    _setIdentifyingHeaders(req);
    final resp = await req.close();
    final raw = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 400) _throwHttp(resp.statusCode, raw);
    return raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getList(String path) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.getUrl(uri);
    _setIdentifyingHeaders(req);
    final resp = await req.close();
    final raw = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 400) _throwHttp(resp.statusCode, raw);
    if (raw.isEmpty) return <Map<String, dynamic>>[];
    final decoded = jsonDecode(raw) as List;
    // `.cast()` is lazy in Dart: a malformed entry would throw at iteration,
    // far from here. Convert eagerly so the failure names the call that caused it.
    return List<Map<String, dynamic>>.from(decoded);
  }

  Future<void> delete(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$apiUrl$path');
    final req = await _http.deleteUrl(uri);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    _setIdentifyingHeaders(req);
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
