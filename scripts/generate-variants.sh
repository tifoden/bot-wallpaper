#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HELPER="${LOCK_HELPER:-/tmp/bot-wallpaper-release-build/Bot Wallpaper.app/Contents/Helpers/lock-helper}"
SOURCE="$PROJECT_DIR/resources/Grok Bot.mp4"
DEST="$PROJECT_DIR/resources/Variants"
test -x "$HELPER" || { echo 'Build the app first or set LOCK_HELPER to its lock-helper executable.' >&2; exit 1; }
TMP="$(mktemp -d -t bot-wallpaper-variants)"
trap 'rm -rf "$TMP"' EXIT
for entry in red:16721468 orange:16738048 amber:16750592 green:51570 teal:48294 blue:1082622 purple:9525758 pink:16724123 outline:16777216; do
  name="${entry%%:*}"
  color="${entry##*:}"
  "$HELPER" render "$SOURCE" "$TMP/$name.mov" "$color" 0
done
mkdir -p "$DEST"
for file in "$TMP"/*.mov; do mv -f "$file" "$DEST/"; done
