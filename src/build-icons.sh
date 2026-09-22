#!/bin/bash
# Build the Hawaii-Sunset icon theme: Yaru's folder family repainted with the
# sunset gradient. Everything else falls through to Yaru via Inherits.
set -euo pipefail

SRC=/usr/share/icons/Yaru-magenta-dark
DST="$HOME/.local/share/icons/Hawaii-Sunset"
HERE="$(cd "$(dirname "$0")" && pwd)"

rm -rf "$DST"
mkdir -p "$DST"

n=0
while IFS= read -r rel; do
  real=$(readlink -f "$SRC/$rel") || continue
  [[ -f $real ]] || continue
  mkdir -p "$DST/$(dirname "$rel")"
  # symlinks in Yaru are flattened into real files here
  "$HERE/recolor-icon.sh" "$real" "$DST/$rel"
  n=$((n+1))
done < "$HERE/iconlist.txt"

echo "recoloured $n icons"
