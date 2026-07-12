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

Credentials are passed with `--dart-define` (so nothing sensitive is committed).
The API host is **not** configurable — it is resolved from the environment you
pick on the Login screen (`sandbox` / `production` / `staging` / `development`):

```bash
# Uses the environment selected on the Login screen to resolve the host
flutter run
```

Available defines: `API_KEY`, `SESSION_TOKEN`, `BUSINESS_NAME`.
`BUSINESS_NAME` is only a fallback — the widget fetches the real business
name/logo/colour from the backend.

To hit a local backend, choose the **Development** environment on the Login
screen. It resolves to `http://localhost:3355`, and on the Android emulator
automatically uses `http://10.0.2.2:3355`.

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
2. Launch the app and pick the **Development** environment on the Login screen —
   the SDK resolves the local `:3355` host automatically.

> `10.0.2.2` is the Android emulator's alias for your computer's `localhost` (the
> SDK selects it automatically for `development`); the iOS simulator uses
> `localhost` directly. A real device needs your LAN IP, which the built-in
> `development` mapping does not cover.

## Note on the code

`lib/main.dart` is self-contained. The other files under `lib/` (`app_state.dart`,
`result_modal.dart`, `screens/`) are leftovers from an earlier structure and are
not used — safe to delete.
