# AddressIQ — Flutter SDK

[![CI](https://github.com/PTLRepoHub/addressiq-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/PTLRepoHub/addressiq-flutter/actions/workflows/ci.yml)
[![pub](https://img.shields.io/pub/v/addressiq_sdk.svg)](https://pub.dev/packages/addressiq_sdk)

`addressiq_sdk` is the Flutter SDK for AddressIQ — background location
collection, address-capture UI (`AddressIQVerify`), and the verification
lifecycle (`AddressIQ.instance`).

## Install

```yaml
dependencies:
  addressiq_sdk: ^0.4.0
```

```bash
flutter pub get
```

## Quick start

```dart
import 'package:addressiq_sdk/addressiq.dart';

// 1. Initialize once at app start.
AddressIQ.instance.initialize(AddressIQConfig(
  apiKey: 'aiq_...',
  environment: 'production', // 'production' | 'staging' | 'sandbox' | 'local'
));

// 2. Bind the signed-in user.
await AddressIQ.instance.setUser(const SdkUser(appUserId: 'cust_abc'));

// 3. Make sure location permissions are granted (see Permissions below).
await AddressIQ.instance.requestPermissions();

// 4. Start a verification. The SDK begins background collection
//    automatically using the returned codes.
final res = await AddressIQ.instance.startVerification(
  const StartVerificationArgs(locationCode: 'loc_123'),
);
print(res['verificationCode']); // ver_…
```

## Collect UI (`AddressIQVerify`)

Track A — a drop-in full-screen widget that captures the address (search,
map-pin, property details, photos, consent) and starts background
collection on submit. `onComplete` returns a `VerifyResult` with the
public **`verificationCode`** and **`locationCode`** the backend assigned.

```dart
import 'package:flutter/material.dart';
import 'package:addressiq_sdk/addressiq.dart';
// The Collect UI config is hidden from the barrel (the barrel re-exports the
// lifecycle AddressIQConfig); import it directly under a prefix.
import 'package:addressiq_sdk/src/api/models.dart' as collect;

Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => AddressIQVerify(
    config: collect.AddressIQConfig(
      apiKey: 'aiq_...',
      apiUrl: 'https://api.addressiqpro.com',
      sessionToken: '<widget-session-token>',
    ),
    onComplete: (VerifyResult result) {
      print(result.verificationCode); // ver_…
      print(result.locationCode);     // loc_…
    },
    onCancel: () {},
    onError: (error) {},
  ),
));
```

## SDK API (`AddressIQ.instance`)

| Method | Purpose |
| --- | --- |
| `initialize(AddressIQConfig)` | Configure the SDK (apiKey + environment). |
| `setUser(SdkUser)` | Bind the active app user. |
| `startVerification(StartVerificationArgs)` | Start a **digital** verification (`POST …/verifications/digital`, `digitalProvider` defaults to `internal_ai`). |
| `startPhysicalVerification(StartPhysicalArgs)` | Start a **physical** (agent/KYC) verification. |
| `startDigitalAndPhysicalVerification(StartCombinedArgs)` | Start a **combined** digital + physical verification. |
| `cancelVerification(verificationCode)` | Cancel an in-flight verification. |
| `getVerificationState()` | Current lifecycle state snapshot. |
| `pauseVerification()` / `resumeVerification()` | Pause / resume background collection. |
| `sync()` | Force-flush the telemetry queue. |
| `listProviders({type})` | List available providers. |
| `getLocation(locationCode)` | Fetch the location envelope (geofence, status). |
| `logout()` / `reset()` | Detach the user / tear the SDK down. |

`startVerification` signature:

```dart
Future<Map<String, dynamic>> startVerification(StartVerificationArgs args);

class StartVerificationArgs {
  final String locationCode;
  final String? digitalProvider;  // defaults to 'internal_ai' server-side
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final String? branchId;
  const StartVerificationArgs({ required this.locationCode, ... });
}
```

All `start*` methods return the backend response map containing
`verificationCode`, `locationCode`, and `status`, gate on location
permissions, mark the session `COLLECTING`, and kick off background
collection automatically.

## Permissions

`start*` requires both foreground **and** background location to be
`GRANTED`, otherwise it throws an `AddressIQException` with code
`PERMISSION_DENIED`. Drive the OS prompt and inspect state first:

```dart
await AddressIQ.instance.requestPermissions();
final state = await AddressIQ.instance.getPermissionState();
// { foregroundLocation, backgroundLocation, notifications } ∈
// { GRANTED, DENIED, NOT_DETERMINED, BLOCKED, UNAVAILABLE }

if (state['backgroundLocation'] != 'GRANTED' &&
    !(await AddressIQ.instance.canRequestPermission())) {
  await AddressIQ.instance.openSettings(); // deep-link when BLOCKED
}
```

Declare `ACCESS_BACKGROUND_LOCATION` (Android) / the always-usage
strings (iOS `Info.plist`) in the host app so the OS will prompt for
background access.

## Example app

`example/` is a runnable lifecycle demo. The hub exposes the imperative
lifecycle buttons (initialize → setUser → start → pause/resume/sync →
cancel → logout) plus a **Collect Address** button that opens the
`AddressIQVerify` Collect UI (Track A).

```bash
cd example
flutter create .   # generate platform folders (android/ ios/ — gitignored)
flutter pub get    # resolves addressiq_sdk from `path: ../`
flutter run \
  --dart-define=API_KEY=aiq_... \
  --dart-define=API_URL=https://api.addressiqpro.com \
  --dart-define=SESSION_TOKEN=<widget-session-token>
```

`example/pubspec.yaml` uses `addressiq_sdk: { path: ../ }`, so it always
builds against this repo's SDK source.

## Environment

`AddressIQConfig.environment` resolves the API base URL (override with
`apiUrl` only for partner proxies / hermetic test backends):

| environment | resolved URL |
| --- | --- |
| `production` | `https://api.addressiqpro.com` |
| `staging` | `https://api-staging.addressiqpro.com` |
| `sandbox` | `https://api-staging.addressiqpro.com` |
| `local` | `http://localhost:4000` |

## Errors

Lifecycle methods throw `AddressIQException(code, message)`. Common codes:

| code | meaning |
| --- | --- |
| `SDK_NOT_INITIALIZED` | A method was called before `initialize`. |
| `INVALID_CONFIG` | `apiKey` missing or env resolved to an empty URL. |
| `INVALID_USER` | `setUser` called without an `appUserId`. |
| `PERMISSION_DENIED` | Foreground/background location not `GRANTED` at start. |
| `NO_ACTIVE_SESSION` | `resumeVerification` with nothing to resume. |
| `HTTP_*` / backend code | Surfaced from the API response. |

## Develop

```bash
flutter pub get
flutter analyze
flutter test       # smoke test
```

## Release

Push a semver tag to publish to pub.dev (`.github/workflows/release.yml`):

```bash
git tag v0.4.0 && git push origin v0.4.0
```

Uses pub.dev **OIDC trusted publishing** — configure this repo as a trusted
publisher in the package's pub.dev admin settings (no secret required). Run the
workflow manually with `dry_run: true` to validate first.

## Cross-links

- Cross-SDK contract: [`../../geo-tagging/docs/sdk-contract.md`](../../geo-tagging/docs/sdk-contract.md)
- Flutter SDK reference: [`flutter.md`](../../geo-tagging/apps/docs/docs/sdk/flutter.md)

## Contributing

Fork, branch, PR. CI runs `flutter analyze` + `flutter test` on the SDK and
analyzes the example against the local SDK on every push/PR.
