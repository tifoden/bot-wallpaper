#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP="${BUILD_DIR:-/tmp/bot-wallpaper-release-build}/Bot Wallpaper.app"
PLIST="$APP/Contents/Info.plist"
test -d "$APP"
plutil -lint "$PLIST"
codesign --verify --deep --strict --verbose=2 "$APP"
for binary in "$APP/Contents/MacOS/Bot Wallpaper" "$APP/Contents/Helpers/lock-helper"; do
  ARCHS="$(lipo -archs "$binary")"
  [[ " $ARCHS " == *' arm64 '* && " $ARCHS " == *' x86_64 '* ]]
done
if rg -n "/Users/${USER}/|/tmp/bot-wallpaper" "$PROJECT_DIR/src" "$PROJECT_DIR/Lock Screen Helper Source" -g '*.swift'; then
  echo 'Found machine-specific paths' >&2; exit 1
fi
TMP="$(mktemp -d -t bot-wallpaper-verify)"
trap 'rm -rf "$TMP"' EXIT
ditto -c -k --sequesterRsrc --keepParent "$APP" "$TMP/update.zip"
SIGNER="$PROJECT_DIR/vendor/bin/sign_update"
SIG="$("$SIGNER" --account tifoden.bot-wallpaper -p "$TMP/update.zip")"
"$SIGNER" --account tifoden.bot-wallpaper --verify "$TMP/update.zip" "$SIG"
printf 'tampered' >> "$TMP/update.zip"
if "$SIGNER" --account tifoden.bot-wallpaper --verify "$TMP/update.zip" "$SIG" >/dev/null 2>&1; then
  echo 'Signature verification unexpectedly accepted a modified archive' >&2; exit 1
fi
echo 'Signature verification rejects modified updates.'
echo 'Build checks passed.'
