#!/usr/bin/env bash
# Build do APK San1tyPay com a URL do backend embutida.
# Uso:
#   ./build_apk.sh debug http://192.168.X.X:8000     # teste local (HTTP liberado no debug)
#   ./build_apk.sh release https://xxx.trycloudflare.com  # tunnel/HTTPS
set -euo pipefail

MODE="${1:-debug}"
API_URL="${2:-}"
if [ -z "$API_URL" ]; then
  echo "Uso: $0 <debug|release> <API_BASE_URL>" >&2
  exit 1
fi

cd "$(dirname "$0")"

echo "==> flutter analyze"
flutter analyze --no-pub

echo "==> build apk ($MODE) -> $API_URL"
if [ "$MODE" = "release" ]; then
  flutter build apk --release --dart-define=API_BASE_URL="$API_URL"
else
  flutter build apk --debug --dart-define=API_BASE_URL="$API_URL"
fi

echo "==> OK:"
ls -la build/app/outputs/flutter-apk/*.apk
