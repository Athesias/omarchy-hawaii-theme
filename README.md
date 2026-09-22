# Hawaii

A tropical sunset theme for [Omarchy](https://omarchy.org/): deep volcanic-twilight
purple ground, warm sun-on-the-water orange accent.

Ships the `Hawaiian Beach` background, the **Hawaii-Sunset** icon theme (Yaru's
folder family repainted with the sunset gradient), and a themed unlock banner.

## Install

```bash
omarchy theme install https://github.com/Athesias/omarchy-hawaii-theme.git
```

That clones into `~/.config/omarchy/themes/hawaii` and applies the theme.

### Icons

The palette applies immediately, but the icon theme has to be copied onto the
icon search path once per machine:

```bash
~/.config/omarchy/themes/hawaii/install-icons.sh
omarchy theme set hawaii
```

Hawaii-Sunset inherits from Yaru for everything it does not repaint, so Yaru
should be present:

```bash
omarchy pkg add yaru-icon-theme
```

### Sparkles

The purple-and-orange sparkles that trace the active window are a separate
Omarchy shell plugin, because a theme installed from a git repo may not ship
code. It only animates while this theme is active:

```bash
omarchy plugin add https://github.com/Athesias/omarchy-hawaii-sparkles.git --enable
```

## Layout

| Path | What it is |
|---|---|
| `colors.toml` | The palette. Everything Omarchy themes is generated from this. |
| `backgrounds/` | `Hawaiian Beach.png`, the theme's background. |
| `icons/Hawaii-Sunset/` | Pre-built icon theme, installed by `install-icons.sh`. |
| `icons.theme` | Names `Hawaii-Sunset` as the GNOME icon theme. |
| `unlock.png` | Banner shown on the lock screen. |
| `preview.png` | Thumbnail for the theme picker. |
| `src/` | Sources for the icons, and for three retired generated backgrounds. |

## Rebuilding

The committed icons are generated output; `src/` holds what produced them.
Re-render only if you change a source.

### Backgrounds

The theme ships only `Hawaiian Beach.png`. `src/` still holds the SVG sources
for three generated backgrounds the theme carried previously; they are kept for
reference and are no longer shipped. To bring one back, render it into
`backgrounds/` — anything there is picked up by `omarchy theme bg next`.

```bash
cd src
rsvg-convert -w 2560 -h 1440 bg1.svg -o "../backgrounds/1-sunset.png"
rsvg-convert -w 2560 -h 1440 bg2.svg -o "../backgrounds/2-palms.png"
python3 gen-bg3.py && rsvg-convert -w 2560 -h 1440 bg3.svg -o "../backgrounds/3-tide.png"
```

`bg1.svg` is assembled from `bg1-head.svg` + `gen-stars.sh` + `bg1-tail.svg`;
the committed `bg1.svg` already has the stars baked in.

### Icons

Icons are repainted from Yaru by `src/build-icons.sh`, which needs ImageMagick
and `/usr/share/icons/Yaru-magenta-dark`. It writes straight to
`~/.local/share/icons/Hawaii-Sunset`; copy that back into `icons/` to commit it.
Gradient stops live in the `STOPS` array in `src/recolor-icon.sh`, top to bottom.

```bash
src/build-icons.sh
gtk-update-icon-cache -f -t ~/.local/share/icons/Hawaii-Sunset
rm -rf icons/Hawaii-Sunset && cp -r ~/.local/share/icons/Hawaii-Sunset icons/
rm -f icons/Hawaii-Sunset/icon-theme.cache
```
