Sources for the three backgrounds. Re-render with:
  rsvg-convert -w 2560 -h 1440 bg1.svg -o ../backgrounds/1-sunset.png
  rsvg-convert -w 2560 -h 1440 bg2.svg -o ../backgrounds/2-palms.png
  python3 gen-bg3.py && rsvg-convert -w 2560 -h 1440 bg3.svg -o ../backgrounds/3-tide.png
(bg1.svg is assembled from bg1-head.svg + gen-stars.sh + bg1-tail.svg; the
committed bg1.svg already has the stars baked in.)

Icon theme (Hawaii-Sunset, installed to ~/.local/share/icons/Hawaii-Sunset):
  ./build-icons.sh          # repaints the 173 folder icons listed in iconlist.txt
  gtk-update-icon-cache -f -t ~/.local/share/icons/Hawaii-Sunset
Gradient stops live in recolor-icon.sh (STOPS array), top to bottom.
Rebuild after an OS update if Yaru's folder art changes.
