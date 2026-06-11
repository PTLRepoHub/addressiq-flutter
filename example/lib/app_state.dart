// Shared sample-app state: the signed-in session + collected addresses.
//
// In-memory only (no persistence) — this is a demo. Mirrors the RN
// example's `SessionData` + `loadAddresses/saveAddress` storage, minus
// AsyncStorage.

import 'package:addressiq_sdk/addressiq.dart';

/// The credentials/identity captured on the Login screen.
class SessionData {
  /// One of the SDK environments: 'sandbox' | 'production' | 'staging' | 'local'.
  final String environment;
  final String appUserId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  const SessionData({
    required this.environment,
    required this.appUserId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  SdkUser toSdkUser() => SdkUser(
        appUserId: appUserId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
}

/// A collected address — the public codes the backend returned from the
/// Collect UI. Used by the Addresses screen for re-verification.
class CollectedAddress {
  final String locationCode;
  final String verificationCode;
  final String status;

  const CollectedAddress({
    required this.locationCode,
    required this.verificationCode,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'locationCode': locationCode,
        'verificationCode': verificationCode,
        'status': status,
      };
}

/// Process-wide store for the demo. The address list survives screen
/// navigation within a session.
class AppStore {
  AppStore._();
  static final AppStore instance = AppStore._();

  final List<CollectedAddress> addresses = <CollectedAddress>[];

  /// Insert/replace by locationCode (newest first).
  void saveAddress(CollectedAddress address) {
    addresses.removeWhere((a) => a.locationCode == address.locationCode);
    addresses.insert(0, address);
  }

  void clear() => addresses.clear();
}

/// API key per environment. In the RN example this comes from a
/// `credentials.json`; here it falls back to a `--dart-define` and a
/// sensible sandbox default so the demo runs out of the box.
const _apiKeyOverride = String.fromEnvironment('API_KEY', defaultValue: '');

String apiKeyForEnvironment(String environment) {
  if (_apiKeyOverride.isNotEmpty) return _apiKeyOverride;
  // Demo seed keys — swap via --dart-define=API_KEY=... for real backends.
  return 'aiq_test_demo_bank_seed01';
}

/// Widget session token for the Collect UI (Bearer). Overridable via
/// `--dart-define=SESSION_TOKEN=...`.
const sessionTokenForCollect =
    String.fromEnvironment('SESSION_TOKEN', defaultValue: 'sdk_widget_session_demo');

/// Resolve the API base URL for a given environment, mirroring the SDK's
/// internal env→URL table so the Collect UI (which takes an explicit
/// `apiUrl`) stays consistent with the lifecycle config.
String apiUrlForEnvironment(String environment) {
  const override = String.fromEnvironment('API_URL', defaultValue: '');
  if (override.isNotEmpty) return override;
  switch (environment) {
    case 'production':
      return 'https://api.addressiqpro.com';
    case 'staging':
    case 'sandbox':
      return 'https://api-staging.addressiqpro.com';
    case 'local':
      return 'http://localhost:4000';
    default:
      return 'https://api-staging.addressiqpro.com';
  }
}

const sdkEnvironments = <String>['sandbox', 'production', 'staging', 'local'];
