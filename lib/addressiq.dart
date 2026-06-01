/// AddressIQ Flutter SDK.
///
/// Public surface follows the Phase 3 cross-SDK contract documented in
/// docs/sdk-contract.md. The legacy `addressiq` exports below remain for
/// partners still on the 1.x SDK; the new entry point is `AddressIQ.instance`.
library addressiq;

// Phase 3 — singleton lifecycle.
export 'src/lifecycle/addressiq.dart';
export 'src/domain/entities.dart';

// Legacy — kept until partners migrate to AddressIQ.instance.
export 'src/api/addressiq_api.dart';
// `AddressIQConfig` is also (canonically) defined in lifecycle/addressiq.dart;
// hide the legacy duplicate here to avoid an ambiguous export.
export 'src/api/models.dart' hide AddressIQConfig;
export 'src/location/location_collector.dart';
export 'src/ui/addressiq_verify.dart';
export 'src/ui/theme.dart';
