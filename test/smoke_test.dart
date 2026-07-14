// Smoke test — guards the release pipeline against a broken build by
// exercising the pure value types in the public surface. Runs under
// `flutter test`. Behavioural tests live alongside as they are written.
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/addressiq.dart';

void main() {
  group('addressiq_sdk public surface', () {
    test('config resolves the deployment default URL when no override', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', deployment: 'staging');
      expect(config.resolvedApiUrl, startsWith('https://'));
    });

    test('development deployment resolves to a loopback host', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', deployment: 'development');
      expect(config.resolvedApiUrl, contains(':4000'));
    });

    test('config resolves a dedicated ingest host', () {
      const prod = AddressIQConfig(apiKey: 'aiq_test', deployment: 'production');
      expect(prod.resolvedIngestUrl, 'https://ingest-api.addressiqpro.com');

      const staging = AddressIQConfig(apiKey: 'aiq_test', deployment: 'staging');
      expect(staging.resolvedIngestUrl, contains('ingest-api-staging'));

      const dev = AddressIQConfig(apiKey: 'aiq_test', deployment: 'development');
      expect(dev.resolvedIngestUrl, contains(':4000'));
    });

    test("'sandbox' is rejected — it is a tenant mode, not a deployment", () {
      // It used to alias 'staging', which asserted sandbox was a deployment.
      // Sandbox-vs-production is decided by the API key, server-side. Rejecting
      // it loudly matters: with the old `default:` fallthrough it would now
      // resolve to the PRODUCTION hosts, silently pointing a build at prod.
      const sandbox = AddressIQConfig(apiKey: 'aiq_test', deployment: 'sandbox');

      expect(() => sandbox.resolvedApiUrl, throwsArgumentError);
      expect(() => sandbox.resolvedIngestUrl, throwsArgumentError);
      expect(() => sandbox.resolvedCdnUrl, throwsArgumentError);
    });

    test('the rejection message points at the API key, not at staging', () {
      const sandbox = AddressIQConfig(apiKey: 'aiq_test', deployment: 'sandbox');
      expect(
        () => sandbox.resolvedApiUrl,
        throwsA(isA<ArgumentError>().having(
          (e) => e.message.toString(), 'message', contains('aiq_test_'))),
      );
    });

    test('an unknown deployment throws rather than defaulting to production', () {
      const typo = AddressIQConfig(apiKey: 'aiq_test', deployment: 'prodution');
      expect(() => typo.resolvedApiUrl, throwsArgumentError);
    });

    test('config resolves a per-deployment CDN host', () {
      const prod = AddressIQConfig(apiKey: 'aiq_test', deployment: 'production');
      expect(prod.resolvedCdnUrl, 'https://cdn.addressiqpro.com');

      const staging = AddressIQConfig(apiKey: 'aiq_test', deployment: 'staging');
      expect(staging.resolvedCdnUrl, 'https://cdn-staging.addressiqpro.com');

      const dev = AddressIQConfig(apiKey: 'aiq_test', deployment: 'development');
      expect(dev.resolvedCdnUrl, contains(':4000'));
    });

    test('lifecycle state enum exposes the contract states', () {
      expect(SdkLifecycleState.values, contains(SdkLifecycleState.uninitialized));
      expect(SdkLifecycleState.values, contains(SdkLifecycleState.terminated));
    });

    test('SdkUser serializes only the fields that are set', () {
      const user = SdkUser(appUserId: 'cust_001');
      expect(user.toJson(), {'appUserId': 'cust_001'});
    });
  });
}
