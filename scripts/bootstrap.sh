#!/bin/bash
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SPARKLE_VERSION=2.10.1
EXPECTED=1a856d2a9edb8e628de88121d7be04cf0e2167f8641650b78fca00b14244cf27
ARCHIVE="$(mktemp -t sparkle-archive)"
trap 'rm -f "$ARCHIVE"' EXIT
curl -fLsS "https://github.com/sparkle-project/Sparkle/releases/download/$SPARKLE_VERSION/Sparkle-$SPARKLE_VERSION.tar.xz" -o "$ARCHIVE"
ACTUAL="$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')"
if [[ "$ACTUAL" != "$EXPECTED" ]]; then echo 'Sparkle checksum mismatch' >&2; exit 1; fi
mkdir -p "$PROJECT_DIR/vendor"
tar -xJf "$ARCHIVE" -C "$PROJECT_DIR/vendor"
