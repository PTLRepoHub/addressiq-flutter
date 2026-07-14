// Unit tests for the development-only widget URL override: where it may come
// from (config or --dart-define), which wins, and that it cannot escape
// `development` — outside it, an unpinned remote script is exactly the hole the
// widget loader otherwise fails closed to avoid.
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/api/deployment.dart';
import 'package:addressiq_sdk/src/api/models.dart';

const _local = 'http://10.0.2.2:5173/iqcollect.js';
const _define = 'http://10.0.2.2:9999/iqcollect.js';

void main() {
  group('resolveWidgetUrl', () {
    test('returns null when neither source supplies one', () {
      expect(resolveWidgetUrl('development', null, envWidgetUrl: ''), isNull);
      expect(resolveWidgetUrl('production', null, envWidgetUrl: ''), isNull);
    });

    test('honours the config value in development', () {
      expect(
        resolveWidgetUrl('development', _local, envWidgetUrl: ''),
        _local,
      );
    });

    test('honours the dart-define in development', () {
      expect(
        resolveWidgetUrl('development', null, envWidgetUrl: _define),
        _define,
      );
    });

    test('the config value wins over the dart-define', () {
      expect(
        resolveWidgetUrl('development', _local, envWidgetUrl: _define),
        _local,
      );
    });

    test('an empty config value falls through to the dart-define', () {
      expect(
        resolveWidgetUrl('development', '', envWidgetUrl: _define),
        _define,
      );
    });

    test('throws outside development, whichever source it came from', () {
      for (final env in ['production', 'staging']) {
        expect(
          () => resolveWidgetUrl(env, _local, envWidgetUrl: ''),
          throwsA(isA<StateError>()),
          reason: 'config widgetUrl must not be honoured in "$env"',
        );
        expect(
          () => resolveWidgetUrl(env, null, envWidgetUrl: _define),
          throwsA(isA<StateError>()),
          reason: 'ADDRESSIQ_WIDGET_URL must not be honoured in "$env"',
        );
      }
    });

    test('a build with no override is unaffected outside development', () {
      // The throw must fire only when someone actually supplies an override —
      // never on the ordinary CDN/bundled path.
      expect(
        () => resolveWidgetUrl('production', null, envWidgetUrl: ''),
        returnsNormally,
      );
    });
  });

  group('AddressIQConfig.resolvedWidgetUrl', () {
    test('surfaces the override in development', () {
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        sessionToken: 'sess_test',
        deployment: 'development',
        widgetUrl: _local,
      );
      expect(config.resolvedWidgetUrl, _local);
    });

    test('throws when an override is set on a shipped deployment', () {
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        sessionToken: 'sess_test',
        deployment: 'production',
        widgetUrl: _local,
      );
      expect(() => config.resolvedWidgetUrl, throwsA(isA<StateError>()));
    });

    test('is null on a normal production config', () {
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        sessionToken: 'sess_test',
        deployment: 'production',
      );
      expect(config.resolvedWidgetUrl, isNull);
    });
  });
}
