// Repository — adapts the data-layer ApiClient to the domain types so
// the presentation layer (AddressIQ singleton) can stay HTTP-agnostic.

import '../domain/entities.dart';
import 'api_client.dart';

class VerificationRepository {
  final ApiClient client;
  VerificationRepository(this.client);

  Future<Map<String, dynamic>> startPhysical(StartPhysicalArgs args) =>
      client.post(
        '/api/v1/locations/${args.locationCode}/verifications/physical',
        {
          'provider': args.provider,
          if (args.agentId != null) 'agentId': args.agentId,
          if (args.slaHours != null) 'slaHours': args.slaHours,
          if (args.metadata != null) 'metadata': args.metadata,
        },
        idempotencyKey: args.idempotencyKey,
        branchId: args.branchId,
      );

  Future<Map<String, dynamic>> startCombined(StartCombinedArgs args) =>
      client.post(
        '/api/v1/locations/${args.locationCode}/verifications/combined',
        {
          'physicalProvider': args.physicalProvider,
          'startDigital': args.startDigital,
          if (args.digitalProvider != null) 'digitalProvider': args.digitalProvider,
          if (args.agentId != null) 'agentId': args.agentId,
          if (args.slaHours != null) 'slaHours': args.slaHours,
          if (args.metadata != null) 'metadata': args.metadata,
        },
        idempotencyKey: args.idempotencyKey,
        branchId: args.branchId,
      );

  Future<Map<String, dynamic>> cancel(String code, {String? idempotencyKey}) =>
      client.post('/api/v1/verifications/$code/cancel', const {}, idempotencyKey: idempotencyKey);

  Future<List<Map<String, dynamic>>> listProviders({String? type}) =>
      client.getList('/api/v1/providers${type != null ? '?type=$type' : ''}');

  Future<LocationEnvelope> getLocation(String locationCode) async {
    final raw = await client.get('/api/v1/locations/$locationCode');
    return LocationEnvelope.fromJson(raw);
  }

  Future<void> invalidateSession({required String appUserId, String? verificationCode}) =>
      client.delete('/api/v1/sdk/session', body: {
        'appUserId': appUserId,
        if (verificationCode != null) 'verificationCode': verificationCode,
      });
}
