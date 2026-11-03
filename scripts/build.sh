#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-/tmp/bot-wallpaper-release-build}"
APP="$BUILD_DIR/Bot Wallpaper.app"
SPARKLE="$PROJECT_DIR/vendor/Sparkle.framework"
: "${FEED_URL:?Set FEED_URL to the HTTPS appcast URL before building}"
case "$FEED_URL" in https://*) ;; *) echo 'FEED_URL must use HTTPS' >&2; exit 1;; esac
VERSION="${VERSION:-1.0.0}"
BUILD_NUMBER="${BUILD_NUMBER:-1}"
PUBLIC_KEY="${PUBLIC_KEY:-FDXn44+pVJ1rvZuXW7CJ30GG8QOsrTSJlda91kjSAXk=}"
IDENTITY="${SIGNING_IDENTITY:--}"
mkdir -p "$BUILD_DIR"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$APP/Contents/Frameworks" "$APP/Contents/Helpers" "$BUILD_DIR/objects"
ditto "$SPARKLE" "$APP/Contents/Frameworks/Sparkle.framework"
ditto "$PROJECT_DIR/resources" "$APP/Contents/Resources"
cp "$PROJECT_DIR/vendor/LICENSE" "$APP/Contents/Resources/Sparkle-LICENSE.txt"
mkdir -p "$APP/Contents/Resources/Lock Screen Helper Source"
ditto "$PROJECT_DIR/Lock Screen Helper Source" "$APP/Contents/Resources/Lock Screen Helper Source"
for arch in arm64 x86_64; do
  xcrun swiftc -target "$arch-apple-macos13.0" -F "$PROJECT_DIR/vendor" -framework Sparkle -Xlinker -rpath -Xlinker @executable_path/../Frameworks "$PROJECT_DIR/src/Wallpaper.swift" "$PROJECT_DIR/src/AppInstaller.swift" -o "$BUILD_DIR/objects/main-$arch"
  xcrun swiftc -parse-as-library -target "$arch-apple-macos26.0" "$PROJECT_DIR/Lock Screen Helper Source/LockScreenVideoRenderer.swift" "$PROJECT_DIR/Lock Screen Helper Source/WallpaperStore.swift" "$PROJECT_DIR/Lock Screen Helper Source/AerialTemporalEncoder.swift" "$PROJECT_DIR/Lock Screen Helper Source/MacOS26LockScreenInstaller.swift" "$PROJECT_DIR/Lock Screen Helper Source/bot-motion-cli.swift" -o "$BUILD_DIR/objects/lock-$arch"
done
lipo -create "$BUILD_DIR/objects/main-arm64" "$BUILD_DIR/objects/main-x86_64" -output "$APP/Contents/MacOS/Bot Wallpaper"
lipo -create "$BUILD_DIR/objects/lock-arm64" "$BUILD_DIR/objects/lock-x86_64" -output "$APP/Contents/Helpers/lock-helper"
/usr/bin/python3 - "$APP/Contents/Info.plist" "$FEED_URL" "$VERSION" "$BUILD_NUMBER" "$PUBLIC_KEY" <<'PY'
import plistlib,sys
out,feed,version,build,key=sys.argv[1:]
data={'CFBundleName':'Bot Wallpaper','CFBundleDisplayName':'Bot Wallpaper','CFBundleIconFile':'AppIcon','CFBundleExecutable':'Bot Wallpaper','CFBundleIdentifier':'com.tifoden.botwallpaper','CFBundlePackageType':'APPL','CFBundleShortVersionString':version,'CFBundleVersion':build,'LSMinimumSystemVersion':'13.0','LSUIElement':True,'NSHighResolutionCapable':True,'SUFeedURL':feed,'SUPublicEDKey':key,'SUEnableAutomaticChecks':True,'SUAutomaticallyUpdate':True}
with open(out,'wb') as f: plistlib.dump(data,f)
PY
xattr -cr "$APP"
FRAMEWORK="$APP/Contents/Frameworks/Sparkle.framework/Versions/B"
if [[ "$IDENTITY" = '-' ]]; then
  SIGN_ARGS=(--force --sign -)
else
  SIGN_ARGS=(--force --sign "$IDENTITY" --options runtime --timestamp)
fi
codesign "${SIGN_ARGS[@]}" "$FRAMEWORK/Autoupdate"
codesign "${SIGN_ARGS[@]}" "$FRAMEWORK/Updater.app"
codesign "${SIGN_ARGS[@]}" "$FRAMEWORK/XPCServices/Downloader.xpc"
codesign "${SIGN_ARGS[@]}" "$FRAMEWORK/XPCServices/Installer.xpc"
codesign "${SIGN_ARGS[@]}" "$APP/Contents/Frameworks/Sparkle.framework"
codesign "${SIGN_ARGS[@]}" "$APP/Contents/Helpers/lock-helper"
codesign "${SIGN_ARGS[@]}" "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"
echo "Built: $APP"
