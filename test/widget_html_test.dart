// How the verify WebView sources the widget JS.
//
// The SRI-pinned CDN copy is now the ONLY source. The SDK no longer vendors
// assets/iqcollect.js, so there is no offline/outage fallback: a failed load is a
// hard failure reported as WIDGET_LOAD_FAILED rather than a silent degradation.
//
// These tests previously asserted the opposite (bundle embedded as fallback,
// development inlines it, an unbaked pin inlines it). They are inverted, not
// deleted — the new contract is pinned where the old one was.
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/src/api/models.dart';
import 'package:addressiq_sdk/src/ui/theme.dart';
import 'package:addressiq_sdk/src/ui/widget_html.dart';

const _version = '0.4.0';
const _integrity = 'sha384-TESTHASH';

String _html(
  AddressIQConfig config, {
  String widgetVersion = _version,
  String widgetIntegrity = _integrity,
}) =>
    buildWidgetHtml(
      config: config,
      theme: const AddressIQTheme(),
      platform: 'ios',
      widgetVersion: widgetVersion,
      widgetIntegrity: widgetIntegrity,
    );

void main() {
  group('buildWidgetHtml', () {
    test('loads the SRI-pinned CDN widget', () {
      const config = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      final html = _html(config);

      expect(html, contains('<script src="https://cdn.addressiqpro.com/v0.4.0/iqcollect.js"'));
      expect(html, contains('integrity="sha384-TESTHASH"'));
      expect(html, contains('crossorigin="anonymous"'));
    });

    test('development ALSO loads from the CDN — it no longer inlines a bundle', () {
      // This is the inversion. `development` used to be excluded from the CDN path
      // and inline the vendored asset, which meant the fetch, the SRI check and the
      // failure path were only ever exercised in staging/production.
      const config = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'development');
      final html = _html(config);

      expect(html, contains('<script src="https://cdn.addressiqpro.com/v0.4.0/iqcollect.js"'));
      expect(html, contains('integrity="sha384-TESTHASH"'));
      // The dev CDN is NOT the dev host — localhost serves no widget.
      expect(html, isNot(contains('localhost:4000/v0.4.0')));
      expect(html, isNot(contains('10.0.2.2:4000/v0.4.0')));
    });

    test('ships no bundled widget and no fallback machinery', () {
      const config = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      final html = _html(config);

      expect(html, isNot(contains('__iqWidgetFallback')));
      expect(html, isNot(contains('document.head.appendChild(s)')));
    });

    test('a failed load reports WIDGET_LOAD_FAILED instead of a blank WebView', () {
      // There is nothing to fall back to, so the failure must be SURFACED. onerror
      // posts through the existing bridge contract ({kind:'event', name:'error'}),
      // which BridgeRouter maps onto onFailed.
      const config = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      final html = _html(config);

      expect(html, contains('onerror="__iqWidgetLoadFailed()"'));
      expect(html, contains('WIDGET_LOAD_FAILED'));
      expect(html, contains('window.AddressIQFlutter.postMessage'));
      expect(html, contains("name: 'error'"));
    });

    test('the boot script is guarded so a failed load does not throw over the error', () {
      const config = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');
      final html = _html(config);

      // Unguarded, `new window.AddressIQ.IQCollect(...)` throws an opaque JS error
      // when the widget never loaded, masking the code we just reported.
      expect(html, contains('if (window.AddressIQ && window.AddressIQ.IQCollect)'));
    });

    test('an unbaked pin FAILS CLOSED — there is no bundle to fall back to', () {
      const config = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');

      // Previously this inlined the bundled asset. Now there is nothing to inline,
      // and loading an UNPINNED remote script would turn a packaging bug into
      // remote code execution — so it throws.
      expect(() => _html(config, widgetVersion: ''), throwsA(isA<StateError>()));
      expect(() => _html(config, widgetIntegrity: ''), throwsA(isA<StateError>()));
    });

    test('a widgetUrl override still beats the CDN in development', () {
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        sessionToken: 'sess_test',
        deployment: 'development',
        widgetUrl: 'http://localhost:5173/iqcollect.js',
      );
      final html = _html(config);

      expect(html, contains('<script src="http://localhost:5173/iqcollect.js"></script>'));
      expect(html, isNot(contains('cdn.addressiqpro.com')));
      // Unpinned by design: a widget you are actively rebuilding cannot satisfy a
      // fixed SRI hash. Safe only because it cannot escape development.
      expect(html, isNot(contains('integrity=')));
    });

    test('a widgetUrl override outside development still fails closed', () {
      for (final env in ['production', 'staging']) {
        final config = AddressIQConfig(
          apiKey: 'aiq_test',
          sessionToken: 'sess_test',
          deployment: env,
          widgetUrl: 'https://evil.example.com/iqcollect.js',
        );
        expect(() => _html(config), throwsA(isA<StateError>()),
            reason: 'widgetUrl must not be honoured in "$env"');
      }
    });

    test('cdnWidgetEnabled no longer excludes development', () {
      const dev = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'development');
      const prod = AddressIQConfig(
          apiKey: 'aiq_test', sessionToken: 'sess_test', deployment: 'production');

      // The checked-in pin is now the real published one, so this is true out of
      // the box — a source consumer (pub ships source) gets a working widget.
      expect(cdnWidgetEnabled(dev), isTrue);
      expect(cdnWidgetEnabled(prod), isTrue);

      // …but an empty pin still disables it, and buildWidgetHtml then throws.
      expect(cdnWidgetEnabled(prod, widgetVersion: ''), isFalse);
      expect(cdnWidgetEnabled(prod, widgetIntegrity: ''), isFalse);
    });
  });
}
