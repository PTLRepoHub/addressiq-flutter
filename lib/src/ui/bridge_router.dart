import 'dart:convert';
import '../api/models.dart';

/// Sinks the [routeBridgeMessage] dispatcher calls. Kept UI/plugin-free so the
/// wire mapping is `dart test`-able without a real WebView.
class BridgeSinks {
  final void Function(CollectResult result) onCompleted;
  final void Function() onCancelled;
  final void Function(Object error) onFailed;

  /// Async location request — the caller runs the prompt + fix, then replies by id.
  final void Function(String id) onLocationRequest;

  /// Async Always+Precise permission prompt — the caller runs it, then replies by id.
  final void Function(String id) onPermissionRequest;

  /// Read current grant WITHOUT prompting — caller replies { foreground, background } by id.
  final void Function(String id) onGetPermissionState;

  /// Open the OS app-settings page — caller replies by id.
  final void Function(String id) onOpenSettings;

  /// Async permission-status request — the caller reads permission and replies by id.
  final void Function(String id) onPermissionStatusRequest;

  final void Function(String id, String code, String message) reject;

  const BridgeSinks({
    required this.onCompleted,
    required this.onCancelled,
    required this.onFailed,
    required this.onLocationRequest,
    required this.onPermissionRequest,
    required this.onGetPermissionState,
    required this.onOpenSettings,
    required this.onPermissionStatusRequest,
    required this.reject,
  });
}

/// Decode a `HostBridge` message the shared widget posts and dispatch it.
/// Stays in lockstep with the web bridge and the iOS / Android / RN shells.
///
/// JS → native:
///   { kind: 'event',   name, payload }
///   { kind: 'request', id, action, payload }
void routeBridgeMessage(String raw, BridgeSinks sinks) {
  Map<String, dynamic> msg;
  try {
    msg = jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return;
  }
  final kind = msg['kind'] as String?;
  if (kind == 'event') {
    final name = msg['name'] as String?;
    final p = (msg['payload'] as Map<String, dynamic>?) ?? const {};
    switch (name) {
      case 'addressSelected':
      case 'verificationStarted':
        final geo = p['geoPoint'] as Map<String, dynamic>?;
        sinks.onCompleted(CollectResult(
          locationCode: (p['locationCode'] as String?) ?? '',
          formattedAddress: p['formattedAddress'] as String?,
          lat: (geo?['lat'] as num?)?.toDouble(),
          lon: (geo?['lng'] as num?)?.toDouble(),
          placeId: p['placeId'] as String?,
        ));
        break;
      case 'close':
        sinks.onCancelled();
        break;
      case 'error':
        sinks.onFailed(Exception((p['message'] as String?) ?? 'Widget error'));
        break;
    }
  } else if (kind == 'request') {
    final id = msg['id'] as String?;
    if (id == null) return;
    switch (msg['action'] as String?) {
      case 'getPermissionStatus':
        sinks.onPermissionStatusRequest(id);
        break;
      case 'getLocation':
        sinks.onLocationRequest(id);
        break;
      case 'requestPermission':
        sinks.onPermissionRequest(id);
        break;
      case 'getPermissionState':
        sinks.onGetPermissionState(id);
        break;
      case 'openSettings':
        sinks.onOpenSettings(id);
        break;
      default:
        sinks.reject(id, 'UNKNOWN_ACTION', 'Unsupported action: ${msg['action']}');
    }
  }
}
