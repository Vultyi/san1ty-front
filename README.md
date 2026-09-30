# San1ty Front — San1ty Pay (Flutter)

App Flutter do San1ty Pay: carteira, PIX, commerce, suporte e admin.

## Requisitos
- Flutter stable (SDK ^3.10.0)
- Java 17 para build Android

## Rodar em dev
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://api.san1typay.com
```

## Build APK
```bash
# debug local
./build_apk.sh debug https://api.san1typay.com

# release (assinatura release configurada via android/key.properties no CI)
flutter build apk --release --dart-define=API_BASE_URL=https://api.san1typay.com --build-number=<N>
```

Artefato: `build/app/outputs/flutter-apk/app-release.apk`

## Estrutura
- `lib/` — app (screens, services, core/security, theme, widgets)
- `android/` — host Android (`applicationId: com.san1ty.estrutura_front_san1ty`)
- `ios/`, `web/` — hosts secundários

## Segurança / assinatura
- Nunca commitar `*.jks`, `*.keystore`, `android/key.properties` ou `.env`.
- Release no CI usa secrets `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`.
- `android/.gitignore` já ignora `key.properties` e keystores.

## Backend
Base URL via `--dart-define=API_BASE_URL` (default `https://api.san1typay.com` em `lib/core/security/api_security_service.dart`).
