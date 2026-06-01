# AddressIQ — Flutter SDK

[![CI](https://github.com/PTLRepoHub/addressiq-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/PTLRepoHub/addressiq-flutter/actions/workflows/ci.yml)
[![pub](https://img.shields.io/pub/v/addressiq_sdk.svg)](https://pub.dev/packages/addressiq_sdk)

`addressiq_sdk` is the Flutter SDK for AddressIQ — background location
collection, address-capture UI (`AddressIQVerify`), and the verification
lifecycle (`AddressIQ.instance`).

## Repository layout

```
.              ← the SDK (addressiq_sdk): lib/, test/
  example/     runnable example, linked to the LOCAL SDK (path: ../)
```

## Develop

```bash
flutter pub get
flutter analyze
flutter test       # smoke test
```

## Example against your local SDK

```bash
cd example
flutter create .   # generate platform folders (android/ ios/ — gitignored)
flutter pub get    # resolves addressiq_sdk from `path: ../`
flutter run --dart-define=API_KEY=aiq_... --dart-define=API_URL=https://api.addressiq.com
```

`example/pubspec.yaml` uses `addressiq_sdk: { path: ../ }`, so it always builds
against this repo's SDK source.

## Release

Push a semver tag to publish to pub.dev (`.github/workflows/release.yml`):

```bash
git tag v0.3.0 && git push origin v0.3.0
```

Uses pub.dev **OIDC trusted publishing** — configure this repo as a trusted
publisher in the package's pub.dev admin settings (no secret required). Run the
workflow manually with `dry_run: true` to validate first.

## Contributing

Fork, branch, PR. CI runs `flutter analyze` + `flutter test` on the SDK and
analyzes the example against the local SDK on every push/PR.
