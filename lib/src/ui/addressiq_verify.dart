import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/models.dart';
import '../lifecycle/addressiq.dart' show AddressIQ;
import 'bridge_router.dart';
import 'theme.dart';
import 'widget_html.dart';

/// Full-screen address verification flow.
///
/// The UI is now the **shared AddressIQ web widget** (single cross-platform
/// source of truth) hosted in a [WebView]. This Flutter shell owns only what a
/// webview cannot: the location permission prompt and the fix, bridged to the
/// widget.
///
/// Usage:
/// ```dart
/// AddressIQVerify(
///   config: AddressIQConfig(
///     apiKey: 'fsp_...',
///     deployment: 'production',
///     sessionToken: '...',
///     appUserId: 'cust_123',
///   ),
///   onComplete: (result) { },
///   onCancel: () { },
/// )
/// ```
class AddressIQVerify extends StatefulWidget {
  final AddressIQConfig config;
  final AddressIQTheme theme;

  /// Called when the address is collected or an existing address's verification
  /// is started. The host owns any follow-up.
  final void Function(CollectResult result)? onComplete;
  final VoidCallback? onCancel;
  final void Function(Object error)? onError;
  final AddressData? initialAddress;

  const AddressIQVerify({
    super.key,
    required this.config,
    this.theme = const AddressIQTheme(),
    this.onComplete,
    this.onCancel,
    this.onError,
    this.initialAddress,
  });

  @override
  State<AddressIQVerify> createState() => _AddressIQVerifyState();
}

class _AddressIQVerifyState extends State<AddressIQVerify> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.theme.background)
      // The web HostBridge posts to `window.AddressIQFlutter.postMessage(JSON)`.
      ..addJavaScriptChannel('AddressIQFlutter', onMessageReceived: _onMessage);
    _loadWidget();
  }

  Future<void> _loadWidget() async {
    // The widget is loaded CDN-first with an SRI pin, with the bundled asset as
    // the offline/outage fallback — see widget_html.dart for the full rationale.
    String? bundled;
    try {
      bundled = await rootBundle.loadString('packages/addressiq_sdk/assets/iqcollect.js');
    } catch (_) {
      bundled = null;
    }
    if (!mounted) return;
    // Fail closed: with no bundled asset, no baked CDN pin and no explicit
    // override there is nothing safe to load.
    if (bundled == null &&
        widget.config.widgetUrl == null &&
        !cdnWidgetEnabled(widget.config)) {
      widget.onError?.call(StateError(widgetBundleMissingMessage));
      return;
    }
    await _controller.loadHtmlString(_buildHtml(bundled));
  }

  void _onMessage(JavaScriptMessage message) {
    routeBridgeMessage(
      message.message,
      BridgeSinks(
        onCompleted: (result) => widget.onComplete?.call(result),
        onCancelled: () => widget.onCancel?.call(),
        onFailed: (error) => widget.onError?.call(error),
        onLocationRequest: (id) => _provideLocation(id),
        onPermissionRequest: (id) => _requestPermission(id),
        onGetPermissionState: (id) => _getPermissionState(id),
        onOpenSettings: (id) => _openSettings(id),
        onPermissionStatusRequest: (id) => _providePermissionStatus(id),
        reject: (id, code, message) => _reject(id, code, message),
      ),
    );
  }

  /// Read the current grant WITHOUT prompting — the Settings screen polls this to
  /// detect Always + Precise after the user returns from the OS Settings app.
  Future<void> _getPermissionState(String id) async {
    final state = await AddressIQ.instance.getPermissionState();
    var precise = true;
    try {
      precise = (await Geolocator.getLocationAccuracy()) == LocationAccuracyStatus.precise;
    } catch (_) {
      // Accuracy API unavailable (older OS) — treat as precise.
    }
    _resolveJson(id, jsonEncode({
      'foreground': state['foregroundLocation'] == 'GRANTED' && precise,
      'background': state['backgroundLocation'] == 'GRANTED',
    }));
  }

  Future<void> _openSettings(String id) async {
    try {
      await AddressIQ.instance.openSettings();
    } catch (_) {
      // ignore — user can still enable it manually; we detect on return
    }
    _resolveJson(id, 'true');
  }

  Future<void> _providePermissionStatus(String id) async {
    final ok = await Geolocator.checkPermission();
    _resolve(id, _webPermission(ok));
  }

  /// Run the Always + Precise permission prompt (the OS dialog appears here, on
  /// the "Verify where you currently live" screen). Resolves with whether
  /// foreground was granted; the web flow proceeds either way.
  Future<void> _requestPermission(String id) async {
    try {
      final state = await AddressIQ.instance.requestPreciseAndAlways();
      _resolveJson(id, jsonEncode({
        'foreground': state['foregroundLocation'] == 'GRANTED',
        'background': state['backgroundLocation'] == 'GRANTED',
      }));
    } catch (e) {
      _reject(id, 'PERMISSION_ERROR', e.toString());
    }
  }

  /// Ensure permission (geolocator drives the whileInUse→always prompt), then
  /// return a one-shot fix. The native prompt appears here.
  Future<void> _provideLocation(String id) async {
    try {
      // Request precise + Always (the combination verification needs), not just
      // a basic whileInUse prompt — mirrors the native iOS/Android shells.
      final state = await AddressIQ.instance.requestPreciseAndAlways();
      if (state['foregroundLocation'] != 'GRANTED') {
        _reject(id, 'PERMISSION_DENIED', 'Location permission not granted');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      _resolveJson(id, jsonEncode({
        'lat': pos.latitude,
        'lon': pos.longitude,
        'accuracy': pos.accuracy,
      }));
    } catch (e) {
      _reject(id, 'LOCATION_UNAVAILABLE', e.toString());
    }
  }

  // ── native → JS ──

  void _resolve(String id, String stringResult) =>
      _resolveJson(id, jsonEncode(stringResult));

  void _resolveJson(String id, String jsonResult) => _controller.runJavaScript(
        'window.AddressIQBridge && window.AddressIQBridge.resolve(${jsonEncode(id)}, $jsonResult);',
      );

  void _reject(String id, String code, String message) => _controller.runJavaScript(
        'window.AddressIQBridge && window.AddressIQBridge.reject('
        '${jsonEncode(id)}, ${jsonEncode({'code': code, 'message': message})});',
      );

  String _webPermission(LocationPermission p) => switch (p) {
        LocationPermission.always || LocationPermission.whileInUse => 'granted',
        LocationPermission.denied => 'prompt',
        LocationPermission.deniedForever => 'denied',
        _ => 'unknown',
      };

  String _buildHtml(String? bundledJs) => buildWidgetHtml(
        config: widget.config,
        theme: widget.theme,
        platform: Platform.isIOS ? 'ios' : 'android',
        bundledJs: bundledJs,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.background,
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
