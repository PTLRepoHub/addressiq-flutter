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
  deployment: 'production', // 'production' | 'staging' | 'development'
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
      deployment: 'production',
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
| `initialize(AddressIQConfig)` | Configure the SDK (apiKey + deployment). |
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
  --dart-define=SESSION_TOKEN=<widget-session-token>
```

The API host is resolved from the selected deployment — you never pass a URL.
Choose the `development` deployment (Login screen) to target a local backend.

`example/pubspec.yaml` uses `addressiq_sdk: { path: ../ }`, so it always
builds against this repo's SDK source.

## Deployment vs sandbox — two different things

These are orthogonal, and conflating them is the most common integration mistake:

| | What it selects | How you set it |
|---|---|---|
| **Deployment** | Which AddressIQ **hosts** you talk to | `AddressIQConfig.deployment` |
| **Tenant mode** | Whether your data is **sandbox or production** | **Which API key you paste** |

`AddressIQConfig.deployment` selects which backend the SDK talks to. Integrators
never pass a URL — the SDK owns host resolution. Choose one of:

- `production`
- `staging`
- `development`

Anything else throws. Notably **`'sandbox'` is rejected** — it is *not* a
deployment. Sandbox-vs-production is a property of your **API key**: `aiq_test_…`
resolves to a sandbox tenant server-side, `aiq_live_…` to a production one. The
SDK never sends a mode, and cannot override the key's.

The two combine freely: a `aiq_test_…` key on the `production` deployment is
still sandbox data; a `aiq_live_…` key on `staging` is still production-mode data.

> **Migrating from `environment:`?** `environment: 'sandbox'` → drop the field and
> use a sandbox key (`aiq_test_…`), which is almost certainly what you meant.
> Only use `deployment: 'staging'` if you specifically wanted the pre-production
> *hosts*.

Each deployment resolves three hosts — API, ingest, and CDN. `production` and
`staging` are baked in at publish time from GitHub repository variables (see
[`docs/RELEASE.md`](docs/RELEASE.md)); `development` is local-only and never
baked.

```dart
final config = AddressIQConfig(apiKey: 'aiq_test_...', deployment: 'staging');
config.resolvedApiUrl;    // API host
config.resolvedIngestUrl; // telemetry ingest host
config.resolvedCdnUrl;    // CDN host — the widget is loaded from it, see below
```

### How the Collect UI widget is loaded

CDN-first, integrity-pinned, bundle as the fallback
(`lib/src/ui/widget_html.dart:96-115`):

1. **Widget URL override** — `config.widgetUrl`, or the `ADDRESSIQ_WIDGET_URL`
   dart-define (the field wins). Wins over everything below, but **only in
   `development`** — supplied with any other deployment it throws a `StateError`
   rather than being silently dropped. It is injected *without* an `integrity`
   attribute (the bytes change on every widget rebuild, so a hash would be
   meaningless), which is exactly why it must not reach a shipped build. See
   [Pointing the WebView at your own widget build](#pointing-the-webview-at-your-own-widget-build).
2. **Pinned CDN build** — `{resolvedCdnUrl}/v{kWidgetVersion}/iqcollect.js`
   loaded with `integrity="{kWidgetIntegrity}" crossorigin="anonymous"`
   (`widget_html.dart:102-109`). WKWebView (WebKit) and Android WebView
   (Chromium) both **enforce** `integrity`, so the CDN can only execute the exact
   bytes hashed at build time. The pair is baked from the repo-root
   `.widget-version` / `.widget-integrity` files that addressiq-web's release
   fanout writes from the same build the CDN serves; CDN paths are immutable
   (`/v{x.y.z}/`, no floating alias) because a mutable URL cannot be SRI-pinned.
3. **Bundled `assets/iqcollect.js`** — the *fallback*, injected by
   `onerror="__iqWidgetFallback()"`: CDN outage, offline device, or an SRI
   mismatch all land on it. It is also the only source when the CDN path is off
   (`development`, or an unbaked version/integrity — `cdnWidgetEnabled`,
   `widget_html.dart:42-50`).

With neither a pinned CDN build nor the bundle the SDK still **fails closed**
(`StateError`, `widget_html.dart:114`) — it never loads an unpinned remote script.

### Pointing the WebView at your own widget build

`development` inlines the bundled asset and never fetches, so the remote-load path,
the SRI enforcement, and the `onerror` fallback are otherwise only exercised in
staging/prod — the three things most likely to break are the three you cannot test
locally. The override closes that, and gives you live reload while iterating on the
widget itself.

Serve a local build of the widget:

```sh
cd ../addressiq-web && npx rollup -c      # → dist/iqcollect.js
npx serve dist -p 5173
```

Then run against it — no re-vendoring, no SDK rebuild:

```sh
flutter run --dart-define=ADDRESSIQ_WIDGET_URL=http://10.0.2.2:5173/iqcollect.js   # Android emulator
flutter run --dart-define=ADDRESSIQ_WIDGET_URL=http://localhost:5173/iqcollect.js  # iOS simulator
flutter run --dart-define=ADDRESSIQ_WIDGET_URL=http://192.168.1.x:5173/iqcollect.js # physical device (LAN IP)
```

A `file://` path to the bundle on your Mac will **not** work: the Android emulator is
a separate VM with no view of your filesystem, and a physical device has none at all.
It has to be served over HTTP — which has the side benefit of exercising the same
remote `<script src>` machinery you actually ship.

Point the same define at a **published** URL
(`https://cdn.addressiqpro.com/v{x.y.z}/iqcollect.js`) to verify the real CDN bundle
from a dev build.

Requires `deployment: 'development'`. On Android, a plain-HTTP local host also needs
`android:usesCleartextTraffic="true"` in the **debug** manifest (or a
`network_security_config` scoped to `10.0.2.2`) — debug only, never in a release.

Three details in that markup are load-bearing — each fails *silently* toward
"looks fine, but never actually uses the CDN":

- `crossorigin="anonymous"` is **mandatory**: without it the cross-origin
  response is opaque, `integrity` cannot be evaluated, and every load hard-fails
  into the fallback.
- **Script order**: a blocking classic `<script>` fires `onerror` before the
  parser reaches the next inline script, so `__iqWidgetFallback()` is defined
  *before* the remote tag (which carries no `defer`/`async`).
- The inlined fallback bundle is **escaped** (`_scriptSafe`,
  `widget_html.dart:149`) — it contains `</script>`-alike sequences that would
  otherwise terminate the tag.

> **The bundled asset in this package carries no Google Maps key.** pub.dev scans
> published packages for credentials and rejects one containing a Google API key,
> so the vendored `assets/iqcollect.js` is built key-free. This costs nothing: the
> bundle is only the offline fallback and is never the SRI-checked artifact —
> Flutter fetches and integrity-verifies the **keyed** bundle from the CDN exactly
> like the other SDKs, and on the fallback path the Maps key arrives from the
> backend's `GET /api/v1/widget/config`, which takes priority over any key baked
> into a bundle anyway (`addressiq-web/src/flow.ts:111`).

There are two exported `AddressIQConfig` classes — the lifecycle one
(`lib/src/lifecycle/addressiq.dart:28-53`, re-exported by the barrel) and the
Collect UI one (`lib/src/api/models.dart:5-42`). Both expose the same
`resolved*` getters and resolve identically.

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

The release bakes `lib/src/generated/build_config.dart` from six GitHub
repository variables (staging + production × API/ingest/CDN) with
`scripts/bake-build-config.sh --strict` — **a release fails if any of them is
unset**. See [`docs/RELEASE.md`](docs/RELEASE.md).

## Cross-links

- Cross-SDK contract: [`../../geo-tagging/docs/sdk-contract.md`](../../geo-tagging/docs/sdk-contract.md)
- Flutter SDK reference: [`flutter.md`](../../geo-tagging/apps/docs/docs/sdk/flutter.md)

## Contributing

Fork, branch, PR. CI runs `flutter analyze` + `flutter test` on the SDK and
analyzes the example against the local SDK on every push/PR.
