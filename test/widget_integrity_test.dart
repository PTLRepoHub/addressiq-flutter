// Guards the vendored widget bundle against drifting from the SRI hash we pin.
//
// `.widget-integrity` describes the bytes the CDN serves at
// `{cdn}/v{.widget-version}/iqcollect.js`, and `assets/iqcollect.js` is supposed
// to be exactly those bytes — addressiq-web's fanout workflow rewrites both in
// the same PR. If they drift apart, the SDK's *fallback* stops being the widget
// it claims to ship: on a CDN outage, an offline device, or an SRI mismatch, the
// user silently gets a different build.
//
// That drift really happened. Android, iOS and React Native all vendored the
// v0.5.3 bytes; Flutter vendored a different build (one compiled without the
// baked Google Maps key), while still pinning the v0.5.3 hash. Nothing caught it,
// because `development` inlines the asset and never verifies it, and the CDN path
// verifies the *remote* bytes rather than the local ones — so no test, on any
// platform, ever hashed the file we ship.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('vendored widget bundle', () {
    test('assets/iqcollect.js matches the SRI hash in .widget-integrity', () {
      final asset = File('assets/iqcollect.js');
      final pinFile = File('.widget-integrity');

      expect(asset.existsSync(), isTrue,
          reason: 'assets/iqcollect.js is the offline/outage fallback — it must ship');

      if (!pinFile.existsSync() || pinFile.readAsStringSync().trim().isEmpty) {
        // Pre-fanout state: no pin baked yet, so the CDN path is disabled and
        // there is nothing to agree with. Not a failure.
        return;
      }

      final pin = pinFile.readAsStringSync().trim();
      final digest = sha384.convert(asset.readAsBytesSync());
      final actual = 'sha384-${base64.encode(digest.bytes)}';

      expect(
        actual,
        pin,
        reason: 'The vendored widget bundle is NOT the build that .widget-integrity '
            'pins. The CDN would serve one set of bytes and the offline fallback '
            'would run another. Re-vendor assets/iqcollect.js from the published '
            '${File('.widget-version').existsSync() ? File('.widget-version').readAsStringSync().trim() : 'pinned'} '
            'bundle, or re-run the fanout.',
      );
    });
  });
}
