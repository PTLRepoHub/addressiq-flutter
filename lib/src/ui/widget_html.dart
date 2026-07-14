import 'dart:convert';

import '../api/deployment.dart';
import '../api/models.dart';
import '../generated/build_config.dart';
import 'theme.dart';

/// How the verify WebView obtains the widget JS.
///
/// CDN-first, integrity-pinned, with the bundled copy as a fallback:
///
///  * The widget is published to `{cdnBaseUrl}/v{x.y.z}/iqcollect.js` — an
///    IMMUTABLE, version-addressed path. That immutability is what makes a
///    Subresource-Integrity pin meaningful: `kWidgetIntegrity` describes the
///    exact bytes at that exact path, so the CDN cannot swap them under us.
///    Both WKWebView (WebKit) and Android WebView (Chromium) enforce SRI, so a
///    tampered bundle refuses to execute and fires `onerror` — the script tag
///    is not a blind "fetch and run whatever the host returns".
///  * The bundled asset (`assets/iqcollect.js`) is STILL embedded in the page
///    as the fallback: `__iqWidgetFallback()` is defined before the remote
///    <script> and injects it inline if the remote one fails to load. That
///    covers a CDN outage, an offline device, and an SRI mismatch.
///  * With no CDN preconditions (development, or an unbaked version/integrity)
///    the bundled widget is inlined directly, exactly as before.
///  * With neither a bundle nor a usable CDN pin we FAIL CLOSED — quietly
///    fetching an unpinned script alongside the session config would turn a
///    packaging bug into remote code execution.
///
/// A widget URL override — `config.widgetUrl`, or the `ADDRESSIQ_WIDGET_URL`
/// dart-define — takes precedence over everything above, but ONLY in
/// `development`; supplied with any other deployment it throws. It serves a local
/// bundle while iterating on the widget, and is also the only way to exercise the
/// remote-load path from a dev build (development otherwise inlines the asset and
/// never fetches). See `resolveWidgetUrl` in `lib/src/api/deployment.dart`.
const String widgetBundleMissingMessage =
    'AddressIQ: the bundled widget (assets/iqcollect.js) is missing from '
    'addressiq_sdk, no CDN widget version/integrity is baked in, and no '
    'config.widgetUrl override was supplied. This is a packaging bug; the SDK '
    'will not load an unpinned script from a remote host.';

/// True when the baked constants allow the SRI-pinned CDN load for [config].
///
/// `development` is excluded: its "CDN" is the local dev host, which does not
/// publish versioned, integrity-matching bundles.
/// [widgetVersion]/[widgetIntegrity] default to the baked constants; they are
/// parameters only so tests can exercise both sides of the switch.
bool cdnWidgetEnabled(
  AddressIQConfig config, {
  String widgetVersion = kWidgetVersion,
  String widgetIntegrity = kWidgetIntegrity,
}) =>
    config.deployment != 'development' &&
    config.resolvedCdnUrl.isNotEmpty &&
    widgetVersion.isNotEmpty &&
    widgetIntegrity.isNotEmpty;

/// The immutable, version-addressed CDN URL of the widget for [config].
String cdnWidgetUrl(
  AddressIQConfig config, {
  String widgetVersion = kWidgetVersion,
}) =>
    '${config.resolvedCdnUrl}/v$widgetVersion/iqcollect.js';

/// Builds the WebView document. [bundledJs] is the packaged `assets/iqcollect.js`
/// (null when it could not be loaded). [platform] is `'ios'` or `'android'`.
///
/// Throws [StateError] when there is nothing safe to load (see
/// [widgetBundleMissingMessage]).
String buildWidgetHtml({
  required AddressIQConfig config,
  required AddressIQTheme theme,
  required String platform,
  String? bundledJs,
  String widgetVersion = kWidgetVersion,
  String widgetIntegrity = kWidgetIntegrity,
}) {
  // Business identity (name/logo/colour) is fetched by the widget from the
  // backend (tenant behind the API key). Only forward a client-supplied
  // fallback name (with the app's theme colour) when the integrator set one.
  final cfgMap = <String, dynamic>{
    'apiKey': config.apiKey,
    'apiUrl': config.resolvedApiUrl,
    'appUserId': config.appUserId ?? config.sessionToken,
    // Drives the platform-specific "Location permission" Settings screen.
    'platform': platform,
  };
  // Development-only Maps key override (ADDRESSIQ_GOOGLE_MAPS_KEY). Normally the
  // widget provisions its own key — it fetches one from GET /api/v1/widget/config
  // and falls back to the key baked into the bundle — so this is absent in every
  // shipped build. It covers the case that breaks: a local backend with no Maps
  // key configured. resolveGoogleMapsKey throws outside `development`.
  //
  // NOTE: the widget only starts honouring this once addressiq-web accepts
  // `googleMapsApiKey` on IQCollectConfig (today it reads only the remote value
  // or its own baked literal — flow.ts:111) AND that build is re-vendored here by
  // the fanout. Until then the field rides the wire and is ignored; the hosts
  // above take effect immediately.
  final devMapsKey = resolveGoogleMapsKey(config.deployment);
  if (devMapsKey != null) {
    cfgMap['googleMapsApiKey'] = devMapsKey;
  }
  if (config.businessName != null) {
    // .value is the compatible API for the package's Flutter >=3.10 floor
    // (toARGB32 only exists in 3.27+).
    // ignore: deprecated_member_use
    final argb = theme.primary.value;
    final primaryHex = '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    cfgMap['business'] = {
      'displayName': config.businessName,
      'primaryColor': primaryHex,
    };
  }
  final cfg = jsonEncode(cfgMap);

  final widgetUrl = config.resolvedWidgetUrl;
  final String widgetScript;
  if (widgetUrl != null) {
    // Development-only override (config.widgetUrl or --dart-define) — wins over
    // both the CDN and the bundle. Deliberately unpinned: the bytes change on
    // every widget rebuild, so an SRI hash would be meaningless. resolveWidgetUrl
    // throws outside `development`, which is what keeps that safe.
    widgetScript = '<script src="$widgetUrl"></script>';
  } else if (cdnWidgetEnabled(config,
      widgetVersion: widgetVersion, widgetIntegrity: widgetIntegrity)) {
    widgetScript = '''
<script>
  function __iqWidgetFallback() {
    // The remote (SRI-pinned) widget failed to load — CDN outage, offline, or
    // an integrity mismatch. Fall back to the bundle we shipped.
    ${_fallbackBody(bundledJs)}
  }
</script>
<script src="${cdnWidgetUrl(config, widgetVersion: widgetVersion)}" integrity="$widgetIntegrity" crossorigin="anonymous" onerror="__iqWidgetFallback()"></script>''';
  } else if (bundledJs != null) {
    widgetScript = '<script>${_scriptSafe(bundledJs)}</script>';
  } else {
    throw StateError(widgetBundleMissingMessage);
  }

  return '''
<!doctype html><html><head>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
<style>html,body{margin:0;height:100%;background:#fff}#mount{min-height:100%}</style>
</head><body>
<div id="mount"></div>
$widgetScript
<script>
  var cfg = $cfg;
  var c = new window.AddressIQ.IQCollect(document.getElementById('mount'), cfg);
  c.open();
</script>
</body></html>
''';
}

/// Body of `__iqWidgetFallback()`. Injects the bundled JS synchronously so the
/// boot script below it still finds `window.AddressIQ`.
String _fallbackBody(String? bundledJs) {
  if (bundledJs == null) {
    // The CDN pin is our only source. Nothing to fall back to; surface it
    // rather than failing silently.
    return "console.error('AddressIQ: widget failed to load and no bundled "
        "fallback is packaged.');";
  }
  return '''
var s = document.createElement('script');
    s.text = ${_scriptSafe(jsonEncode(bundledJs))};
    document.head.appendChild(s);''';
}

/// Escapes `</` so the bundle cannot terminate the enclosing `<script>` block.
String _scriptSafe(String js) => js.replaceAll('</', r'<\/');
