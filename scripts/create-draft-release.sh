#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
: "${GITHUB_REPOSITORY:?Set GITHUB_REPOSITORY to owner/repository}"
: "${VERSION:?Set VERSION}"
if [[ ! "$GITHUB_REPOSITORY" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ || ! "$VERSION" =~ ^[0-9]+(\.[0-9]+){1,2}$ ]]; then echo 'Invalid repository/version' >&2; exit 1; fi
OUT="${RELEASE_DIR:-$PROJECT_DIR/release}"
test -f "$OUT/Bot-Wallpaper-$VERSION.zip"
test -f "$OUT/appcast.xml"
gh release create "v$VERSION" --repo "$GITHUB_REPOSITORY" --draft --title "Bot Wallpaper $VERSION" "$OUT/Bot-Wallpaper-$VERSION.zip" "$OUT/appcast.xml"
