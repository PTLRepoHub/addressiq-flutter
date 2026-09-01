import 'dart:io';

import 'package:addressiq_sdk/src/data/device_signals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// The Flutter collector, running on an actual device.
///
/// Everything asserted about this SDK's device intelligence so far has been
/// asserted about its *source* — that `rawPayload` is declared, that the
/// strings are present in `libapp.so`. None of it establishes that the platform
/// answers, and this session found two Android signals that had been silently
/// answering "false" for meaning "could not look" for their entire lives.
///
/// `device_info_plus` reaches the platform, so these must run on a device:
///
///   flutter test integration_test/device_signals_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(AddressIQDeviceSignals.reset);

  testWidgets('the collector answers rather than falling silent', (_) async {
    final signals = await AddressIQDeviceSignals.collect();

    expect(
      signals['device'],
      isNotNull,
      reason: 'no device section — EMULATOR_DETECTED is unreachable from Flutter',
    );
    expect(
      signals['fingerprint']?['installId'],
      isNotNull,
      reason: 'no installId — DEVICE_CHANGE and the device blacklist have no key',
    );
    expect(signals['device']!.containsKey('isEmulator'), isTrue);
  });

  testWidgets('an emulator is reported as one', (_) async {
    final signals = await AddressIQDeviceSignals.collect();
    final isEmulator = signals['device']!['isEmulator'] as bool;

    // This suite runs on an emulator. The Android SDK's own heuristic returned
    // false here for its whole life because it matched no current AVD, so this
    // is the assertion that matters: does device_info_plus actually know?
    expect(
      isEmulator,
      isTrue,
      reason: 'device_info_plus reported physical hardware on an emulator — '
          'EMULATOR_DETECTED cannot fire from Flutter, exactly as the native '
          'Build-property heuristic could not',
    );
  });

  testWidgets('the install id is stable across calls and survives a reset', (_) async {
    final first = (await AddressIQDeviceSignals.collect())['fingerprint']!['installId'];
    AddressIQDeviceSignals.reset();
    final second = (await AddressIQDeviceSignals.collect())['fingerprint']!['installId'];

    // Reset drops the in-memory cache, not the stored id. If it minted a new
    // one each time, every event would carry a different install id and
    // DEVICE_CHANGE would fire on every verification.
    expect(second, equals(first));
    expect((first as String).isNotEmpty, isTrue);
  });

  testWidgets('root and spoofing are omitted, not reported false', (_) async {
    final signals = await AddressIQDeviceSignals.collect();

    // Deliberate: a pure Dart package cannot host the platform code these need.
    // Sending `false` would tell the engine "clean device" when the truth is
    // "never looked", which is the failure mode this whole audit exists for.
    expect(signals['security'], isNull);
    if (Platform.isAndroid || Platform.isIOS) {
      expect(signals['device']!.containsKey('model'), isTrue);
    }
  });
}
