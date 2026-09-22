import math

W, H = 2560, 1440

def wave(y0, amp, wavelen, phase, samples=16):
    """Smooth crest line across the frame, closed down to the bottom edge."""
    pts = []
    for i in range(samples + 1):
        x = W * i / samples
        y = y0 + amp * math.sin(2 * math.pi * x / wavelen + phase) \
               + amp * 0.35 * math.sin(4 * math.pi * x / wavelen + phase * 1.7)
        pts.append((x, y))
    # Catmull-Rom through the samples, emitted as cubic beziers
    d = f"M {pts[0][0]:.1f} {pts[0][1]:.1f}"
    for i in range(len(pts) - 1):
        p0 = pts[i - 1] if i > 0 else pts[i]
        p1, p2 = pts[i], pts[i + 1]
        p3 = pts[i + 2] if i + 2 < len(pts) else p2
        c1 = (p1[0] + (p2[0] - p0[0]) / 6, p1[1] + (p2[1] - p0[1]) / 6)
        c2 = (p2[0] - (p3[0] - p1[0]) / 6, p2[1] - (p3[1] - p1[1]) / 6)
        d += f" C {c1[0]:.1f} {c1[1]:.1f}, {c2[0]:.1f} {c2[1]:.1f}, {p2[0]:.1f} {p2[1]:.1f}"
    d += f" L {W} {H} L 0 {H} Z"
    return d

# back (bright, high) to front (dark, low)
layers = [
    (620,  34, 2100, 0.3, "#ffc857"),
    (712,  40, 1850, 1.4, "#ff9a4a"),
    (812,  36, 1600, 2.6, "#f0743f"),
    (918,  44, 1900, 0.9, "#d4525f"),
    (1030, 38, 1450, 3.4, "#a5426a"),
    (1150, 46, 1750, 2.0, "#6d3363"),
    (1280, 40, 1300, 4.1, "#42234c"),
    (1392, 30, 1550, 1.1, "#1f1027"),
]

out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
'''  <defs>
    <linearGradient id="dusk" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0.00" stop-color="#120814"/>
      <stop offset="0.34" stop-color="#22122c"/>
      <stop offset="0.62" stop-color="#3a1f45"/>
      <stop offset="1.00" stop-color="#5c2f5e"/>
    </linearGradient>
    <radialGradient id="halo" cx="0.5" cy="0.5" r="0.5">
      <stop offset="0.00" stop-color="#ffd97d" stop-opacity="0.55"/>
      <stop offset="0.40" stop-color="#ff8c42" stop-opacity="0.24"/>
      <stop offset="1.00" stop-color="#ff5c5c" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="disc" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#fff2c2"/>
      <stop offset="1" stop-color="#ff9a4a"/>
    </linearGradient>
    <linearGradient id="cloudfade" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0.00" stop-color="#22122c" stop-opacity="0"/>
      <stop offset="0.24" stop-color="#22122c" stop-opacity="0.62"/>
      <stop offset="0.76" stop-color="#22122c" stop-opacity="0.62"/>
      <stop offset="1.00" stop-color="#22122c" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="scrim" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0.00" stop-color="#150a1c" stop-opacity="0"/>
      <stop offset="0.40" stop-color="#150a1c" stop-opacity="0.10"/>
      <stop offset="0.70" stop-color="#170b20" stop-opacity="0.34"/>
      <stop offset="1.00" stop-color="#170b20" stop-opacity="0.52"/>
    </linearGradient>
  </defs>''',
f'  <rect width="{W}" height="{H}" fill="url(#dusk)"/>',
'  <ellipse cx="1280" cy="640" rx="900" ry="620" fill="url(#halo)"/>',
'  <circle cx="1280" cy="596" r="196" fill="url(#disc)" opacity="0.92"/>',
'  <!-- sun banded by the thin cloud bars behind the water -->',
'  <g fill="url(#cloudfade)">',
'    <rect x="1010" y="508" width="540" height="12" rx="6"/>',
'    <rect x="1060" y="556" width="600" height="9"  rx="5"/>',
'  </g>',
]

for i, (y0, amp, wl, ph, color) in enumerate(layers):
    out.append(f'  <path d="{wave(y0, amp, wl, ph)}" fill="{color}"/>')
    # a thin lighter crest line to separate the bands
    out.append(f'  <path d="{wave(y0 - 5, amp, wl, ph)}" fill="none" '
               f'stroke="#ffd6a0" stroke-width="2" opacity="{0.20 - i*0.02:.2f}"/>')

out.append(f'  <rect width="{W}" height="{H}" fill="url(#scrim)"/>')
out.append('</svg>')
open('bg3.svg', 'w').write("\n".join(out))
print("layers:", len(layers))
