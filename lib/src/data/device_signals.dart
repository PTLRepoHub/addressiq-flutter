import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device intelligence attached to every transit event as `rawPayload`.
///
/// The scoring engine reads `device.isEmulator`, `location.isMocked`,
/// `security.isRooted` and `fingerprint.installId` out of that object. This SDK
/// sent none of them, so on a Flutter app EMULATOR_DETECTED, MOCK_LOCATION,
/// ROOTED_DEVICE, SPOOFING_APP and the install-id blacklist were every one of
/// them unreachable: a device could be an emulator running a spoofing app on a
/// rooted phone with a mocked location and score identically to an honest one.
///
/// These are heuristics, not proof. They exist to raise the cost of the cheap
/// attacks and are weighed by the server as evidence.
///
/// What is deliberately NOT here: root and jailbreak detection, which need
/// platform code this package does not have (it is a pure Dart package, not a
/// plugin). Rather than report `isRooted: false` — asserting something we
/// cannot observe, which is worse than silence because the engine would read it
/// as a clean device — the section is simply omitted.
class AddressIQDeviceSignals {
  AddressIQDeviceSignals._();

  static const _installIdKey = 'addressiq.installId';

  /// Cached for the process lifetime: these do not change while the app runs,
  /// and both lookups cross a platform channel.
  static Map<String, Map<String, dynamic>>? _cached;

  /// Collect the sections, or an empty map if the platform lookup fails.
  ///
  /// Never throws. A missing device section costs a fraud signal; a thrown
  /// exception here would cost the event itself, which is strictly worse.
  static Future<Map<String, Map<String, dynamic>>> collect() async {
    final cached = _cached;
    if (cached != null) return cached;

    final signals = <String, Map<String, dynamic>>{};
    try {
      final info = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final android = await info.androidInfo;
        signals['device'] = {
          'isEmulator': !android.isPhysicalDevice,
          'model': android.model,
          'manufacturer': android.manufacturer,
          'osVersion': android.version.release,
        };
      } else if (Platform.isIOS) {
        final ios = await info.iosInfo;
        signals['device'] = {
          'isEmulator': !ios.isPhysicalDevice,
          'model': ios.utsname.machine,
          'osVersion': ios.systemVersion,
        };
      }
      signals['fingerprint'] = {'installId': await _installId()};
    } catch (_) {
      // Fall through with whatever was gathered.
    }

    _cached = signals;
    return signals;
  }

  /// Drop the cache. Called on logout so a new session does not inherit the
  /// previous one's identifiers.
  static void reset() => _cached = null;

  /// A per-install identifier, generated once and kept in shared preferences.
  ///
  /// Not a hardware id: it dies with the install. That is the privacy property
  /// we want — it links a device across one verification without becoming a
  /// durable cross-app identifier.
  static Future<String> _installId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_installIdKey);
    if (existing != null) return existing;
    // Time + entropy rather than a uuid dependency for one call site.
    final generated =
        '${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}-'
        '${identityHashCode(Object()).toRadixString(16)}';
    await prefs.setString(_installIdKey, generated);
    return generated;
  }
}
