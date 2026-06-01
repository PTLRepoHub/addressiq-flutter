import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class AddressIQApi {
  final String apiUrl;
  final String apiKey;
  final String sessionToken;

  AddressIQApi({
    required this.apiUrl,
    required this.apiKey,
    required this.sessionToken,
  });

  Map<String, String> get _apiHeaders => {
    'Content-Type': 'application/json',
    'x-api-key': apiKey,
    'x-sdk-version': '0.3.0',
  };

  Map<String, String> get _sessionHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $sessionToken',
  };

  /// Initialize widget session.
  Future<Map<String, dynamic>> initSession() async {
    final res = await http.post(
      Uri.parse('$apiUrl/api/v1/widget/session'),
      headers: _sessionHeaders,
    );
    _checkResponse(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Submit address for verification.
  Future<VerifyResult> submitAddress(AddressData address) async {
    final res = await http.post(
      Uri.parse('$apiUrl/api/v1/widget/submit'),
      headers: _sessionHeaders,
      body: jsonEncode(address.toJson()),
    );
    _checkResponse(res);
    return VerifyResult.fromJson(jsonDecode(res.body));
  }

  /// Get verification status.
  Future<VerificationStatus> getStatus(String verificationId) async {
    final res = await http.get(
      Uri.parse('$apiUrl/api/v1/verifications/$verificationId'),
      headers: _apiHeaders,
    );
    _checkResponse(res);
    return VerificationStatus.fromJson(jsonDecode(res.body));
  }

  /// Send location events to ingest.
  Future<void> sendEvents(String locationId, List<LocationEvent> events) async {
    final payload = events.map((e) {
      final json = e.toJson();
      json['locationId'] = locationId;
      return json;
    }).toList();

    final res = await http.post(
      Uri.parse('$apiUrl/v1/transit-events/batch'),
      headers: _apiHeaders,
      body: jsonEncode({'events': payload}),
    );
    _checkResponse(res);
  }

  /// Send heartbeat.
  Future<void> heartbeat(String locationId) async {
    await http.post(
      Uri.parse('$apiUrl/v1/geofences/$locationId/heartbeat'),
      headers: _apiHeaders,
    );
  }

  void _checkResponse(http.Response res) {
    if (res.statusCode >= 400) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'API error (${res.statusCode})');
    }
  }
}
