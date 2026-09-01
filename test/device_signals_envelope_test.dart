import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/api/models.dart';

/// The Flutter SDK sent no device intelligence at all, so on a Flutter app
/// EMULATOR_DETECTED, MOCK_LOCATION, ROOTED_DEVICE and the install-id blacklist
/// were every one of them unreachable — a compromised device scored exactly
/// like an honest one. These pin the envelope so that cannot silently regress.
void main() {
  group('LocationEvent device intelligence', () {
    LocationEvent event({Map<String, dynamic>? raw}) => LocationEvent(
      lat: 6.5244,
      lon: 3.3792,
      accuracyM: 12,
      deviceTs: '2026-09-01T00:00:00.000Z',
      eventType: 'GEOFENCE_ENTER',
      rawPayload: raw,
    );

    test('carries rawPayload onto the wire when signals are present', () {
      final json = event(raw: {
        'device': {'isEmulator': true},
        'location': {'isMocked': true},
        'fingerprint': {'installId': 'abc-123'},
      }).toJson();

      final payload = json['rawPayload'] as Map<String, dynamic>;
      expect((payload['device'] as Map)['isEmulator'], isTrue);
      expect((payload['location'] as Map)['isMocked'], isTrue);
      expect((payload['fingerprint'] as Map)['installId'], 'abc-123');
    });

    test('omits rawPayload entirely when nothing was observed', () {
      // Not `{}`: an absent section reads as "not observed", which is honest.
      // Sending an empty object invites the engine to treat silence as a
      // clean device.
      expect(event().toJson().containsKey('rawPayload'), isFalse);
      expect(event(raw: {}).toJson().containsKey('rawPayload'), isFalse);
    });

    test('still reports the platform and a flutter-qualified sdkVersion', () {
      final json = event().toJson();
      expect(json['deviceOs'], anyOf('IOS', 'ANDROID'));
      expect(json['sdkVersion'], startsWith('flutter/'));
    });
  });
}
