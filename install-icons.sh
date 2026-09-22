#!/bin/bash
# Install the Hawaii-Sunset icon theme into ~/.local/share/icons.
#
# The theme's icons.theme names Hawaii-Sunset, but an Omarchy theme directory
# is not on the icon search path, so the tree has to be copied into place once
# per machine. The committed icons under icons/ are the pre-built output of
# src/build-icons.sh, so ImageMagick is not needed here.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/icons/Hawaii-Sunset"
DST="$HOME/.local/share/icons/Hawaii-Sunset"

[[ -d $SRC ]] || { echo "missing $SRC" >&2; exit 1; }

# index.theme inherits from Yaru, which supplies every icon this theme does not
# repaint. Without it most of the desktop falls back to hicolor.
if [[ ! -d /usr/share/icons/Yaru-magenta-dark ]]; then
  echo "warning: Yaru is not installed; install it with 'omarchy pkg add yaru-icon-theme'" >&2
fi

rm -rf "$DST"
mkdir -p "$(dirname "$DST")"
cp -r "$SRC" "$DST"
gtk-update-icon-cache -f -t "$DST"

echo "installed Hawaii-Sunset into $DST"
echo "re-apply the theme to pick it up:  omarchy theme set hawaii"
