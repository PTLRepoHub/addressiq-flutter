# Changelog

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
