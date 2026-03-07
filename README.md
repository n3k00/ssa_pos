# SSA POS

Flutter POS application (Android-first) with flavor-based environments, Riverpod state management, and clean feature-first structure.

## Prerequisites

- Flutter `3.41.2` (or compatible 3.41.x)
- Dart `3.11.0`
- Android Studio + Android SDK
- A connected Android device or emulator

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Create local env files from templates:

- `.env.dev.example` -> `.env.dev`
- `.env.staging.example` -> `.env.staging`
- `.env.prod.example` -> `.env.prod`

3. Update env values for your environment.

## Run

```bash
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=.env.dev
flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=.env.staging
flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=.env.prod
```

## Build APK

```bash
flutter build apk --flavor dev -t lib/main_dev.dart --dart-define-from-file=.env.dev
flutter build apk --flavor staging -t lib/main_staging.dart --dart-define-from-file=.env.staging
flutter build apk --flavor prod -t lib/main_prod.dart --dart-define-from-file=.env.prod
```

## Architecture

This project uses:

- Feature-first + clean layering (`data/domain/presentation` inside features)
- Shared core services (`db/network/printer/sync/logging`)
- Design system tokens (`colors/dimens/text styles/theme`)
- Riverpod for dependency injection and state management
- Global app bootstrap for flavor config and error handling

High-level structure:

```text
lib/
  app/
    config/
    constants/
    router/
    theme/
    app.dart
    design_system.dart
  core/
    db/
    logging/
    network/
    printer/
    sync/
  features/
    auth/
    order/
    pos/
    product/
    receipt/
    settings/
  shared/
    providers/
    widgets/
  main.dart
  main_dev.dart
  main_staging.dart
  main_prod.dart
```

## Folder Rules

- Put business logic in `features/<feature>/domain` and `features/<feature>/data`.
- Keep UI-only code in `features/<feature>/presentation`.
- Reusable app-wide services go to `lib/core`.
- Reusable widgets/providers go to `lib/shared`.
- Use only design tokens from `lib/app/design_system.dart`; avoid hardcoded colors/sizes/strings in screens.
- Keep environment and bootstrap concerns in `lib/app/config` and `lib/bootstrap.dart`.

## Security

- Never commit real `.env` files.
- Never commit `android/key.properties`, `.jks`, or `.keystore`.
- Use secret storage (CI/CD or local secure vault) for production values.

## Quality Checks

Run before pushing:

```bash
flutter analyze
flutter test
```
