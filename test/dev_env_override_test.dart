// Development-only build-time overrides for the hosts.
//
// They exist because the `development` hosts are hardcoded literals, and
// `10.0.2.2` is an Android-EMULATOR alias for the host machine — a physical
// device cannot reach it, so testing on real hardware used to mean editing SDK
// source.
//
// The load-bearing property is the gate: an override is honoured ONLY in
// `development` and throws anywhere else. A build-time variable must never be
// able to point a shipped app at an arbitrary host.
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/api/deployment.dart';

const _lan = 'http://192.168.1.5:4000';
const _ingest = 'http://192.168.1.5:5000';
const _cdn = 'http://192.168.1.5:5173';

void main() {
  group('host overrides in development', () {
    test('api url override replaces the 10.0.2.2/localhost literal', () {
      expect(
        resolveDeploymentApiUrl('development', envApiUrl: _lan),
        _lan,
      );
    });

    test('ingest and cdn override independently', () {
      expect(
        resolveDeploymentIngestUrl('development', envIngestUrl: _ingest),
        _ingest,
      );
      expect(
        resolveDeploymentCdnUrl('development', envCdnUrl: _cdn),
        _cdn,
      );
    });

    test('an unset override leaves the default literal untouched', () {
      // The whole point: overriding the API host must not silently drag the
      // ingest or CDN host along with it.
      final api = resolveDeploymentApiUrl('development', envApiUrl: _lan);
      final ingest = resolveDeploymentIngestUrl('development', envIngestUrl: '');
      expect(api, _lan);
      expect(ingest, contains(':4000'));
      expect(ingest, isNot(_lan));
    });
  });

  group('the gate — overrides cannot escape development', () {
    test('an api url override on a shipped deployment throws', () {
      for (final d in ['production', 'staging']) {
        expect(
          () => resolveDeploymentApiUrl(d, envApiUrl: _lan),
          throwsA(isA<StateError>()),
          reason: 'ADDRESSIQ_DEV_API_URL must not be honoured in "$d"',
        );
      }
    });

    test('ingest and cdn are gated identically', () {
      expect(() => resolveDeploymentIngestUrl('production', envIngestUrl: _ingest),
          throwsA(isA<StateError>()));
      expect(() => resolveDeploymentCdnUrl('production', envCdnUrl: _cdn),
          throwsA(isA<StateError>()));
    });

    test('the message names the variable and the offending deployment', () {
      expect(
        () => resolveDeploymentApiUrl('production', envApiUrl: _lan),
        throwsA(isA<StateError>()
            .having((e) => e.message, 'message', contains('ADDRESSIQ_DEV_API_URL'))
            .having((e) => e.message, 'message', contains('production'))),
      );
    });

    test('a shipped build with NO override set resolves normally', () {
      // The throw must fire only when someone actually sets one — never on the
      // ordinary path.
      expect(
        resolveDeploymentApiUrl('production', envApiUrl: ''),
        'https://api.addressiqpro.com',
      );
    });
  });

}
