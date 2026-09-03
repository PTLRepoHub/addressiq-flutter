import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/data/api_client.dart';
import 'package:addressiq_sdk/src/domain/entities.dart';
import 'package:addressiq_sdk/src/generated/build_config.dart';

/// The transport, driven over a real socket.
///
/// Covers the three things that differed per-method or per-platform: the SDK
/// identity headers (only RN sent them, and Flutter's own were hardcoded at
/// '0.3.0' while the package shipped 0.12.0), and error bodies, which `post`
/// parsed for the server's `code`/`message` while `get`/`getList` dumped the
/// raw body as the message.
void main() {
  late HttpServer server;
  late List<HttpRequest> received;
  late List<String> bodies;
  late ApiClient client;

  /// Answers every request with [status]/[body], recording what arrived.
  Future<void> serve(int status, String body) async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    received = [];
    bodies = [];
    server.listen((req) async {
      received.add(req);
      // Read the body here: the stream is gone once the response closes.
      bodies.add(await utf8.decodeStream(req));
      req.response.statusCode = status;
      req.response.write(body);
      await req.response.close();
    });
    client = ApiClient(apiKey: 'test-key', apiUrl: 'http://127.0.0.1:${server.port}');
  }

  tearDown(() async => server.close(force: true));

  test('identifies the SDK by name and baked version', () async {
    await serve(200, '{}');

    await client.post('/api/v1/x', {});

    expect(received.single.headers.value('x-api-key'), 'test-key');
    expect(received.single.headers.value('x-sdk-name'), 'addressiq-flutter');
    expect(received.single.headers.value('x-sdk-version'), kSdkVersion);
    // Baked from pubspec.yaml, so it cannot drift from the published package.
    expect(kSdkVersion, isNotEmpty);
  });

  test('sends booleans and numbers as JSON types', () async {
    await serve(200, '{}');

    await client.post('/api/v1/x', {'startDigital': true, 'slaHours': 24});

    final body = jsonDecode(bodies.single) as Map<String, dynamic>;
    expect(body['startDigital'], isTrue);
    expect(body['slaHours'], 24);
  });

  test('post surfaces the server code and message', () async {
    await serve(422, '{"code":"LOCATION_NOT_VERIFIABLE","message":"Outside coverage"}');

    expect(
      () => client.post('/api/v1/x', {}),
      throwsA(isA<SdkError>()
          .having((e) => e.code, 'code', 'LOCATION_NOT_VERIFIABLE')
          .having((e) => e.message, 'message', 'Outside coverage')),
    );
  });

  test('get surfaces the server code too, not the raw body', () async {
    await serve(404, '{"code":"LOCATION_NOT_FOUND","message":"No such location"}');

    expect(
      () => client.get('/api/v1/locations/LOC_1'),
      throwsA(isA<SdkError>()
          .having((e) => e.code, 'code', 'LOCATION_NOT_FOUND')
          .having((e) => e.message, 'message', 'No such location')),
    );
  });

  test('a non-JSON error body still produces a usable error', () async {
    await serve(502, '<html>Bad Gateway</html>');

    expect(
      () => client.get('/api/v1/x'),
      throwsA(isA<SdkError>().having((e) => e.code, 'code', 'HTTP_502')),
    );
  });

  test('getList converts eagerly so a bad entry fails at the call', () async {
    await serve(200, '[{"type":"digital"},"not-an-object"]');

    expect(() => client.getList('/api/v1/providers'), throwsA(isA<TypeError>()));
  });

  test('getList decodes a well-formed list', () async {
    await serve(200, '[{"type":"digital","enabled":true}]');

    final providers = await client.getList('/api/v1/providers');

    expect(providers, hasLength(1));
    expect(providers.first['enabled'], isTrue);
  });
}
