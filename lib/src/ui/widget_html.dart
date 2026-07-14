import 'dart:convert';

import '../api/models.dart';
import '../generated/build_config.dart';
import 'theme.dart';

/// How the verify WebView obtains the widget JS.
///
/// The SRI-pinned CDN copy is the ONLY source. The SDK no longer vendors a
/// bundled widget:
///
///  * The widget is published to `{cdnBaseUrl}/v{x.y.z}/iqcollect.js` — an
///    IMMUTABLE, version-addressed path. That immutability is what makes a
///    Subresource-Integrity pin meaningful: `kWidgetIntegrity` describes the
///    exact bytes at that exact path, so the CDN cannot swap them under us.
///    Both WKWebView (WebKit) and Android WebView (Chromium) enforce SRI, so a
///    tampered bundle refuses to execute — the script tag is not a blind
///    "fetch and run whatever the host returns".
///  * `development` is NOT excluded. It used to inline a vendored asset and never
///    fetch, which meant the CDN, the SRI check, and the failure path were only
///    ever exercised in staging and production. Now a dev build loads the same
///    pinned bundle as everything else.
///  * There is NO fallback. A CDN outage, an offline device, or an SRI mismatch
///    is a HARD FAILURE: `onerror` reports `WIDGET_LOAD_FAILED` through the flow's
///    error callback rather than leaving a blank WebView. Verification now depends
///    on the CDN being reachable.
///  * With no usable pin we still FAIL CLOSED — quietly fetching an unpinned
///    script alongside the session config would turn a packaging bug into remote
///    code execution.
///
/// A widget URL override — `config.widgetUrl`, or the `ADDRESSIQ_DEV_WIDGET_URL`
/// dart-define — takes precedence over the CDN, but ONLY in `development`;
/// supplied with any other deployment it throws. It is UNPINNED, which is why it
/// exists: a widget you are actively rebuilding cannot satisfy a fixed SRI hash.
/// See `resolveWidgetUrl` in `lib/src/api/deployment.dart`.
const String widgetPinMissingMessage =
    'AddressIQ: no CDN widget version/integrity is baked into addressiq_sdk and no '
    'config.widgetUrl override was supplied, so there is nothing safe to load. This '
    'is a packaging bug — the SDK will not load an unpinned script from a remote '
    'host. (The SDK no longer ships a bundled widget; the SRI-pinned CDN copy is '
    'the only source.)';

/// Error code reported when the pinned CDN widget fails to load — a CDN outage,
/// an offline device, or an SRI mismatch. There is no fallback, so this is
/// terminal for the flow.
const String widgetLoadFailedCode = 'WIDGET_LOAD_FAILED';

/// True when the baked constants allow the SRI-pinned CDN load for [config].
///
/// `development` is no longer excluded — see the note above. [widgetVersion] /
/// [widgetIntegrity] default to the baked constants; they are parameters only so
/// tests can exercise both sides of the switch.
bool cdnWidgetEnabled(
  AddressIQConfig config, {
  String widgetVersion = kWidgetVersion,
  String widgetIntegrity = kWidgetIntegrity,
}) =>
    config.resolvedCdnUrl.isNotEmpty &&
    widgetVersion.isNotEmpty &&
    widgetIntegrity.isNotEmpty;

/// The immutable, version-addressed CDN URL of the widget for [config].
String cdnWidgetUrl(
  AddressIQConfig config, {
  String widgetVersion = kWidgetVersion,
}) =>
    '${config.resolvedCdnUrl}/v$widgetVersion/iqcollect.js';

/// Builds the WebView document. [platform] is `'ios'` or `'android'`.
///
/// Throws [StateError] when there is no usable widget pin and no override — see
/// [widgetPinMissingMessage].
String buildWidgetHtml({
  required AddressIQConfig config,
  required AddressIQTheme theme,
  required String platform,
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
    // The pinned CDN copy is the ONLY source — there is no vendored fallback.
    // A CDN outage, an offline device, or an SRI mismatch all land on `onerror`,
    // which reports through the existing bridge contract
    // ({kind:'event', name:'error'} → BridgeRouter → onFailed) so the integrator
    // sees $widgetLoadFailedCode instead of a blank WebView.
    widgetScript = '''
<script>
  function __iqWidgetLoadFailed() {
    var msg = {
      kind: 'event',
      name: 'error',
      payload: {
        code: '$widgetLoadFailedCode',
        message: 'AddressIQ: the widget could not be loaded from the CDN. This is '
          + 'a CDN outage, no network, or a Subresource-Integrity mismatch. The SDK '
          + 'ships no bundled copy, so there is nothing to fall back to.'
      }
    };
    try { window.AddressIQFlutter.postMessage(JSON.stringify(msg)); } catch (e) {}
  }
</script>
<script src="${cdnWidgetUrl(config, widgetVersion: widgetVersion)}" integrity="$widgetIntegrity" crossorigin="anonymous" onerror="__iqWidgetLoadFailed()"></script>''';
  } else {
    throw StateError(widgetPinMissingMessage);
  }

  return '''
<!doctype html><html><head>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
<style>html,body{margin:0;height:100%;background:#fff}#mount{min-height:100%}</style>
</head><body>
<div id="mount"></div>
$widgetScript
<script>
  // Guarded: if the widget script failed, `window.AddressIQ` is undefined and an
  // unguarded `new` here would throw an opaque JS error that masks the
  // $widgetLoadFailedCode we already reported from onerror.
  if (window.AddressIQ && window.AddressIQ.IQCollect) {
    var cfg = $cfg;
    var c = new window.AddressIQ.IQCollect(document.getElementById('mount'), cfg);
    c.open();
  }
</script>
</body></html>
''';
}
