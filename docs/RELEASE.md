# Releasing `addressiq_sdk`

This repo publishes the Flutter SDK **`addressiq_sdk`** to [pub.dev](https://pub.dev).
Package name and metadata live in `pubspec.yaml:1-8`.

> pub.dev **requires** a `CHANGELOG.md` at the package root. It is generated and
> maintained automatically by release-please (see below) — do not hand-edit it
> for released versions.

## Release flow (automated)

Releases are driven by [Conventional Commits](https://www.conventionalcommits.org/)
and two workflows. You never tag manually.

1. **Commit to `main`** using Conventional Commit messages (`fix:`, `feat:`,
   `feat!:`, …).
2. **`release-please.yml`** runs on every push to `main`
   (`.github/workflows/release-please.yml:13-16`). It opens/maintains a
   `chore: release X.Y.Z` PR (title pattern from
   `release-please-config.json:5`) that accumulates the pending changelog and
   version bump.
3. **Merge that PR.** release-please then:
   - bumps `version:` in `pubspec.yaml` (`release-type: dart`,
     `release-please-config.json:8`),
   - writes `CHANGELOG.md` (`release-please-config.json:9`),
   - updates `.release-please-manifest.json`,
   - and **pushes the tag `vX.Y.Z`**.
4. **The tag triggers `release.yml`** (`.github/workflows/release.yml:19-21`,
   `on: push: tags: ["v*.*.*"]`), which sets the version from the tag name
   (`release.yml:41-45`) and runs `dart pub publish` to pub.dev
   (`release.yml:66-71`).

> ⚠ **Tags are automated. Do not create or push `vX.Y.Z` tags by hand.** The
> tag is the publish trigger; pushing one yourself publishes (permanently).

### Why a GitHub App token (not `GITHUB_TOKEN`)

GitHub does not fire workflows for events created with the default
`GITHUB_TOKEN`, so a tag pushed by release-please under `GITHUB_TOKEN` would
never trigger `release.yml`. `release-please.yml:29-38` mints a GitHub App token
via `actions/create-github-app-token@v1` and hands it to
`googleapis/release-please-action@v4`; an App-authored tag push *does* trigger
`release.yml`.

## Authentication

### pub.dev — OIDC trusted publishing (no secret)

`release.yml` publishes via **pub.dev OIDC / trusted publishing**, not a
credential secret. The job requests `id-token: write`
(`release.yml:33-34`) and runs `dart pub publish` — no `PUB_DEV_*` token is
stored. This repo must be configured as a trusted publisher on pub.dev
(`release.yml:6-7`).

A safety gate protects this proprietary package: because OIDC needs no secret, a
tag alone would otherwise publish forever. The repository **variable**
`PUB_DEV_PUBLISH` must equal exactly `true`, or the job downgrades to a dry run
(`release.yml:13-15`, `49-64`). It is a variable, not a secret — its value is
meant to be visible. Set it with:

```
gh variable set PUB_DEV_PUBLISH --repo PTLRepoHub/addressiq-flutter --body true
```

`workflow_dispatch` runs default to a dry run and only publish for real when
`dry_run=false` *and* `PUB_DEV_PUBLISH=true` (`release.yml:22-27`, `54-68`).

### GitHub App secrets (for release-please only)

`release-please.yml` requires two repo secrets (`release-please.yml:11`,
`33-34`):

| Secret | Purpose |
|---|---|
| `ADDRESSIQ_BOT_APP_ID` | GitHub App ID used to mint the token |
| `ADDRESSIQ_BOT_PRIVATE_KEY` | GitHub App private key |

One org-owned App on `PTLRepoHub` (installed across the release repos) with
`contents: write` + `pull_requests: write` (`RELEASE-ENGINEERING.md` §4.A).

## Build configuration (baked at publish time)

`lib/src/generated/build_config.dart` is **generated** — never hand-edit it.
`scripts/bake-build-config.sh` rewrites it wholesale from six GitHub
**repository variables** (not secrets — their values ship in the published
package source), three URLs for each shippable environment:

| | staging | production |
|---|---|---|
| API | `STAGING_ADDRESSIQ_API_BASE_URL` | `PROD_ADDRESSIQ_API_BASE_URL` |
| Ingest | `STAGING_ADDRESSIQ_INGEST_BASE_URL` | `PROD_ADDRESSIQ_INGEST_BASE_URL` |
| CDN | `STAGING_ADDRESSIQ_CDN_BASE_URL` | `PROD_ADDRESSIQ_CDN_BASE_URL` |

These replace the old single-environment `ADDRESSIQ_API_URL` /
`ADDRESSIQ_INGEST_URL` pair: staging used to be a hardcoded literal and no CDN
host was baked at all.

`development` is deliberately **not** baked — it points at the host machine's
backend (`localhost:4000`, `10.0.2.2:4000` on the Android emulator) and stays a
compile-time literal in `lib/src/api/environment.dart:9-10`.

> ⚠ **Behaviour change — a misconfigured release now fails.** The old release
> step `sed`'d each key and printed *"unset — keeping the checked-in default"*,
> so a release with a missing variable published a package pointing at whatever
> was committed, silently. `release.yml:56-66` now runs the baker with
> `--strict`, which **hard-fails** the release if *any* of the six variables is
> unset (`scripts/bake-build-config.sh:59-63`). **All six must be set as
> repository variables before the next release.**

Locally (and in CI outside release), running the script without `--strict` falls
back to the checked-in safe public defaults
(`scripts/bake-build-config.sh:31-38`), so `flutter analyze`, the test suite and
a dry-run publish resolve real hosts with no substitution:

```
scripts/bake-build-config.sh            # local — unset vars keep their defaults
scripts/bake-build-config.sh --strict   # what release.yml runs
```

Set the variables with:

```
gh variable set STAGING_ADDRESSIQ_API_BASE_URL --repo PTLRepoHub/addressiq-flutter --body https://…
# …and the other five.
```

## Versioning rules

release-please derives the bump **purely from commit messages**. With
`bump-minor-pre-major: true` (`release-please-config.json:10`) and the package
pre-1.0:

| Commit type | Bump (pre-1.0) |
|---|---|
| `fix:` | patch (`0.5.0 → 0.5.1`) |
| `feat:` | minor (`0.5.0 → 0.6.0`) |
| `feat!:` / `BREAKING CHANGE` | **minor** (not major, while `< 1.0.0`) |

A repo with no Conventional Commits proposes **no release at all**.

Tags are plain `vX.Y.Z` — `include-component-in-tag: false`
(`release-please-config.json:3`) matches the `v*.*.*` trigger in `release.yml`.

**Version note / skew:** current version is `0.5.0`
(`pubspec.yaml:6`, `.release-please-manifest.json:2`, `CHANGELOG.md:3`). The
Flutter SDK is ahead of the other SDKs in the fleet — `RELEASE-ENGINEERING.md`
§1 records it at `0.4.0` (the seed) while web/RN sit at `0.1.0`; it has since
cut `0.5.0`. Keep this in mind when reasoning about cross-SDK/proto version
alignment.

## Local validation

Before merging a release PR (or to sanity-check packaging), run a dry run — it
validates packaging and publishes nothing:

```
dart pub publish --dry-run
# or, equivalently, from a Flutter checkout:
flutter pub publish --dry-run
```

CI performs the same dry run when not publishing for real (`release.yml:70`).

## One-time pub.dev setup

pub.dev **trusted publishing can only be configured on a package that already
exists** (`RELEASE-ENGINEERING.md` §4.D). So, once:

1. **Claim the package with a manual first publish** from a developer machine:
   `dart pub publish` (this is permanent — pub.dev has no unpublish).
2. **Enable automated publishing** on the package's pub.dev admin page,
   pointing at `PTLRepoHub/addressiq-flutter` with tag pattern `v{{version}}`.
3. Set the `PUB_DEV_PUBLISH` repository variable to `true` (above).

After that, every release goes through the automated flow — no manual publish
or tagging.
