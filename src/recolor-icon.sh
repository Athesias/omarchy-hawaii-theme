#!/bin/bash
# Repaint a Yaru folder icon with the Hawaii sunset gradient: purple at the top,
# orange at the bottom. Hue and saturation come from the gradient, lightness from
# the original, so Yaru's shading, bevels and drop shadow all survive intact.
set -euo pipefail

src="$1"; dst="$2"

# Sunset stops, top to bottom. Routed through rose so the purple->orange
# midpoint stays saturated instead of going muddy grey.
STOPS=(\#8f2ae8 \#b524c9 \#e81c72 \#ff4a1a \#ff8800)

# Yaru's folder art is a light pastel, and lightness is taken from it below.
# Left alone that washes the gradient out no matter how saturated the stops are,
# so pull the midtones down: this is what makes the colour read deep rather than
# chalky. Gentle enough that the darker inset glyphs keep their contrast.
LCURVE=(-level 0%,112%,0.76)

read -r W H <<<"$(magick "$src" -format '%w %h' info:)"
# Fit the gradient to the icon's visible bounds, not the padded canvas, so the
# full colour range lands on the folder itself.
geom=$(magick "$src" -format '%@' info:)          # e.g. 484x412+14+54
bh=${geom#*x}; bh=${bh%%+*}                        # bounding-box height
by=${geom##*+}                                     # bounding-box y offset
(( bh < 1 )) && bh=$H

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# multi-stop vertical gradient across the bounding box, then pad with the end
# colours so the canvas is fully covered
magick "${STOPS[@]/#/xc:}" -append -filter Cubic -resize "1x${bh}!" "$tmp/col.png"
magick "$tmp/col.png" -resize "${W}x${bh}!" \
  -background "${STOPS[0]}" -gravity north -splice "0x${by}" \
  -background "${STOPS[-1]}" -gravity south -extent "${W}x${H}" "$tmp/grad.png"

magick \
  \( "$tmp/grad.png" -colorspace HSL -channel R -separate +channel \) \
  \( "$tmp/grad.png" -colorspace HSL -channel G -separate +channel \) \
  \( "$src" -alpha off -colorspace HSL -channel B -separate +channel "${LCURVE[@]}" \) \
  -set colorspace HSL -combine -colorspace sRGB \
  \( "$src" -alpha extract \) -alpha off -compose CopyOpacity -composite \
  "$dst"
