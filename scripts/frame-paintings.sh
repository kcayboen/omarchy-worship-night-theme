#!/bin/bash
# Downloads the two public domain paintings from Wikimedia Commons and frames
# them as 2560x1440 wallpapers: painting centered, blurred navy sides, warm tint.
set -euo pipefail

D="$(cd "$(dirname "$0")/.." && pwd)/backgrounds"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
UA="omarchy-worship-night-theme/1.0"

curl -sfL -A "$UA" -o "$TMP/bloch.jpg" \
  'https://thumb.wikimedia.org/wikipedia/commons/thumb/9/9c/Carl_Bloch_-_The_Sermon_on_the_Mount.jpg/3840px-Carl_Bloch_-_The_Sermon_on_the_Mount.jpg'
curl -sfL -A "$UA" -o "$TMP/hofmann.jpg" \
  'https://upload.wikimedia.org/wikipedia/commons/6/68/Christ_in_Gethsemane.jpg'

paint() {
  magick "$1" -resize 2560x1440^ -gravity center -extent 2560x1440 -blur 0x50 -modulate 35,70 \
    -fill '#0f1320' -colorize 45% \
    \( "$1" -resize x1340 -modulate 88,85 -fill '#e8a64a' -colorize 8% \
       -bordercolor '#07090f' -border 2 \
       \( +clone -background black -shadow 80x30+0+0 \) +swap -background none -layers merge +repage \) \
    -gravity center -composite \
    \( -size 2560x1440 radial-gradient:none-'#07090fb0' \) -composite \
    -quality 90 "$2"
}

paint "$TMP/bloch.jpg"   "$D/7-sermon-on-the-mount.webp"
paint "$TMP/hofmann.jpg" "$D/8-christ-in-gethsemane.webp"

echo "Done: $D"
