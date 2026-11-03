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
/usr/bin/python3 - "$PROJECT_DIR" <<'PYTHON'
import os, pathlib, sys
root = pathlib.Path(sys.argv[1])
needles = (f"/Users/{os.environ.get('USER', '')}/", "/tmp/bot-wallpaper")
for directory in (root / "src", root / "Lock Screen Helper Source"):
    for path in directory.rglob("*.swift"):
        content = path.read_text()
        if any(needle in content for needle in needles):
            raise SystemExit(f"Found a machine-specific path in {path}")
PYTHON
if command -v ffmpeg >/dev/null && command -v ffprobe >/dev/null; then
  python3 "$PROJECT_DIR/tests/check_loop.py" "$PROJECT_DIR/resources/Grok Bot.mp4"
  python3 "$PROJECT_DIR/tests/check_loop.py" "$PROJECT_DIR/resources/Lock Screen Source.mp4"
  python3 "$PROJECT_DIR/tests/check_loop.py" "$PROJECT_DIR/resources/Lock Screen Prepared.mov"
else
  echo 'Loop checks skipped: ffmpeg and ffprobe are not installed.'
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
