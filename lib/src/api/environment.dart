import 'dart:io' show Platform;

import '../generated/build_config.dart';

/// Local development backend, running on the host machine. Android emulators
/// reach it via the host-loopback alias `10.0.2.2`; everything else uses
/// `localhost`. Deliberately NOT baked from CI — it is a local-only concern.
/// Never ship a build configured for `development`.
String _developmentUrl() =>
    Platform.isAndroid ? 'http://10.0.2.2:4000' : 'http://localhost:4000';

/// Resolves the API base URL for an AddressIQ [environment].
///
/// Integrators never pass a URL — the SDK owns host resolution. `production`
/// and `staging` are baked in at publish time from the `PROD_ADDRESSIQ_API_BASE_URL` /
/// `STAGING_ADDRESSIQ_API_BASE_URL` GitHub variables (see build_config.dart); anything
/// unrecognised resolves to production.
///
/// `sandbox` is the former name for `staging`, retained as a deprecated alias
/// so existing integrators keep working; it resolves identically.
String resolveEnvironmentApiUrl(String environment) {
  switch (environment) {
    case 'production':
      return kProdApiUrl;
    case 'staging':
    case 'sandbox': // deprecated alias for 'staging'
      return kStagingApiUrl;
    case 'development':
      return _developmentUrl();
    default:
      return kProdApiUrl;
  }
}

/// Resolves the ingest base URL for an AddressIQ [environment].
///
/// Transit-event batches are posted to a dedicated ingest host rather than the
/// API host. Resolution mirrors [resolveEnvironmentApiUrl]; `production` and
/// `staging` are baked from `PROD_ADDRESSIQ_INGEST_BASE_URL` /
/// `STAGING_ADDRESSIQ_INGEST_BASE_URL`.
String resolveEnvironmentIngestUrl(String environment) {
  switch (environment) {
    case 'production':
      return kProdIngestUrl;
    case 'staging':
    case 'sandbox': // deprecated alias for 'staging'
      return kStagingIngestUrl;
    case 'development':
      return _developmentUrl();
    default:
      return kProdIngestUrl;
  }
}

/// Resolves the CDN base URL for an AddressIQ [environment]. Baked from
/// `PROD_ADDRESSIQ_CDN_BASE_URL` / `STAGING_ADDRESSIQ_CDN_BASE_URL`.
///
/// The verify WebView loads the widget from here, CDN-first: it requests the
/// immutable, version-addressed `{cdn}/v{x.y.z}/iqcollect.js` with a
/// Subresource-Integrity pin (`kWidgetIntegrity`), so a tampered bundle refuses
/// to execute. The bundled `assets/iqcollect.js` stays embedded as the fallback
/// for a CDN outage, an offline device, or an SRI mismatch (see
/// `lib/src/ui/widget_html.dart`). `development` resolves to the local host and
/// is excluded from the CDN path — it inlines the bundle.
String resolveEnvironmentCdnUrl(String environment) {
  switch (environment) {
    case 'production':
      return kProdCdnUrl;
    case 'staging':
    case 'sandbox': // deprecated alias for 'staging'
      return kStagingCdnUrl;
    case 'development':
      return _developmentUrl();
    default:
      return kProdCdnUrl;
  }
}
