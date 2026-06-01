// Smoke test — guards the release pipeline against a broken build by
// exercising the pure value types in the public surface. Runs under
// `flutter test`. Behavioural tests live alongside as they are written.
import 'package:flutter_test/flutter_test.dart';
import 'package:addressiq_sdk/addressiq.dart';

void main() {
  group('addressiq_sdk public surface', () {
    test('config resolves the environment default URL when no override', () {
      const config = AddressIQConfig(apiKey: 'aiq_test', environment: 'sandbox');
      expect(config.resolvedApiUrl, startsWith('https://'));
    });

    test('config honors an explicit apiUrl override', () {
      const override = 'https://proxy.partner.example';
      const config = AddressIQConfig(
        apiKey: 'aiq_test',
        environment: 'production',
        apiUrl: override,
      );
      expect(config.resolvedApiUrl, override);
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
