# Changelog

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
