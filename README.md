# Plugin POS

Flutter take-home project for a lightweight POS with remote menu control.

## What’s included

- Two Flutter entry points:
  - `lib/main_manager.dart`
  - `lib/main_pos.dart`
- Shared domain, data, and business layers
- Manager UI for menu CRUD and availability toggles
- POS UI for menu browsing and cart totals
- Local mock store so the app can run before Firebase is connected
- Firebase scaffolding:
  - `firebase/firestore.rules`
  - `firebase/firestore.indexes.json`
  - `firebase/storage.rules`

## Project Structure

The project follows the assignment-style layout:

```text
lib/
  core/
  data/
  business/
  modules/
  routes/
  main_manager.dart
  main_pos.dart
```

## How to run

Manager app:

```bash
flutter run -t lib/main_manager.dart
```

POS app:

```bash
flutter run -t lib/main_pos.dart
```

Web:

```bash
flutter run -d chrome -t lib/main_manager.dart
flutter run -d chrome -t lib/main_pos.dart
```

## Architecture Notes

- `core/` contains theme and service helpers.
- `data/` contains models, repositories, and the shared local demo store.
- `business/` contains reusable cart and menu rules.
- `modules/manager` and `modules/pos` hold the feature-specific UI and controllers.
- The manager and POS screens share the same repository/store layer so changes can flow through both views in the demo.

## Firebase Plan

The code includes Firebase service wrappers and Firestore/security-rule files, but the demo currently uses the local shared store so it can be run without backend setup.

To connect Firebase later:

1. Run `flutterfire configure`.
2. Add the generated `firebase_options.dart`.
3. Update `FirebaseService.initialize()` to use `DefaultFirebaseOptions.currentPlatform`.
4. Replace the local repositories with Firestore-backed implementations.

## What I intentionally left for later

- Payments
- Inventory
- Printer integration
- Kitchen display
- Advanced analytics
- Push notifications

## AI tools used

- OpenAI/Codex to help scaffold the project structure, clean up the Flutter code, and write the Firebase scaffolding.
