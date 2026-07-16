import 'dart:io' show Platform;

import '../generated/build_config.dart';

/// The AddressIQ *deployment* an SDK build talks to — i.e. WHICH HOSTS.
///
/// This is not the tenant's mode. Sandbox-vs-production is a property of the API
/// KEY (`aiq_test_…` resolves to a SANDBOX App row server-side, `aiq_live_…` to a
/// PRODUCTION one) and is decided entirely by the backend on every request — the
/// SDK neither sends it nor can influence it. The two axes are orthogonal: a test
/// key against the production deployment is still sandbox; a live key against the
/// staging deployment is still production-mode data.
///
/// `'sandbox'` was previously accepted here as an alias for `'staging'`, which
/// asserted that sandbox was a deployment. It is not, and it is now rejected.
const Set<String> kDeployments = {'production', 'staging', 'development'};

/// Local development backend, running on the host machine. Android emulators
/// reach it via the host-loopback alias `10.0.2.2`; everything else uses
/// `localhost`. Deliberately NOT baked from CI — it is a local-only concern.
/// Never ship a build configured for `development`.
String _developmentUrl() =>
    Platform.isAndroid ? 'http://10.0.2.2:4000' : 'http://localhost:4000';

/// Message for the [ArgumentError] thrown on an unrecognised deployment.
String unknownDeploymentMessage(String deployment) {
  final hint = deployment == 'sandbox'
      ? ' "sandbox" is not a deployment — it is a tenant mode, and it is chosen by '
          'the API key you paste (aiq_test_… for sandbox, aiq_live_… for production), '
          'not by this field. If you meant the pre-production HOSTS, use "staging"; '
          'otherwise drop this field and use a sandbox key.'
      : '';
  return 'AddressIQ: unknown deployment "$deployment". Expected one of '
      '${kDeployments.join(', ')}.$hint';
}

/// Validates [deployment], throwing [ArgumentError] if it is not one of
/// [kDeployments].
///
/// Deliberately strict. The previous resolvers fell through a `default:` arm to
/// the production hosts, so a typo — or the now-removed `'sandbox'` — would
/// silently point a build at PRODUCTION. Failing loudly is the only safe
/// behaviour for a field that selects which backend receives real user data.
void _assertKnown(String deployment) {
  if (!kDeployments.contains(deployment)) {
    throw ArgumentError.value(
        deployment, 'deployment', unknownDeploymentMessage(deployment));
  }
}

/// Resolves the API base URL for an AddressIQ [deployment].
///
/// Integrators never pass a URL — the SDK owns host resolution. `production` and
/// `staging` are baked in at publish time from the `PROD_ADDRESSIQ_API_BASE_URL` /
/// `STAGING_ADDRESSIQ_API_BASE_URL` GitHub variables (see build_config.dart).
String resolveDeploymentApiUrl(
  String deployment, {
  String envApiUrl = kEnvApiUrl,
}) {
  _assertKnown(deployment);
  final override = _devOverride(deployment, envApiUrl, 'ADDRESSIQ_DEV_API_URL');
  if (override != null) return override;
  switch (deployment) {
    case 'staging':
      return kStagingApiUrl;
    case 'development':
      return _developmentUrl();
    default:
      return kProdApiUrl;
  }
}

/// Resolves the ingest base URL for an AddressIQ [deployment].
///
/// Transit-event batches are posted to a dedicated ingest host rather than the
/// API host. Resolution mirrors [resolveDeploymentApiUrl]; `production` and
/// `staging` are baked from `PROD_ADDRESSIQ_INGEST_BASE_URL` /
/// `STAGING_ADDRESSIQ_INGEST_BASE_URL`.
String resolveDeploymentIngestUrl(
  String deployment, {
  String envIngestUrl = kEnvIngestUrl,
}) {
  _assertKnown(deployment);
  final override =
      _devOverride(deployment, envIngestUrl, 'ADDRESSIQ_DEV_INGEST_URL');
  if (override != null) return override;
  switch (deployment) {
    case 'staging':
      return kStagingIngestUrl;
    case 'development':
      return _developmentUrl();
    default:
      return kProdIngestUrl;
  }
}

/// Resolves the CDN base URL for an AddressIQ [deployment]. Baked from
/// `PROD_ADDRESSIQ_CDN_BASE_URL` / `STAGING_ADDRESSIQ_CDN_BASE_URL`.
///
/// The verify WebView loads the widget from here and NOWHERE ELSE: it requests
/// the immutable, version-addressed `{cdn}/v{x.y.z}/iqcollect.js` with a
/// Subresource-Integrity pin (`kWidgetIntegrity`), so a tampered bundle refuses
/// to execute. The SDK no longer vendors a copy of the widget, so this is the
/// only source — a CDN outage or an SRI mismatch is a hard failure, surfaced as
/// `WIDGET_LOAD_FAILED` rather than silently falling back.
///
/// `development` is NOT excluded any more. It used to inline a bundled asset and
/// never fetch; now it loads the same pinned bundle as everything else, so a dev
/// build finally exercises the CDN + SRI path. Its CDN does NOT resolve to the
/// dev host — the local backend serves no widget — so it defaults to the
/// production CDN and is overridable with `ADDRESSIQ_DEV_CDN_URL` when you are
/// serving a widget build yourself.
String resolveDeploymentCdnUrl(
  String deployment, {
  String envCdnUrl = kEnvCdnUrl,
}) {
  _assertKnown(deployment);
  final override = _devOverride(deployment, envCdnUrl, 'ADDRESSIQ_DEV_CDN_URL');
  if (override != null) return override;
  switch (deployment) {
    case 'staging':
      return kStagingCdnUrl;
    case 'development':
      // Deliberately NOT the dev host: the local backend does not serve
      // /v{x.y.z}/iqcollect.js. Point at the real CDN so a dev build renders with
      // no setup; override with ADDRESSIQ_DEV_CDN_URL to use your own build.
      return kProdCdnUrl;
    default:
      return kProdCdnUrl;
  }
}

// ─── Development-only build-time overrides ──────────────────────────────────
//
// Supplied with --dart-define, e.g.
//
//     flutter run \
//       --dart-define=ADDRESSIQ_DEV_API_URL=http://192.168.1.5:4000
//
// Empty when unset. These are compile-time constants rather than entries in
// build_config.dart: `scripts/bake-build-config.sh` rewrites that file wholesale
// at publish time, so a value parked there would be clobbered — or, worse, leak a
// developer's host into a released package.
//
// They exist because the `development` hosts are otherwise hardcoded literals.
// `10.0.2.2` is an Android-EMULATOR alias for the host machine; a physical device
// cannot reach it, and until now there was nowhere to put a LAN IP — so testing
// against real hardware meant editing SDK source.
//
// Every one of them is honoured ONLY in `development` and throws anywhere else.
// A build-time variable must never be able to redirect a shipped app at an
// arbitrary host, and a security-relevant setting that silently does nothing is
// worse than a loud failure.

const String kEnvApiUrl = String.fromEnvironment('ADDRESSIQ_DEV_API_URL');
const String kEnvIngestUrl = String.fromEnvironment('ADDRESSIQ_DEV_INGEST_URL');

/// CDN base a dev build loads the widget from. Defaults to the production CDN
/// (see [resolveDeploymentCdnUrl]) — set this only when you are serving a widget
/// build yourself:
///
///     cd ../addressiq-web && npx rollup -c && npx serve dist -p 5173
///     --dart-define=ADDRESSIQ_DEV_CDN_URL=http://192.168.1.5:5173
///
/// Note the widget is then loaded from `{this}/v{kWidgetVersion}/iqcollect.js`
/// WITH the SRI pin, so a locally rebuilt widget will fail the integrity check —
/// use [kEnvWidgetUrl] (`ADDRESSIQ_DEV_WIDGET_URL`) for that, which is unpinned.
const String kEnvCdnUrl = String.fromEnvironment('ADDRESSIQ_DEV_CDN_URL');

/// Widget bundle URL supplied at build time. See [resolveWidgetUrl].
const String kEnvWidgetUrl = String.fromEnvironment('ADDRESSIQ_DEV_WIDGET_URL');

/// Message for the [StateError] thrown when a dev-only override is set on a
/// shipped deployment.
String devOverrideNotDevelopmentMessage(String varName, String deployment) =>
    'AddressIQ: $varName is a development-only override, but deployment is '
    '"$deployment". Outside development the SDK resolves its hosts from the '
    'values baked at release — it will not let a build-time variable point a '
    'shipped app at an arbitrary host. Unset $varName, or set '
    'deployment: "development".';

/// Returns [env] when it is set AND [deployment] is `development`; null when
/// unset. Throws [StateError] when it is set on any other deployment.
String? _devOverride(String deployment, String env, String varName) {
  if (env.isEmpty) return null;
  if (deployment != 'development') {
    throw StateError(devOverrideNotDevelopmentMessage(varName, deployment));
  }
  return env;
}

/// Message for the [StateError] thrown by [resolveWidgetUrl] outside development.
String widgetUrlNotDevelopmentMessage(String deployment) =>
    'AddressIQ: the widget URL override is development-only, but deployment is '
    '"$deployment". Outside development the SDK loads the SRI-pinned CDN bundle '
    'or the vendored asset — it will not fetch an unpinned script from an '
    'arbitrary host. Drop the override, or set deployment: "development".';

/// The effective widget bundle override, or null when there is none.
///
/// Serves two development jobs: pointing the WebView at a locally served
/// `dist/iqcollect.js` while iterating on the widget (live reload, no re-vendoring),
/// and pointing it at the *published* CDN URL to exercise the remote-load path —
/// which `development` otherwise never takes, since it inlines the bundled asset.
///
/// Honoured ONLY in `development`, and injected WITHOUT an integrity attribute
/// (the bytes change on every widget rebuild, so a hash would be meaningless).
/// That is precisely why it must not reach staging or production: an unpinned
/// remote script alongside the session config is the remote-code-execution hole
/// the rest of the widget loader fails closed to avoid. Supplied anywhere else it
/// throws rather than being silently dropped — a security-relevant setting that
/// quietly does nothing is worse than a loud failure.
///
/// [configWidgetUrl] (set in code) wins over [envWidgetUrl] (the `--dart-define`).
String? resolveWidgetUrl(
  String deployment,
  String? configWidgetUrl, {
  String envWidgetUrl = kEnvWidgetUrl,
}) {
  final override = (configWidgetUrl != null && configWidgetUrl.isNotEmpty)
      ? configWidgetUrl
      : (envWidgetUrl.isNotEmpty ? envWidgetUrl : null);
  if (override == null) return null;
  if (deployment != 'development') {
    throw StateError(widgetUrlNotDevelopmentMessage(deployment));
  }
  return override;
}
