# SSA POS

Flutter POS app with environment-based Android flavors.

## Flavors

- `dev` -> application id suffix: `.dev`
- `staging` -> application id suffix: `.staging`
- `prod` -> production package

## Environment Files

This project uses compile-time environment values with `--dart-define-from-file`.

1. Copy templates and create local files:
   - `.env.dev.example` -> `.env.dev`
   - `.env.staging.example` -> `.env.staging`
   - `.env.prod.example` -> `.env.prod`
2. Put real values only in local `.env.*` files.
3. `.env.*` files are gitignored to prevent leaking secrets.

## Run Commands

```bash
flutter pub get

flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=.env.dev
flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=.env.staging
flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=.env.prod
```

## Build Commands

```bash
flutter build apk --flavor dev -t lib/main_dev.dart --dart-define-from-file=.env.dev
flutter build apk --flavor staging -t lib/main_staging.dart --dart-define-from-file=.env.staging
flutter build apk --flavor prod -t lib/main_prod.dart --dart-define-from-file=.env.prod
```

## Security Notes

- Do not commit `.env`, `.env.*`, `android/key.properties`, `.jks`, or `.keystore`.
- Use CI/CD secret storage for production environment values and signing keys.
