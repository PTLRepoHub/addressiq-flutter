// Generated build-time configuration — DO NOT EDIT BY HAND.
//
// Rewritten wholesale by `scripts/bake-build-config.sh` at publish time from
// the GitHub repository variables (see .github/workflows/release.yml):
//
//   STAGING_ADDRESSIQ_API_BASE_URL     PROD_ADDRESSIQ_API_BASE_URL
//   STAGING_ADDRESSIQ_INGEST_BASE_URL  PROD_ADDRESSIQ_INGEST_BASE_URL
//   STAGING_ADDRESSIQ_CDN_BASE_URL     PROD_ADDRESSIQ_CDN_BASE_URL
//
// TWO further constants are baked from FILES at the repo root rather than from
// the environment — `.widget-version` and `.widget-integrity`, written by the
// widget-fanout workflow in addressiq-web on every web release alongside the
// vendored assets/iqcollect.js. They pin the CDN copy of the widget
// (`{cdn}/v{version}/iqcollect.js` + its SRI hash). When the files are absent
// both constants bake to '' and the SDK simply inlines the bundled widget.
//
// The checked-in values below are the safe public defaults, so a local
// `flutter analyze`, the test suite and a dry-run publish resolve real hosts
// with no substitution. On a real release the baker runs with --strict and
// REQUIRES every variable above — a published package must never silently
// carry a developer's default. (pub ships source, so these constants are
// exactly what integrators get.)
//
// `development` is deliberately NOT baked from CI: it points at the host
// machine's backend, so it is a local-only concern and stays a compile-time
// literal in `lib/src/api/deployment.dart`. Never ship a build configured for
// `development`.
const String kStagingApiUrl = 'https://api-staging.addressiqpro.com';
const String kStagingIngestUrl = 'https://ingest-api-staging.addressiqpro.com';
const String kStagingCdnUrl = 'https://cdn-staging.addressiqpro.com';

const String kProdApiUrl = 'https://api.addressiqpro.com';
const String kProdIngestUrl = 'https://ingest-api.addressiqpro.com';
const String kProdCdnUrl = 'https://cdn.addressiqpro.com';

/// Version of the widget published to the CDN, WITHOUT the leading `v`
/// (e.g. `0.4.0`). Baked from the `.widget-version` file; `''` when absent.
const String kWidgetVersion = '';

/// Subresource-Integrity hash of `{cdn}/v$kWidgetVersion/iqcollect.js`
/// (e.g. `sha384-…`). Baked from the `.widget-integrity` file; `''` when absent.
const String kWidgetIntegrity = '';
