// Unit tests for how the verify WebView sources the widget JS: CDN-first with
// an SRI pin, bundled fallback, fail-closed when neither is available.
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/api/models.dart';
import 'package:addressiq_sdk/src/ui/theme.dart';
import 'package:addressiq_sdk/src/ui/widget_html.dart';

const _bundle = 'window.AddressIQ = {};';
const _version = '0.4.0';
const _integrity = 'sha384-TESTHASH';

String _html(
  AddressIQConfig config, {
  String? bundledJs = _bundle,
  String widgetVersion = _version,
  String widgetIntegrity = _integrity,
}) =>
    buildWidgetHtml(
      config: config,
      theme: const AddressIQTheme(),
      platform: 'ios',
      bundledJs: bundledJs,
      widgetVersion: widgetVersion,
      widgetIntegrity: widgetIntegrity,
    );

void main() {
  group('buildWidgetHtml', () {
    test('loads the SRI-pinned CDN widget when the preconditions are met', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      final html = _html(config);

      expect(html, contains('<script src="https://cdn.addressiqpro.com/v0.4.0/iqcollect.js"'));
      expect(html, contains('integrity="sha384-TESTHASH"'));
      expect(html, contains('crossorigin="anonymous"'));
      expect(html, contains('onerror="__iqWidgetFallback()"'));
    });

    test('still embeds the bundle as the outage/offline/SRI fallback', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      final html = _html(config);

      // The fallback is DEFINED BEFORE the remote script it guards.
      expect(html.indexOf('function __iqWidgetFallback'),
          lessThan(html.indexOf('<script src="https://cdn')));
      expect(html, contains('window.AddressIQ'));
      expect(html, contains(r'document.head.appendChild(s)'));
    });

    test('development inlines the bundle and loads no remote script', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'development');
      final html = _html(config);

      expect(html, contains('<script>$_bundle</script>'));
      expect(html, isNot(contains('<script src=')));
      expect(html, isNot(contains('integrity=')));
    });

    test('an unbaked widget version or integrity inlines the bundle', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');

      final noVersion = _html(config, widgetVersion: '');
      expect(noVersion, contains('<script>$_bundle</script>'));
      expect(noVersion, isNot(contains('<script src=')));

      final noIntegrity = _html(config, widgetIntegrity: '');
      expect(noIntegrity, contains('<script>$_bundle</script>'));
      expect(noIntegrity, isNot(contains('integrity=')));
    });

    test('a widgetUrl override beats both the CDN and the bundle in development', () {
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        sessionToken: 'sess_test',
        deployment: 'development',
        widgetUrl: 'http://localhost:8080/iqcollect.js',
      );
      final html = _html(config);

      expect(html, contains('<script src="http://localhost:8080/iqcollect.js"></script>'));
      expect(html, isNot(contains('cdn.addressiqpro.com')));
      // Unpinned by design — the bytes change on every widget rebuild. Safe only
      // because the override cannot escape development.
      expect(html, isNot(contains('integrity=')));
    });

    test('the override can point development at the real CDN, exercising the remote path', () {
      // The reason this override exists: `development` inlines the bundle and
      // never fetches, so the remote-load path is otherwise untestable locally.
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        sessionToken: 'sess_test',
        deployment: 'development',
        widgetUrl: 'https://cdn.addressiqpro.com/v0.5.3/iqcollect.js',
      );
      final html = _html(config);

      expect(html, contains('<script src="https://cdn.addressiqpro.com/v0.5.3/iqcollect.js"></script>'));
      expect(html, isNot(contains('<script>$_bundle</script>')));
    });

    test('a widgetUrl override outside development fails closed', () {
      // Previously this loaded an UNPINNED remote script in production — the
      // remote-code-execution hole the rest of this loader fails closed to avoid.
      for (final env in ['production', 'staging']) {
        final config = AddressIQConfig(
          apiKey: 'aiq_test',
          sessionToken: 'sess_test',
          deployment: env,
          widgetUrl: 'https://evil.example.com/iqcollect.js',
        );
        expect(
          () => _html(config),
          throwsA(isA<StateError>()),
          reason: 'widgetUrl must not be honoured in "$env"',
        );
      }
    });

    test('fails closed with no bundle and no CDN pin', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'development');
      expect(
        () => _html(config, bundledJs: null),
        throwsA(isA<StateError>()),
      );
    });

    test('cdnWidgetEnabled is false until the widget files are baked', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      // Defaults come from the generated build config, where the widget
      // constants are empty until a web release fans out .widget-version /
      // .widget-integrity — so the SDK ships bundled-only today.
      expect(cdnWidgetEnabled(config), isFalse);
      expect(
        cdnWidgetEnabled(config,
            widgetVersion: _version, widgetIntegrity: _integrity),
        isTrue,
      );
    });
  });
}
