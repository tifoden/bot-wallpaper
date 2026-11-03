#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
: "${GITHUB_REPOSITORY:?Set GITHUB_REPOSITORY to owner/repository}"
: "${VERSION:?Set VERSION, for example 1.0.0}"
: "${BUILD_NUMBER:?Set BUILD_NUMBER to an increasing integer}"
: "${SIGNING_IDENTITY:?Set SIGNING_IDENTITY to the Developer ID Application certificate name}"
: "${NOTARY_PROFILE:?Set NOTARY_PROFILE to a notarytool keychain profile}"
if [[ ! "$GITHUB_REPOSITORY" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then echo 'Invalid GITHUB_REPOSITORY' >&2; exit 1; fi
if [[ ! "$VERSION" =~ ^[0-9]+(\.[0-9]+){1,2}$ || ! "$BUILD_NUMBER" =~ ^[0-9]+$ ]]; then echo 'Invalid version/build' >&2; exit 1; fi
export FEED_URL="https://github.com/$GITHUB_REPOSITORY/releases/latest/download/appcast.xml"
"$PROJECT_DIR/scripts/build.sh"
APP="${BUILD_DIR:-/tmp/bot-wallpaper-release-build}/Bot Wallpaper.app"
OUT="${RELEASE_DIR:-$PROJECT_DIR/release}"
mkdir -p "$OUT"
ARCHIVE="$OUT/Bot-Wallpaper-$VERSION.zip"
STAGING_DIR="$(mktemp -d -t bot-wallpaper-notary)"
STAGING="$STAGING_DIR/notary.zip"
trap 'rm -rf "$STAGING_DIR"' EXIT
ditto -c -k --sequesterRsrc --keepParent "$APP" "$STAGING"
xcrun notarytool submit "$STAGING" --keychain-profile "$NOTARY_PROFILE" --wait
xcrun stapler staple "$APP"
xcrun stapler validate "$APP"
codesign --verify --deep --strict "$APP"
spctl --assess --type execute --verbose "$APP"
ditto -c -k --sequesterRsrc --keepParent "$APP" "$ARCHIVE"
mkdir -p "$STAGING_DIR/feed"
cp "$ARCHIVE" "$STAGING_DIR/feed/"
"$PROJECT_DIR/vendor/bin/generate_appcast" --account tifoden.bot-wallpaper --download-url-prefix "https://github.com/$GITHUB_REPOSITORY/releases/download/v$VERSION/" "$STAGING_DIR/feed"
cp "$STAGING_DIR/feed/appcast.xml" "$OUT/appcast.xml"
echo "Prepared $ARCHIVE and $OUT/appcast.xml. Review before publishing."
