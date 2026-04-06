#!/bin/bash
# NameCraft Release Script
# Usage: ./release.sh 1.2.0
#
# Prerequisites:
#   - Sparkle EdDSA private key must be in your Keychain (generated via generate_keys)
#   - gh CLI installed and authenticated (brew install gh && gh auth login)
#   - Xcode Command Line Tools installed

set -e

VERSION="${1:?Usage: ./release.sh <version>  e.g. ./release.sh 1.2.0}"
DMG_NAME="NameCraft-${VERSION}.dmg"
APP_NAME="NameCraft"
BUNDLE_ID="com.gilavi.NameCraft"
SPARKLE_BIN=".build/artifacts/sparkle/Sparkle/bin"
REPO="gilavi/AdNameGenie"

echo "==> Building NameCraft v${VERSION}"

# 1. Bump version in source Info.plist
sed -i '' \
  "s/<string>[0-9]*\.[0-9]*\.[0-9]*<\/string>/<string>${VERSION}<\/string>/g" \
  Sources/AdNameGenie/Resources/Info.plist

# 2. Build release binary
swift build --configuration release

# 3. Assemble app bundle
rm -rf "${APP_NAME}.app"
mkdir -p "${APP_NAME}.app/Contents/MacOS"
mkdir -p "${APP_NAME}.app/Contents/Frameworks"
mkdir -p "${APP_NAME}.app/Contents/Resources"

cp .build/arm64-apple-macosx/release/AdNameGenie "${APP_NAME}.app/Contents/MacOS/${APP_NAME}"
cp Sources/AdNameGenie/Resources/Info.plist "${APP_NAME}.app/Contents/Info.plist"
cp Sources/AdNameGenie/Resources/NameCraft.icns "${APP_NAME}.app/Contents/Resources/"

# Copy Sparkle framework
cp -R .build/arm64-apple-macosx/release/Sparkle.framework "${APP_NAME}.app/Contents/Frameworks/"

echo "==> Creating DMG: ${DMG_NAME}"

# 4. Create DMG
rm -f "${DMG_NAME}"
hdiutil create -volname "NameCraft" \
  -srcfolder "${APP_NAME}.app" \
  -ov -format UDZO \
  "${DMG_NAME}"

DMG_SIZE=$(stat -f "%z" "${DMG_NAME}")

# 5. Sign the DMG with Sparkle
echo "==> Signing DMG..."
SIGN_OUTPUT=$("${SPARKLE_BIN}/sign_update" "${DMG_NAME}")
ED_SIGNATURE=$(echo "${SIGN_OUTPUT}" | grep -o 'sparkle:edSignature="[^"]*"' | cut -d'"' -f2)
echo "    edSignature: ${ED_SIGNATURE}"

# 6. Update appcast.xml
PUB_DATE=$(date -u "+%a, %d %b %Y %H:%M:%S +0000")
cat > docs/appcast.xml << APPCAST
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <channel>
    <title>NameCraft</title>
    <link>https://gilavi.github.io/AdNameGenie/</link>
    <description>NameCraft update feed</description>
    <language>en</language>

    <item>
      <title>Version ${VERSION}</title>
      <pubDate>${PUB_DATE}</pubDate>
      <sparkle:releaseNotesLink>https://gilavi.github.io/AdNameGenie/release-notes/${VERSION}.html</sparkle:releaseNotesLink>
      <enclosure
        url="https://github.com/${REPO}/releases/download/v${VERSION}/${DMG_NAME}"
        sparkle:version="${VERSION}"
        sparkle:shortVersionString="${VERSION}"
        sparkle:edSignature="${ED_SIGNATURE}"
        length="${DMG_SIZE}"
        type="application/octet-stream" />
    </item>

  </channel>
</rss>
APPCAST

echo "==> Committing and pushing appcast.xml..."
git add docs/appcast.xml Sources/AdNameGenie/Resources/Info.plist
git commit -m "Release v${VERSION}"
git push origin main

# 7. Create GitHub Release and upload DMG
echo "==> Creating GitHub Release v${VERSION}..."
gh release create "v${VERSION}" "${DMG_NAME}" \
  --repo "${REPO}" \
  --title "NameCraft v${VERSION}" \
  --notes "NameCraft v${VERSION}" \
  --latest

echo ""
echo "✓ Released NameCraft v${VERSION}"
echo "  Appcast: https://gilavi.github.io/AdNameGenie/appcast.xml"
echo "  Release: https://github.com/${REPO}/releases/tag/v${VERSION}"
