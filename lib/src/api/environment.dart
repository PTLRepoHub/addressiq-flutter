import 'dart:io' show Platform;

import '../generated/build_config.dart';

/// Resolves the API base URL for an AddressIQ [environment].
///
/// Integrators never pass a URL — production and sandbox/staging auto-resolve
/// to the managed backends. The `development` value targets a locally-running
/// backend on port 3355; Android emulators automatically use the host-loopback
/// alias `10.0.2.2` while everything else uses `localhost`.
String resolveEnvironmentApiUrl(String environment) {
  switch (environment) {
    case 'production':
      // Baked into the published package at publish time (see build_config.dart).
      return kBuildApiUrl;
    case 'staging':
    case 'sandbox':
      return 'https://api-staging.addressiqpro.com';
    case 'development':
      return Platform.isAndroid
          ? 'http://10.0.2.2:3355'
          : 'http://localhost:3355';
    default:
      return 'https://api.addressiqpro.com';
  }
}
