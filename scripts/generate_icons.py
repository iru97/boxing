"""
Generate boxing app launcher icon PNGs for Android mipmap densities.

Design: Boxing glove silhouette inside a gold timer arc, on near-black background.
Drawn at 1024x1024, downsampled to 512, then resized to each density with LANCZOS.

Output:
  android/app/src/main/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png
"""

import math
from pathlib import Path
from PIL import Image, ImageDraw


# Colors
BG_COLOR = (10, 10, 10, 255)             # #0A0A0A
ARC_TRACK_COLOR = (26, 26, 26, 255)      # #1A1A1A
ARC_COLOR = (255, 179, 0, 255)           # #FFB300 gold
GLOVE_BODY = (229, 57, 53, 255)          # #E53935 brand red
GLOVE_HIGHLIGHT = (239, 83, 80, 255)     # #EF5350
GLOVE_SHADOW = (198, 40, 40, 255)        # #C62828
GLOVE_HIGHLIGHT_ALPHA = (239, 83, 80, 204)  # #EF5350 alpha ~80%

# Android mipmap density -> pixel size
DENSITIES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

# Draw at 1024, downsample to 512, then resize to each density
DRAW_SIZE = 1024
CANVAS_SIZE = 512


def pct(value, base=DRAW_SIZE):
    """Convert a percentage (0-100) to pixels on the draw canvas."""
    return value / 100.0 * base


def generate_arc_polygon(cx, cy, outer_r, inner_r, start_deg, sweep_deg, steps=120):
    """Generate a filled arc as a polygon (outer arc + reversed inner arc)."""
    outer_points = []
    inner_points = []

    for i in range(steps + 1):
        angle_deg = start_deg + sweep_deg * i / steps
        angle_rad = math.radians(angle_deg)
        # Pillow coordinate system: 0° = right (3 o'clock), clockwise
        cos_a = math.cos(angle_rad)
        sin_a = math.sin(angle_rad)

        outer_points.append((cx + outer_r * cos_a, cy + outer_r * sin_a))
        inner_points.append((cx + inner_r * cos_a, cy + inner_r * sin_a))

    # Polygon: outer arc forward, inner arc reversed
    return outer_points + list(reversed(inner_points))


def generate_ellipse_points(cx, cy, rx, ry, rotation_deg=0, steps=60):
    """Generate points for a (possibly rotated) ellipse."""
    points = []
    rot_rad = math.radians(rotation_deg)
    cos_rot = math.cos(rot_rad)
    sin_rot = math.sin(rot_rad)

    for i in range(steps):
        t = 2 * math.pi * i / steps
        # Unrotated ellipse point
        ex = rx * math.cos(t)
        ey = ry * math.sin(t)
        # Apply rotation
        rx2 = ex * cos_rot - ey * sin_rot
        ry2 = ex * sin_rot + ey * cos_rot
        points.append((cx + rx2, cy + ry2))

    return points


def draw_icon_hires():
    """Draw the full icon at DRAW_SIZE (1024x1024)."""
    S = DRAW_SIZE
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # --- Layer 1: Background rounded rectangle ---
    margin = pct(4)
    corner_r = pct(18)
    draw.rounded_rectangle(
        [margin, margin, S - margin, S - margin],
        radius=int(corner_r),
        fill=BG_COLOR,
    )

    # --- Layer 2: Timer arc track (full 360°) ---
    cx, cy = pct(50), pct(50)
    outer_r = pct(40)
    inner_r = pct(35)

    track_poly = generate_arc_polygon(cx, cy, outer_r, inner_r, 0, 360, steps=180)
    draw.polygon(track_poly, fill=ARC_TRACK_COLOR)

    # --- Layer 3: Timer arc (270° sweep, gap at bottom-left / ~7 o'clock) ---
    # Start at 135° (between 6 o'clock=90° and 9 o'clock=180°, i.e. ~7:30)
    # Sweep 270° clockwise
    arc_start_deg = 135
    arc_sweep_deg = 270

    arc_poly = generate_arc_polygon(cx, cy, outer_r, inner_r,
                                    arc_start_deg, arc_sweep_deg, steps=180)
    draw.polygon(arc_poly, fill=ARC_COLOR)

    # Rounded caps at the two endpoints of the arc
    cap_r = (outer_r - inner_r) / 2.0
    mid_r = (outer_r + inner_r) / 2.0

    for angle_deg in [arc_start_deg, arc_start_deg + arc_sweep_deg]:
        angle_rad = math.radians(angle_deg)
        cap_cx = cx + mid_r * math.cos(angle_rad)
        cap_cy = cy + mid_r * math.sin(angle_rad)
        draw.ellipse(
            [cap_cx - cap_r, cap_cy - cap_r, cap_cx + cap_r, cap_cy + cap_r],
            fill=ARC_COLOR,
        )

    # --- Layer 4: Boxing glove body ---
    glove_cx, glove_cy = pct(50), pct(47)
    glove_w, glove_h = pct(36), pct(34)
    glove_corner = int(min(glove_w, glove_h) * 0.30)

    draw.rounded_rectangle(
        [
            glove_cx - glove_w / 2, glove_cy - glove_h / 2,
            glove_cx + glove_w / 2, glove_cy + glove_h / 2,
        ],
        radius=glove_corner,
        fill=GLOVE_BODY,
    )

    # --- Layer 5: Thumb (rotated ellipse, ~30° CCW) ---
    thumb_cx, thumb_cy = pct(34), pct(42)
    thumb_rx, thumb_ry = pct(14) / 2, pct(18) / 2
    # CCW rotation is negative in standard math convention
    thumb_points = generate_ellipse_points(thumb_cx, thumb_cy, thumb_rx, thumb_ry,
                                           rotation_deg=-30)
    draw.polygon(thumb_points, fill=GLOVE_HIGHLIGHT)

    # --- Layer 6: Knuckle ridge ---
    ridge_x1, ridge_y = pct(37), pct(44)
    ridge_x2 = pct(63)
    ridge_thickness = pct(2.5)
    ridge_corner = int(ridge_thickness / 2)

    draw.rounded_rectangle(
        [
            ridge_x1, ridge_y - ridge_thickness / 2,
            ridge_x2, ridge_y + ridge_thickness / 2,
        ],
        radius=ridge_corner,
        fill=GLOVE_SHADOW,
    )

    # --- Layer 7: Wrist cuff ---
    cuff_cx, cuff_cy = pct(50), pct(63)
    cuff_w, cuff_h = pct(28), pct(9)
    cuff_corner = int(min(cuff_w, cuff_h) * 0.25)

    draw.rounded_rectangle(
        [
            cuff_cx - cuff_w / 2, cuff_cy - cuff_h / 2,
            cuff_cx + cuff_w / 2, cuff_cy + cuff_h / 2,
        ],
        radius=cuff_corner,
        fill=GLOVE_BODY,
    )

    # --- Layer 8: Cuff detail line ---
    line_thickness = pct(1.2)
    line_corner = int(line_thickness / 2)
    draw.rounded_rectangle(
        [
            cuff_cx - cuff_w / 2 + pct(2), cuff_cy - line_thickness / 2,
            cuff_cx + cuff_w / 2 - pct(2), cuff_cy + line_thickness / 2,
        ],
        radius=line_corner,
        fill=GLOVE_SHADOW,
    )

    # --- Layer 9: Wrist opening ---
    opening_cx = cuff_cx
    opening_cy = cuff_cy + cuff_h / 2 - pct(1.5)
    opening_w, opening_h = pct(14), pct(4)
    opening_corner = int(min(opening_w, opening_h) * 0.4)

    draw.rounded_rectangle(
        [
            opening_cx - opening_w / 2, opening_cy - opening_h / 2,
            opening_cx + opening_w / 2, opening_cy + opening_h / 2,
        ],
        radius=opening_corner,
        fill=ARC_TRACK_COLOR,
    )

    # --- Layer 10: Glove highlight (subtle ellipse, upper-right) ---
    hl_cx, hl_cy = pct(55), pct(40)
    hl_rx, hl_ry = pct(16) / 2, pct(12) / 2
    hl_points = generate_ellipse_points(hl_cx, hl_cy, hl_rx, hl_ry)
    draw.polygon(hl_points, fill=GLOVE_HIGHLIGHT_ALPHA)

    return img


def main():
    script_dir = Path(__file__).resolve().parent
    project_root = script_dir.parent
    res_dir = project_root / "android" / "app" / "src" / "main" / "res"

    print("Drawing icon at 1024x1024...")
    hires = draw_icon_hires()

    print("Downsampling to 512x512...")
    base = hires.resize((CANVAS_SIZE, CANVAS_SIZE), Image.LANCZOS)

    for density_name, px_size in DENSITIES.items():
        out_dir = res_dir / density_name
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "ic_launcher.png"

        icon = base.resize((px_size, px_size), Image.LANCZOS)
        icon.save(str(out_path), "PNG")
        print(f"  {density_name}: {px_size}x{px_size} -> {out_path}")

    print("\nDone! All icon PNGs generated.")


if __name__ == "__main__":
    main()
