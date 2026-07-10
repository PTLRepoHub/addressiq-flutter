# AddressIQ Flutter — Sample App

A small Flutter app that shows the AddressIQ SDK end to end: log in, open the
address widget, and start a verification.

The UI is the shared AddressIQ web widget hosted in a `webview_flutter` view. This
app supplies the native pieces (location permission, the API config) and reads
back the result.

## Run it

This folder ships only the Dart code, so the first time you need to generate the
platform runner projects (`android/`, `ios/`, …):

```bash
cd addressiq-flutter/example
flutter create .           # first time only — generates the platform folders
flutter pub get
flutter run
```

## Configure it

Config is passed with `--dart-define` (so nothing sensitive is committed):

```bash
# Use the hosted API (default)
flutter run

# Point at a local sample server (Android emulator)
flutter run --dart-define=API_URL=http://10.0.2.2:3355

# iOS simulator
flutter run --dart-define=API_URL=http://localhost:3355
```

Available defines: `API_URL`, `API_KEY`, `SESSION_TOKEN`, `BUSINESS_NAME`.
`BUSINESS_NAME` is only a fallback — the widget fetches the real business
name/logo/colour from the backend.

## Run against the local backend

The `addressiq-node-backend` package is the AddressIQ **Node server SDK**, with a
sample `server.js` you can run as your server. It talks to the real AddressIQ API
(the `geo-tagging` app on `http://localhost:4000`) — or serves fake data offline.

1. Start the sample server:
   ```bash
   cd addressiq-node-backend
   node server.js                 # real: forwards to your local AddressIQ API (:4000)
   #   …or for offline fake data:
   MOCK_UPSTREAM=1 node server.js
   ```
   It listens on `http://localhost:3355`.
2. Run the app with `--dart-define=API_URL=…` pointing at it (see above).

> `10.0.2.2` is the Android emulator's alias for your computer's `localhost`; the
> iOS simulator uses `localhost` directly; a real device uses your LAN IP.

## Note on the code

`lib/main.dart` is self-contained. The other files under `lib/` (`app_state.dart`,
`result_modal.dart`, `screens/`) are leftovers from an earlier structure and are
not used — safe to delete.
