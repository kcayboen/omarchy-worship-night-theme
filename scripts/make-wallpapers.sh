#!/bin/bash
# Rebuilds wallpapers 1 to 6 with ImageMagick 7.
# Needs the Noto Serif fonts (noto-fonts on Arch).
set -euo pipefail

D="$(cd "$(dirname "$0")/.." && pwd)/backgrounds"
mkdir -p "$D"
W=2560; H=1440

# 1. Stage lights
magick -size ${W}x${H} gradient:'#141a2e'-'#07090f' \
  \( -size ${W}x${H} xc:none -fill '#e8a64a55' -draw "ellipse 640,-100 380,900 0,360" -blur 0x140 \) -composite \
  \( -size ${W}x${H} xc:none -fill '#f2c46d44' -draw "ellipse 1280,-150 320,1000 0,360" -blur 0x160 \) -composite \
  \( -size ${W}x${H} xc:none -fill '#e8924a55' -draw "ellipse 1920,-100 380,900 0,360" -blur 0x140 \) -composite \
  -attenuate 0.15 +noise Gaussian \
  -quality 90 "$D/1-stage-lights.webp"

# 2. Cross at dawn
magick -size ${W}x${H} gradient:'#0b0e18'-'#3a2626' \
  \( -size ${W}x${H} xc:none -fill '#e8a64acc' -draw "ellipse 1280,1080 1000,360 0,360" -blur 0x200 \) -composite \
  \( -size ${W}x${H} xc:none -fill '#f8d68f99' -draw "ellipse 1280,1080 380,150 0,360" -blur 0x120 \) -composite \
  -fill '#07090f' -draw "ellipse 1280,1500 1700,420 0,360" \
  -draw "rectangle 1266,690 1294,1100" \
  -draw "rectangle 1170,790 1390,816" \
  -quality 90 "$D/2-cross-at-dawn.webp"

# 3. Three crosses at dusk
magick -size ${W}x${H} gradient:'#0f1320'-'#4a2a33' \
  \( -size ${W}x${H} xc:none -fill '#e8924acc' -draw "ellipse 1280,1100 1200,320 0,360" -blur 0x220 \) -composite \
  \( -size ${W}x${H} xc:none -fill '#c48ac966' -draw "ellipse 1280,700 1400,300 0,360" -blur 0x240 \) -composite \
  -fill '#07090f' -draw "ellipse 1280,1500 1700,420 0,360" \
  -draw "rectangle 1266,660 1294,1100" -draw "rectangle 1170,760 1390,786" \
  -draw "rectangle 989,830 1011,1100" -draw "rectangle 925,900 1075,920" \
  -draw "rectangle 1549,830 1571,1100" -draw "rectangle 1485,900 1635,920" \
  -quality 90 "$D/3-three-crosses.webp"

# Verse helper: text, reference, pointsize, reference y offset, output
verse() {
  magick -size ${W}x${H} radial-gradient:'#1c2233'-'#07090f' \
    \( -size ${W}x${H} xc:none -fill '#e8a64a33' -draw "ellipse 1280,620 900,420 0,360" -blur 0x220 \) -composite \
    \( -background none -fill '#f2c46d' -font Noto-Serif-Light-Italic -pointsize "$3" \
       -interline-spacing 18 -gravity center label:"$1" \
       \( +clone -blur 0x22 \) +swap -background none -layers merge +repage \) \
    -gravity center -geometry +0-80 -composite \
    -font Noto-Serif-Regular -pointsize 38 -kerning 8 -fill '#d6ccb6' \
    -annotate +0+"$4" "$2" -quality 90 "$5"
}

# 4. Psalm 119:105 (KJV)
verse $'Thy word is a lamp unto my feet,\nand a light unto my path.' \
  "PSALM 119:105" 96 160 "$D/4-lamp-unto-my-feet.webp"

# 5. John 8:12 (KJV)
verse $'I am the light of the world:\nhe that followeth me shall not walk in darkness,\nbut shall have the light of life.' \
  "JOHN 8:12" 80 200 "$D/5-light-of-the-world.webp"

# 6. Alpha and Omega
magick -size ${W}x${H} radial-gradient:'#1c2233'-'#07090f' \
  \( -size ${W}x${H} xc:none -fill '#e8a64a44' -draw "ellipse 1280,720 800,500 0,360" -blur 0x220 \) -composite \
  \( -size ${W}x${H} xc:none -fill '#f2c46d' -font Noto-Serif-Light -pointsize 520 -gravity center \
     -annotate -560+0 'Α' -annotate +560+0 'Ω' \
     -draw "rectangle 1274,470 1286,970" -draw "rectangle 1200,600 1360,612" \
     \( +clone -blur 0x30 \) +swap -background none -layers merge +repage \) -composite \
  -quality 90 "$D/6-alpha-omega.webp"

echo "Done: $D"
