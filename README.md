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

**The SRI-pinned CDN copy is the only source. The SDK ships no bundled widget.**

1. **Widget URL override** — `config.widgetUrl`, or the `ADDRESSIQ_DEV_WIDGET_URL`
   dart-define (the field wins). Wins over the CDN, but **only in `development`** —
   supplied with any other deployment it throws a `StateError` rather than being
   silently dropped. It is injected *without* an `integrity` attribute (a widget
   you are actively rebuilding cannot satisfy a fixed hash), which is exactly why
   it must not reach a shipped build. See
   [Pointing the WebView at your own widget build](#pointing-the-webview-at-your-own-widget-build).
2. **Pinned CDN build** — `{resolvedCdnUrl}/v{kWidgetVersion}/iqcollect.js`
   loaded with `integrity="{kWidgetIntegrity}" crossorigin="anonymous"`.
   WKWebView (WebKit) and Android WebView (Chromium) both **enforce** `integrity`,
   so the CDN can only execute the exact bytes hashed at build time. The pair is
   baked from the repo-root `.widget-version` / `.widget-integrity` files that
   addressiq-web's release fanout writes from the same build the CDN serves; CDN
   paths are immutable (`/v{x.y.z}/`, no floating alias) because a mutable URL
   cannot be SRI-pinned.

`development` is **not** excluded from the CDN path. It used to inline a vendored
asset and never fetch, which meant the remote load, the SRI check and the failure
path were only ever exercised in staging and production. A dev build now loads the
same pinned bundle as everything else — its CDN defaults to production (the local
backend serves no widget) and is overridable with `ADDRESSIQ_DEV_CDN_URL`.

> **There is no fallback, and verification now depends on the CDN.** A CDN outage,
> an offline device, or an SRI mismatch is a **hard failure**: `onerror` reports
> `WIDGET_LOAD_FAILED` through `onError` rather than leaving a blank WebView. The
> SDK previously vendored `assets/iqcollect.js` and degraded to it; that copy is
> gone. **The collect UI cannot render without a network.**

With no usable pin and no override the SDK still **fails closed** (`StateError`) —
it never loads an unpinned remote script, because quietly fetching one alongside
the session config would turn a packaging bug into remote code execution.

### Local development: overriding the hosts

`development` resolves to a hardcoded literal — `10.0.2.2:4000` on Android, `localhost:4000`
elsewhere. **`10.0.2.2` is an Android-*emulator* alias for your Mac**, so a physical device
cannot reach it. Supply your own hosts from a `.env` file:

```sh
cp .env.example .env         # .env is gitignored — put real values there
# edit .env: set your LAN IP (ipconfig getifaddr en0)
flutter run --dart-define-from-file=.env
```

`.env.example` documents every variable. Or pass them one at a time:

```sh
flutter run \
  --dart-define=ADDRESSIQ_DEV_API_URL=http://192.168.1.5:4000 \
```

| Variable | Overrides | Unset → |
|---|---|---|
| `ADDRESSIQ_DEV_API_URL` | `resolvedApiUrl` | the `development` literal |
| `ADDRESSIQ_DEV_INGEST_URL` | `resolvedIngestUrl` | the `development` literal |
| `ADDRESSIQ_DEV_CDN_URL` | which CDN the widget loads from | the production CDN |
| `ADDRESSIQ_DEV_WIDGET_URL` | the widget bundle (unpinned) | the pinned CDN bundle |

Each is independent — overriding the API host does not drag the others along.

**They are honoured only under `deployment: 'development'`, and throw anywhere else.** A build-time
variable must never be able to point a shipped app at an arbitrary host, so setting one on a
staging or production build fails loudly rather than being silently dropped.
### Pointing the WebView at your own widget build

`development` now loads the same SRI-pinned CDN bundle as production, so the remote
load and the integrity check are exercised locally by default. This override exists
for the other job: **live reload while you are changing the widget itself.** It is
unpinned, because a widget you are rebuilding cannot satisfy a fixed SRI hash.

Serve a local build of the widget:

```sh
cd ../addressiq-web && npx rollup -c      # → dist/iqcollect.js
npx serve dist -p 5173
```

Then run against it — no re-vendoring, no SDK rebuild:

```sh
flutter run --dart-define=ADDRESSIQ_DEV_WIDGET_URL=http://10.0.2.2:5173/iqcollect.js   # Android emulator
flutter run --dart-define=ADDRESSIQ_DEV_WIDGET_URL=http://localhost:5173/iqcollect.js  # iOS simulator
flutter run --dart-define=ADDRESSIQ_DEV_WIDGET_URL=http://192.168.1.x:5173/iqcollect.js # physical device (LAN IP)
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
- **Script order**: a blocking classic `<script>` fires `onerror` before the
  parser reaches the next inline script, so `__iqWidgetFallback()` is defined
  *before* the remote tag (which carries no `defer`/`async`).

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

## Running the SDK locally, end to end

Everything below is **development-only**. Every override is honoured solely under
the `development` deployment and **throws** on a staging or production build, even
if the variable is set — a build-time value must never be able to point a shipped
app at an arbitrary host.

### 1. Start the backend

```sh
cd addressiq-node-backend
cp .env.example .env          # set GOOGLE_MAPS_API_KEY if you want the map to load
npm install && npm start      # http://localhost:4000
```

It must bind `0.0.0.0`, not `127.0.0.1`, or nothing off-machine can reach it.

### 2. (Optional) Serve the widget yourself

Only needed if you are **changing the widget**. Otherwise the SDK uses the widget
it already ships.

```sh
cd addressiq-web
npx rollup -c                 # → dist/iqcollect.js
npx serve dist -p 5173
```

Then set `ADDRESSIQ_DEV_WIDGET_URL` to `http://<host>:5173/iqcollect.js` for live
reload without re-vendoring. Point it at a **published** URL
(`https://cdn.addressiqpro.com/v0.5.3/iqcollect.js`) instead to exercise the
pinned CDN bundle — though `development` now loads that by default anyway, so this
is only useful for pointing at a *different* published version.

A `file://` path will **not** work: the Android emulator is a separate VM and
cannot see your filesystem, and a physical device certainly cannot. It has to be
served over HTTP.

### 3. Point the SDK at your machine

```sh
cp .env.example .env
```

**Which host do I use?**

| Running on | Host |
|---|---|
| Android emulator | `10.0.2.2` — a special alias for your machine's localhost |
| iOS simulator | `localhost` — it shares your Mac's network |
| **Physical device (either OS)** | your **LAN IP** — `ipconfig getifaddr en0` |

The default is the emulator/simulator literal, which is exactly why these
overrides exist: **a physical device cannot reach `10.0.2.2` or `localhost`.**

Then run:

```sh
flutter run --dart-define-from-file=.env
```

### 4. Android only: allow plain HTTP

A LAN IP over plain `http://` is blocked by default. In your **debug** manifest:

```xml
<application android:usesCleartextTraffic="true" …>
```

Debug only — never in a release. (A `network_security_config` scoped to that one
host is the tighter version.)

### Troubleshooting

- **Requests hang / connection refused on a real device** — the backend is bound to
  `127.0.0.1`. Bind `0.0.0.0`.
- **Works on the emulator, fails on a device** — you are still on `10.0.2.2`. Set a
  LAN IP.
- **Android: `net::ERR_CLEARTEXT_NOT_PERMITTED`** — step 4.
- **The map is blank** — your backend has no Maps key. `GET /api/v1/widget/config`
  supplies it; set `GOOGLE_MAPS_API_KEY` in the backend's `.env`. (The key is
  platform-provisioned; no native SDK accepts one, because the key is used by the
  widget, not by native code.)
- **An override "does nothing"** — check `deployment` is `development`. Anywhere
  else it throws rather than being silently ignored, so you would have seen an error.
