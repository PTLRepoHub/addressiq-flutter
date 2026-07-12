# Changelog

## [0.8.0](https://github.com/PTLRepoHub/addressiq-flutter/compare/v0.7.0...v0.8.0) (2026-07-12)


### Features

* **widget:** re-vendor iqcollect.js from web v0.4.0 ([#10](https://github.com/PTLRepoHub/addressiq-flutter/issues/10)) ([79fd66c](https://github.com/PTLRepoHub/addressiq-flutter/commit/79fd66cb3d982aa87473a8a8c6d87a181902d764))
* **widget:** re-vendor iqcollect.js from web v0.4.1 ([#12](https://github.com/PTLRepoHub/addressiq-flutter/issues/12)) ([d04f491](https://github.com/PTLRepoHub/addressiq-flutter/commit/d04f491be903243cba69f6fa8abb811ff7096d85))

## [0.7.0](https://github.com/PTLRepoHub/addressiq-flutter/compare/v0.6.1...v0.7.0) (2026-07-12)


### ⚠ BREAKING CHANGES

* removed AddressIQConfig.apiUrl (lifecycle + widget). Select a host via `environment` (production | sandbox | development); production is provisioned at build time.

### Features

* provision API URL (+ web: Maps key) at build time from GH env ([#8](https://github.com/PTLRepoHub/addressiq-flutter/issues/8)) ([e1d5954](https://github.com/PTLRepoHub/addressiq-flutter/commit/e1d59540bb9d55900b8985db0548968eed7c093b))

## [0.6.1](https://github.com/PTLRepoHub/addressiq-flutter/compare/v0.6.0...v0.6.1) (2026-07-12)


### Bug Fixes

* add .pubignore to exclude dev files from the pub package ([#5](https://github.com/PTLRepoHub/addressiq-flutter/issues/5)) ([a90f0cd](https://github.com/PTLRepoHub/addressiq-flutter/commit/a90f0cd62f4358813e145768081c722b3461fba0))

## [0.6.0](https://github.com/PTLRepoHub/addressiq-flutter/compare/v0.5.0...v0.6.0) (2026-07-12)


### ⚠ BREAKING CHANGES

* removed AddressIQConfig.googleMapsApiKey and AddressIQConfig.mapboxToken. The key is provisioned automatically by the platform; there is nothing to pass.

### Features

* **proto:** regen against proto v0.1.0 ([#2](https://github.com/PTLRepoHub/addressiq-flutter/issues/2)) ([a11ba08](https://github.com/PTLRepoHub/addressiq-flutter/commit/a11ba083d4fecbd7ce48c303641da6860f77702a))
* provision Google Maps key automatically; remove googleMapsApiKey/mapboxToken ([#4](https://github.com/PTLRepoHub/addressiq-flutter/issues/4)) ([11c194d](https://github.com/PTLRepoHub/addressiq-flutter/commit/11c194d855128ad4a85f847db3c82a3f7a8036ce))


### Bug Fixes

* add canonical addressiq_sdk.dart entry point ([c24d7b6](https://github.com/PTLRepoHub/addressiq-flutter/commit/c24d7b657bf33c8c3e67987cc9cd369fd30cbed4))
* add LICENSE file required by pub.dev ([9c7db91](https://github.com/PTLRepoHub/addressiq-flutter/commit/9c7db91feb46c9de86b014bed27241b4a90bd900))

## [0.5.0](https://github.com/PTLRepoHub/addressiq-flutter/compare/v0.4.0...v0.5.0) (2026-07-10)


### ⚠ BREAKING CHANGES

* a missing widget bundle now calls onError instead of silently fetching from a CDN. config.widgetUrl still works as a dev override.

### Features

* AddressIQ Flutter SDK + example + CI/CD ([b570f08](https://github.com/PTLRepoHub/addressiq-flutter/commit/b570f08c87067541f6bd2eccfa9ffcc3f77770b1))
* fail closed when the bundled widget is missing ([391e761](https://github.com/PTLRepoHub/addressiq-flutter/commit/391e761755b477863b86143d7820aa9370222629))
* **flutter:** collect→verify split + example demoing all 3 verification types ([82ca273](https://github.com/PTLRepoHub/addressiq-flutter/commit/82ca273255758cf9ef5708e0588633af5daa16aa))
* **flutter:** unified maps address-capture screen + Street View in Collect UI ([9d0e49f](https://github.com/PTLRepoHub/addressiq-flutter/commit/9d0e49f65b2c4a08e4ed1277a4a9045395f05e2c))
* **proto:** generate wire-contract bindings from AddressIq-proto ([d4fa7de](https://github.com/PTLRepoHub/addressiq-flutter/commit/d4fa7de71713013af61f9fef0497c7884a52b572))


### Bug Fixes

* **ci:** gate pub.dev publishing behind an explicit variable ([81f4ce8](https://github.com/PTLRepoHub/addressiq-flutter/commit/81f4ce862981998a28a0dbfa4c3e4f5096cb3b1b))
* **ci:** set bump-minor-pre-major in release-please config ([f61a4af](https://github.com/PTLRepoHub/addressiq-flutter/commit/f61a4af113062db9164712f2c42f20ca8c0c5d27))
* point homepage and vendored widget at addressiqpro.com ([062f8b4](https://github.com/PTLRepoHub/addressiq-flutter/commit/062f8b428c2a9d054a0a573282c43d40e843c3fa))
* **sdk:** resolve analyzer errors surfaced by CI ([e50df70](https://github.com/PTLRepoHub/addressiq-flutter/commit/e50df70a9725cfae1d86f142c03617fc4dd3b430))

## 0.4.0

- **Contract parity (P0):** `VerifyResult` now exposes the public
  `verificationCode` / `locationCode` codes the backend returns (was
  `verificationId` / `locationId`); the Collect UI labels read
  "Verification Code" / "Location Code".
- Added `AddressIQ.instance.startVerification(StartVerificationArgs)` —
  starts a **digital** verification (`POST …/verifications/digital`,
  `digitalProvider` defaults to `internal_ai`).
- `start*` now gate on location permissions (throwing
  `AddressIQException('PERMISSION_DENIED', …)` when foreground/background
  location is not `GRANTED`) and kick off background collection
  automatically via a shared collection helper used by the Collect UI too.
- Example app: added a **Collect Address** button that opens the
  `AddressIQVerify` Collect UI (Track A).

## 0.3.0

- Phase 3 cross-SDK contract: `AddressIQ.instance` lifecycle (initialize →
  setUser → startPhysical → pause/resume → sync → cancel → logout).
- Address capture UI (`AddressIQVerify`) and background location collection.
