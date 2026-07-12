// AddressIQ — Phase 3 singleton lifecycle (Flutter).
//
// Presentation layer for the Clean Architecture stack:
//   lib/src/domain/  — pure entities + value types (SdkUser, etc.)
//   lib/src/data/    — ApiClient + VerificationRepository (HTTP)
//   lib/src/lifecycle/  — this file: the public singleton + state machine
//
// Mirrors the RN SDK 1:1 at the public-method level:
//   initialize → setUser → startPhysical/startCombined → pause/resume/sync/logout/reset

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../api/addressiq_api.dart';
import '../api/environment.dart';
import '../data/api_client.dart';
import '../data/verification_repository.dart';
import '../domain/entities.dart';
import '../location/collection_starter.dart';
import '../location/location_collector.dart';

export '../domain/entities.dart';

class AddressIQConfig {
  /// Tenant API key from the AddressIQ dashboard.
  final String apiKey;

  /// Target environment. Drives [resolvedApiUrl]. One of `'production'`,
  /// `'staging'` / `'sandbox'`, or `'development'` (local backend on 3355).
  final String environment;

  const AddressIQConfig({
    required this.apiKey,
    this.environment = 'production',
  });

  /// Effective API URL, resolved from [environment]. Integrators never
  /// pass a URL — the SDK owns host resolution.
  String get resolvedApiUrl => resolveEnvironmentApiUrl(environment);
}

class AddressIQException implements Exception {
  final String code;
  final String message;
  AddressIQException(this.code, this.message);
  @override
  String toString() => 'AddressIQException($code): $message';
}

/// Public singleton — `AddressIQ.instance`.
///
/// Use the canonical flow:
///   AddressIQ.instance.initialize(config);
///   await AddressIQ.instance.setUser(SdkUser(appUserId: 'cust_abc'));
///   final res = await AddressIQ.instance.startPhysical(StartPhysicalArgs(...));
///   ...
///   await AddressIQ.instance.logout();
class AddressIQ {
  AddressIQ._();
  static final AddressIQ instance = AddressIQ._();

  AddressIQConfig? _config;
  SdkUser? _user;
  SdkLifecycleState _state = SdkLifecycleState.uninitialized;
  String? _activeVerificationId;
  String? _activeLocationCode;
  DateTime? _pausedAt;

  VerificationRepository? _repository;
  LocationCollector? _collector;

  // ─── Initialization + identity ──────────────────────────────────────────

  void initialize(AddressIQConfig config) {
    if (config.apiKey.isEmpty) {
      throw AddressIQException('INVALID_CONFIG', 'apiKey is required');
    }
    if (config.resolvedApiUrl.isEmpty) {
      throw AddressIQException('INVALID_CONFIG', 'apiUrl resolved to empty string (check environment)');
    }
    _config = config;
    _repository = VerificationRepository(
      ApiClient(apiKey: config.apiKey, apiUrl: config.resolvedApiUrl),
    );
    _state = SdkLifecycleState.idle;
  }

  Future<void> setUser(SdkUser user) async {
    _requireInitialized();
    if (user.appUserId.isEmpty) {
      throw AddressIQException('INVALID_USER', 'appUserId is required');
    }
    if (_user != null && _user!.appUserId != user.appUserId) {
      await pauseVerification();
    }
    _user = user;
    if (_state == SdkLifecycleState.uninitialized ||
        _state == SdkLifecycleState.terminated) {
      _state = SdkLifecycleState.idle;
    }
  }

  // ─── Verification surface ───────────────────────────────────────────────

  /// Start a digital address verification. Uses SDK telemetry +
  /// geofencing to score residency at the given location. Hits
  /// `POST /api/v1/locations/{locationCode}/verifications/digital` with
  /// `{"digitalProvider": provider ?? 'internal_ai'}`.
  Future<Map<String, dynamic>> startVerification(
    StartVerificationArgs args,
  ) async {
    final repo = _requireInitialized();
    return _runStart(() => repo.startDigital(args), args.locationCode);
  }

  /// Start a physical address verification. A partner-provided agent
  /// or KYC provider visits the address to confirm residency.
  Future<Map<String, dynamic>> startPhysicalVerification(
    StartPhysicalArgs args,
  ) async {
    final repo = _requireInitialized();
    return _runStart(() => repo.startPhysical(args), args.locationCode);
  }

  /// Start a combined digital + physical verification. Digital runs
  /// first via the AI provider (uses SDK telemetry to score residency);
  /// physical fallback fires if the digital half resolves to UNKNOWN.
  Future<Map<String, dynamic>> startDigitalAndPhysicalVerification(
    StartCombinedArgs args,
  ) async {
    final repo = _requireInitialized();
    return _runStart(() => repo.startCombined(args), args.locationCode);
  }


  Future<Map<String, dynamic>> cancelVerification(
    String verificationCode, {
    String? idempotencyKey,
  }) async {
    final repo = _requireInitialized();
    return repo.cancel(verificationCode, idempotencyKey: idempotencyKey);
  }

  Future<List<Map<String, dynamic>>> listProviders({String? type}) async {
    final repo = _requireInitialized();
    return repo.listProviders(type: type);
  }

  Future<LocationEnvelope> getLocation(String locationCode) async {
    final repo = _requireInitialized();
    return repo.getLocation(locationCode);
  }

  // ─── Lifecycle ──────────────────────────────────────────────────────────

  Future<void> pauseVerification() async {
    if (_state != SdkLifecycleState.collecting) return;
    try {
      await _collector?.stop();
    } catch (_) {
      // best-effort
    }
    _pausedAt = DateTime.now();
    _state = SdkLifecycleState.paused;
  }

  Future<void> resumeVerification() async {
    if (_state != SdkLifecycleState.paused) return;
    if (_activeVerificationId == null || _activeLocationCode == null) {
      throw AddressIQException(
        'NO_ACTIVE_SESSION',
        'resumeVerification: no active session to resume',
      );
    }
    await _beginCollection(_activeLocationCode!, _activeVerificationId!);
    _pausedAt = null;
    _state = SdkLifecycleState.collecting;
  }

  Future<Map<String, dynamic>> sync() async {
    return const {'flushed': 0};
  }

  Future<void> logout() async {
    final repo = _repository;
    await pauseVerification();
    if (repo != null && _user != null) {
      try {
        await repo.invalidateSession(
          appUserId: _user!.appUserId,
          verificationCode: _activeVerificationId,
        );
      } catch (_) {
        // best-effort
      }
    }
    _collector = null;
    _user = null;
    _activeVerificationId = null;
    _activeLocationCode = null;
    _pausedAt = null;
    _state = SdkLifecycleState.terminated;
  }

  Future<void> reset() async {
    try {
      await _collector?.stop();
    } catch (_) {
      // best-effort
    }
    _collector = null;
    _user = null;
    _activeVerificationId = null;
    _activeLocationCode = null;
    _pausedAt = null;
    _state = SdkLifecycleState.uninitialized;
    _config = null;
    _repository = null;
  }

  /// Cross-SDK contract §1 / §4: returns the current OS permission grant
  /// state for foreground location, background location, and
  /// notifications. Mirrors the iOS / Android / RN shape exactly so
  /// host apps can render a consistent permissions UI across SDKs.
  ///
  /// Values are drawn from `{GRANTED, DENIED, NOT_DETERMINED, BLOCKED,
  /// UNAVAILABLE}`. Uses `geolocator` for the location permissions
  /// (already a peer dependency); notifications surface as
  /// `NOT_DETERMINED` because Flutter SDKs don't bundle a notification
  /// plugin — partners can layer `permission_handler` if they need it.
  /// Drive the OS permission prompt and return the final state.
  ///
  /// Cross-SDK contract §0 (Permission Trigger Ownership): the app
  /// decides *when* verification begins; the SDK owns every step
  /// after that. Partners pass the trigger; this method drives the
  /// `geolocator` prompt chain.
  ///
  /// On Android 10+, geolocator handles the `whileInUse` → `always`
  /// chain natively when the host app's manifest declares
  /// `ACCESS_BACKGROUND_LOCATION`. iOS sequences
  /// `requestWhenInUseAuthorization` → `requestAlwaysAuthorization`
  /// automatically.
  ///
  /// Notifications are not requested — partners hosting Flutter SDKs
  /// typically already wire `flutter_local_notifications` /
  /// `firebase_messaging`. Surfaced as `NOT_DETERMINED` in the state
  /// map; partners requesting it themselves can re-check after.
  ///
  /// Returns the same shape as [getPermissionState].
  Future<Map<String, String>> requestPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const {
        'foregroundLocation': 'UNAVAILABLE',
        'backgroundLocation': 'UNAVAILABLE',
        'notifications': 'NOT_DETERMINED',
      };
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // For `whileInUse`, geolocator already triggers the always-prompt
    // chain on supported platforms. We re-check the live state below.
    if (permission == LocationPermission.whileInUse) {
      // Best-effort upgrade attempt — succeeds when Info.plist /
      // AndroidManifest declares background permission AND the user
      // grants it. If the platform doesn't prompt for upgrade, the
      // call returns immediately with the same state.
      try {
        permission = await Geolocator.requestPermission();
      } catch (_) {
        // Some geolocator versions throw if re-requesting; ignore.
      }
    }

    return _permissionToStateMap(permission);
  }

  /// Drive the OS toward the combination address verification needs: precise
  /// (full accuracy) + background/Always. Mirrors the native iOS/Android SDKs'
  /// `requestPreciseAndAlways`. Runs the whileInUse→Always chain, then — on
  /// iOS 14+ — requests **temporary full accuracy** if the user granted only
  /// approximate location. Returns the final permission snapshot.
  ///
  /// `purposeKey` must match an entry in the host app's Info.plist
  /// `NSLocationTemporaryUsageDescriptionDictionary`.
  Future<Map<String, String>> requestPreciseAndAlways({
    String purposeKey = 'AddressVerification',
  }) async {
    final state = await requestPermissions();
    try {
      if (await Geolocator.getLocationAccuracy() == LocationAccuracyStatus.reduced) {
        await Geolocator.requestTemporaryFullAccuracy(purposeKey: purposeKey);
      }
    } catch (_) {
      // Accuracy authorization not supported on this platform/version — ignore.
    }
    return state;
  }

  /// Deep-link to the host app's Settings page so the user can
  /// re-enable a permanently-denied permission. The OS will not
  /// re-prompt until they toggle the grant manually.
  ///
  /// Returns `true` if the settings UI opened.
  Future<bool> openSettings() async {
    return Geolocator.openAppSettings();
  }

  /// Whether the SDK can still trigger the OS prompt. Returns `true`
  /// only when the location permission state is `denied` (one prior
  /// denial, OS still allows another prompt). After `deniedForever`,
  /// callers must deep-link to settings via [openSettings].
  Future<bool> canRequestPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.denied;
  }

  Map<String, String> _permissionToStateMap(LocationPermission permission) {
    final fg = switch (permission) {
      LocationPermission.always || LocationPermission.whileInUse => 'GRANTED',
      LocationPermission.denied => 'DENIED',
      LocationPermission.deniedForever => 'BLOCKED',
      LocationPermission.unableToDetermine => 'UNAVAILABLE',
    };
    final bg = switch (permission) {
      LocationPermission.always => 'GRANTED',
      LocationPermission.whileInUse => 'DENIED',
      LocationPermission.denied => 'DENIED',
      LocationPermission.deniedForever => 'BLOCKED',
      LocationPermission.unableToDetermine => 'UNAVAILABLE',
    };
    return {
      'foregroundLocation': fg,
      'backgroundLocation': bg,
      'notifications': 'NOT_DETERMINED',
    };
  }

  Future<Map<String, String>> getPermissionState() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const {
        'foregroundLocation': 'UNAVAILABLE',
        'backgroundLocation': 'UNAVAILABLE',
        'notifications': 'NOT_DETERMINED',
      };
    }

    final permission = await Geolocator.checkPermission();
    final fg = switch (permission) {
      LocationPermission.always || LocationPermission.whileInUse => 'GRANTED',
      LocationPermission.denied => 'NOT_DETERMINED',
      LocationPermission.deniedForever => 'BLOCKED',
      LocationPermission.unableToDetermine => 'UNAVAILABLE',
    };

    final bg = switch (permission) {
      LocationPermission.always => 'GRANTED',
      LocationPermission.whileInUse => 'DENIED',
      LocationPermission.denied => 'NOT_DETERMINED',
      LocationPermission.deniedForever => 'BLOCKED',
      LocationPermission.unableToDetermine => 'UNAVAILABLE',
    };

    return {
      'foregroundLocation': fg,
      'backgroundLocation': bg,
      'notifications': 'NOT_DETERMINED',
    };
  }

  VerificationLifecycleState getVerificationState() {
    return VerificationLifecycleState(
      state: _state,
      appUserId: _user?.appUserId,
      verificationId: _activeVerificationId,
      locationCode: _activeLocationCode,
      pausedFor: _pausedAt != null ? DateTime.now().difference(_pausedAt!) : null,
    );
  }

  /// Internal helper — startVerification paths use this to mark COLLECTING.
  void markActiveSession(String locationCode, String verificationId) {
    _activeLocationCode = locationCode;
    _activeVerificationId = verificationId;
    _state = SdkLifecycleState.collecting;
    _pausedAt = null;
  }

  // ─── Internal ───────────────────────────────────────────────────────────

  VerificationRepository _requireInitialized() {
    final repo = _repository;
    if (repo == null) {
      throw AddressIQException(
        'SDK_NOT_INITIALIZED',
        'AddressIQ.initialize must be called before any other method',
      );
    }
    return repo;
  }

  Future<Map<String, dynamic>> _runStart(
    Future<Map<String, dynamic>> Function() runner,
    String locationCode,
  ) async {
    // PERMISSION_DENIED gate (contract §0/§4): the SDK owns every step
    // after the host triggers a start, including refusing to start when
    // location permission is not granted both in foreground and
    // background. Mirrors the RN `assertReadyForVerificationStart` gate.
    final permissions = await getPermissionState();
    if (permissions['foregroundLocation'] != 'GRANTED' ||
        permissions['backgroundLocation'] != 'GRANTED') {
      throw AddressIQException(
        'PERMISSION_DENIED',
        'Foreground and background location permissions are required before starting verification',
      );
    }

    try {
      final res = await runner();
      final code = res['verificationCode']?.toString();
      if (code != null) {
        markActiveSession(locationCode, code);
        // Begin OS-level collection (geofence + background + telemetry
        // flush) via the shared helper the Collect UI widget uses too.
        // Best-effort: never fails the start.
        await _beginCollection(locationCode, code);
      }
      return res;
    } on SdkError catch (e) {
      throw AddressIQException(e.code, e.message);
    }
  }

  /// Shared collection wiring used by the imperative start* path. Builds
  /// a data-plane [AddressIQApi] from the active config (event ingest is
  /// authenticated with `x-api-key`, so no widget session token is
  /// needed) and starts background collection keyed on the public codes.
  Future<void> _beginCollection(
    String locationCode,
    String verificationCode,
  ) async {
    final config = _config;
    if (config == null) return;
    try {
      final api = AddressIQApi(
        apiUrl: config.resolvedApiUrl,
        apiKey: config.apiKey,
        sessionToken: '',
      );
      _collector = await startCollectionForVerification(
        api: api,
        locationCode: locationCode,
        verificationCode: verificationCode,
      );
    } catch (e) {
      // Best-effort — a failure to begin collection must not fail the start.
      debugPrint('[AddressIQSDK] _beginCollection failed: $e');
    }
  }
}
