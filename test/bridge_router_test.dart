import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/api/models.dart';
import 'package:addressiq_sdk/src/ui/bridge_router.dart';

/// Unit tests for the web-widget bridge protocol mapping. Keeps the Flutter
/// shell in lockstep with the shared web `HostBridge` shapes — the same
/// protocol proven against the real widget by the iOS WKWebView test and
/// covered by the Android + React Native router tests.
void main() {
  late _Recorder rec;

  setUp(() => rec = _Recorder());

  test('addressSelected maps to a CollectResult', () {
    routeBridgeMessage(
      jsonEncode({
        'kind': 'event',
        'name': 'addressSelected',
        'payload': {
          'locationCode': 'LOC-1',
          'formattedAddress': '1 Marina',
          'geoPoint': {'lat': 6.5, 'lng': 3.4},
        },
      }),
      rec.sinks,
    );
    expect(rec.completed?.locationCode, 'LOC-1');
    expect(rec.completed?.formattedAddress, '1 Marina');
    expect(rec.completed?.lat, 6.5);
    expect(rec.completed?.lon, 3.4);
  });

  test('verificationStarted is terminal completion', () {
    routeBridgeMessage(
      jsonEncode({'kind': 'event', 'name': 'verificationStarted', 'payload': {'locationCode': 'LOC-9'}}),
      rec.sinks,
    );
    expect(rec.completed?.locationCode, 'LOC-9');
  });

  test('close cancels, error fails', () {
    routeBridgeMessage(jsonEncode({'kind': 'event', 'name': 'close'}), rec.sinks);
    expect(rec.cancelled, isTrue);

    routeBridgeMessage(jsonEncode({'kind': 'event', 'name': 'error', 'payload': {'message': 'boom'}}), rec.sinks);
    expect(rec.failed.toString(), contains('boom'));
  });

  test('getPermissionStatus and getLocation delegate to async handlers', () {
    routeBridgeMessage(jsonEncode({'kind': 'request', 'id': 'req_1', 'action': 'getPermissionStatus'}), rec.sinks);
    expect(rec.permissionRequestId, 'req_1');

    routeBridgeMessage(jsonEncode({'kind': 'request', 'id': 'req_2', 'action': 'getLocation'}), rec.sinks);
    expect(rec.locationRequestId, 'req_2');

    routeBridgeMessage(jsonEncode({'kind': 'request', 'id': 'req_4', 'action': 'requestPermission'}), rec.sinks);
    expect(rec.permissionPromptId, 'req_4');

    routeBridgeMessage(jsonEncode({'kind': 'request', 'id': 'req_5', 'action': 'getPermissionState'}), rec.sinks);
    expect(rec.permissionStateId, 'req_5');

    routeBridgeMessage(jsonEncode({'kind': 'request', 'id': 'req_6', 'action': 'openSettings'}), rec.sinks);
    expect(rec.openSettingsId, 'req_6');
  });

  test('unknown action rejects', () {
    routeBridgeMessage(jsonEncode({'kind': 'request', 'id': 'req_3', 'action': 'teleport'}), rec.sinks);
    expect(rec.rejected?.$1, 'req_3');
    expect(rec.rejected?.$2, 'UNKNOWN_ACTION');
  });

  test('malformed input is ignored', () {
    routeBridgeMessage('not json', rec.sinks);
    expect(rec.completed, isNull);
    expect(rec.locationRequestId, isNull);
  });
}

class _Recorder {
  CollectResult? completed;
  bool cancelled = false;
  Object? failed;
  String? locationRequestId;
  String? permissionPromptId;
  String? permissionStateId;
  String? openSettingsId;
  String? permissionRequestId;
  (String, String, String)? rejected;

  late final BridgeSinks sinks = BridgeSinks(
    onCompleted: (r) => completed = r,
    onCancelled: () => cancelled = true,
    onFailed: (e) => failed = e,
    onLocationRequest: (id) => locationRequestId = id,
    onPermissionRequest: (id) => permissionPromptId = id,
    onGetPermissionState: (id) => permissionStateId = id,
    onOpenSettings: (id) => openSettingsId = id,
    onPermissionStatusRequest: (id) => permissionRequestId = id,
    reject: (id, code, message) => rejected = (id, code, message),
  );
}
