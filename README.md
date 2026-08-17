# Plugin POS

Flutter take-home: two apps (Manager + POS) sharing a Firestore menu and order stream.

## What’s included

- Two Flutter entry points:
  - `lib/main_manager.dart`
  - `lib/main_pos.dart`
- Shared models, cart rules, and repositories
- Manager: create / edit / delete items, toggle sold out, live order list
- POS: venue activation, menu with name / price / category / availability, cart + tax total
- Firestore `snapshots()` for live Manager → POS sync
- Local in-memory fallback if Firebase is unavailable (single process only)
- Firestore rules at `firebase/firestore.rules`

## How to run

This machine needs Flutter 3.27+ (Dart 3.9+). Check with `flutter --version`.

### 1. Start the Firestore emulator (required for two-app sync)

```bash
cd POSDevices
firebase emulators:start --only firestore
```

Emulator UI: http://127.0.0.1:4000

### 2. Install packages

```bash
flutter pub get
```

### 3. Run both apps

Terminal A — Manager:

```bash
flutter run -d chrome -t lib/main_manager.dart
```

Terminal B — POS:

```bash
flutter run -d chrome -t lib/main_pos.dart
```

Demo login: any non-empty email + password.  
Demo POS code: `COPPERFOX`

### Live demo path

1. Manager: add a menu item or mark one sold out.
2. POS: the card appears, updates, or shows Sold Out without a refresh.
3. POS: add items to the cart and place the order.
4. Manager: the order shows on the Orders tab.

## Architecture

```text
lib/
  core/          theme, Firebase init, Firestore paths
  data/          models, Firestore repositories, demo seed
  business/      cart totals and menu rules
  modules/manager
  modules/pos
  routes/
  main_manager.dart
  main_pos.dart
```

- GetX controllers subscribe to `menu_items`, `categories`, `orders`, and `devices` query snapshots.
- Writes (CRUD, availability, place order) go to Firestore so the other app’s stream updates.
- Queries filter by `venueId` and sort in memory to avoid composite indexes.

### Firestore shape

```text
venues/{venueId}
categories/{categoryId}     venueId, name, order
menu_items/{itemId}         venueId, name, price, categoryId, available
orders/{orderId}            venueId, items[], subtotal, total, status, createdAt
devices/{deviceId}          venueId, name, status
```

Default venue id: `venue_001`.

Apps connect to the emulator by default (`USE_FIRESTORE_EMULATOR=true`). To use a real Firebase project:

1. `dart pub global activate flutterfire_cli`
2. `flutterfire configure` (overwrites `lib/firebase_options.dart`)
3. `firebase deploy --only firestore:rules`
4. Run with `--dart-define=USE_FIRESTORE_EMULATOR=false`

## Tradeoffs / skipped

- Firebase Auth is stubbed for the demo login. Rules are open so emulator POS/Manager can share data without users.
- Payments, inventory, printers, KDS, analytics, and push notifications are out of scope.
- Screen recording is still a submission step (record Manager + POS side by side).

## Tests

```bash
flutter test
```

## AI tools used

- Cursor to wire Firestore streams, activation/login flows, and this README.
- Earlier scaffolding used OpenAI/Codex for folder structure and UI.
