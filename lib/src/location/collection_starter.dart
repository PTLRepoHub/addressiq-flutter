// Shared wiring for starting OS-level background collection after a
// verification session is created — used by both the Collect UI widget
// (`AddressIQVerify`) and the imperative singleton (`AddressIQ.instance`).
//
// Mirrors the RN reference `startCollectionForVerification` in
// addressiq-react-native/src/collection.ts: best-effort geofence +
// background location + telemetry flush, keyed on the public
// `locationCode` / `verificationCode` the backend returns.

import 'package:flutter/foundation.dart';

import '../api/addressiq_api.dart';
import 'location_collector.dart';

/// Begin background location collection for an active verification.
///
/// Best-effort: never throws. If permissions are missing or collection
/// can't start, it logs and returns the (non-started) collector so the
/// caller can decide whether to retain it. The corrected contract code
/// fields are passed through: [locationCode] and [verificationCode].
Future<LocationCollector?> startCollectionForVerification({
  required AddressIQApi api,
  required String locationCode,
  required String verificationCode,
}) async {
  try {
    final collector = LocationCollector(
      api: api,
      locationId: locationCode,
      verificationId: verificationCode,
    );
    await collector.start();
    return collector;
  } catch (e) {
    debugPrint('[AddressIQSDK] Background collection failed: $e');
    return null;
  }
}
