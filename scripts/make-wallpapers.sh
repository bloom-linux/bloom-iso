#!/usr/bin/env bash
# Generate Bloom Linux wallpaper variants with bloom logos.
# Requires: imagemagick, librsvg (rsvg-convert)
# Output: airootfs/usr/share/wallpapers/bloom/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR/.."
OUT="$ROOT/airootfs/usr/share/wallpapers/bloom"
PIXMAPS="$ROOT/airootfs/usr/share/pixmaps"
W=2560; H=1440   # base resolution (downscale for lower res monitors is fine)

mkdir -p "$OUT" "$PIXMAPS"

# ── Rasterise SVG logos ──────────────────────────────────────────────────────
svg_to_png() {
    local src="$1" dst="$2" height="$3"
    if command -v rsvg-convert &>/dev/null; then
        rsvg-convert -h "$height" "$src" -o "$dst"
    elif command -v inkscape &>/dev/null; then
        inkscape --export-type=png --export-height="$height" \
                 --export-filename="$dst" "$src" 2>/dev/null
    else
        echo "WARNING: neither rsvg-convert nor inkscape found — skipping $dst"
    fi
}

SVG_DIR="$ROOT/airootfs/usr/share/pixmaps"

for pair in "bloom-white.svg:bloom-white.png" "bloom-black.svg:bloom-black.png" "bloom-icon.svg:bloom-icon.png"; do
    svg="${pair%%:*}"; png="${pair##*:}"
    [ -f "$SVG_DIR/$svg" ] && svg_to_png "$SVG_DIR/$svg" "$PIXMAPS/$png" 200
done

# ── Plain wallpaper composer ─────────────────────────────────────────────────
# Usage: make_wallpaper <output.png> <bg_hex> <logo.png> <logo_height_px>
make_wallpaper() {
    local out="$1" bg="$2" logo="$3" logo_h="$4"
    if [ ! -f "$logo" ]; then
        echo "  skipping $out — logo $logo not found"; return
    fi
    local tmp_logo; tmp_logo="$(mktemp /tmp/bloom-logo-XXXX.png)"
    convert "$logo" -resize "x${logo_h}" "$tmp_logo"
    convert \
        -size "${W}x${H}" "xc:${bg}" \
        "$tmp_logo" -gravity Center -geometry "+0-80" -composite \
        -strip "$out"
    rm -f "$tmp_logo"
    echo "  generated $out"
}

# ── Pattern helpers ──────────────────────────────────────────────────────────

# Dot grid: 48×48 tile with a soft 2 px dot, blended at low opacity
_make_dot_overlay() {
    local tmp_tile; tmp_tile="$(mktemp /tmp/bloom-tile-XXXX.png)"
    local tmp_over; tmp_over="$(mktemp /tmp/bloom-over-XXXX.png)"
    convert -size 48x48 xc:none \
        -fill 'rgba(255,255,255,0.07)' -draw "circle 24,24 26,24" \
        "$tmp_tile"
    convert -size "${W}x${H}" "tile:${tmp_tile}" "$tmp_over"
    rm -f "$tmp_tile"
    echo "$tmp_over"
}

# Diagonal hairlines: 12×12 tile with a 1 px diagonal, blended at low opacity
_make_lines_overlay() {
    local tmp_tile; tmp_tile="$(mktemp /tmp/bloom-tile-XXXX.png)"
    local tmp_over; tmp_over="$(mktemp /tmp/bloom-over-XXXX.png)"
    convert -size 12x12 xc:none \
        -fill 'rgba(255,255,255,0.045)' \
        -draw "line 0,0 11,11" -draw "line 0,12 12,0" \
        "$tmp_tile"
    convert -size "${W}x${H}" "tile:${tmp_tile}" "$tmp_over"
    rm -f "$tmp_tile"
    echo "$tmp_over"
}

# Fine grain: gaussian noise layer, blended softly
_make_grain_overlay() {
    local tmp_over; tmp_over="$(mktemp /tmp/bloom-over-XXXX.png)"
    convert -size "${W}x${H}" xc:'rgba(0,0,0,0)' \
        +noise Gaussian \
        -evaluate multiply 0.055 \
        -blur 0x0.4 \
        "$tmp_over"
    echo "$tmp_over"
}

# Radial gradient: soft purple glow at center, transparent at edges
_make_radial_overlay() {
    local tmp_over; tmp_over="$(mktemp /tmp/bloom-over-XXXX.png)"
    # Draw a radial gradient centered, purple-to-transparent
    convert -size "${W}x${H}" \
        radial-gradient:'rgba(155,95,192,0.18)-rgba(13,6,24,0)' \
        "$tmp_over"
    echo "$tmp_over"
}

# Dot grid (dark tint): same as dot but rgba(0,0,0,…) for light backgrounds
_make_dot_overlay_dark() {
    local tmp_tile; tmp_tile="$(mktemp /tmp/bloom-tile-XXXX.png)"
    local tmp_over; tmp_over="$(mktemp /tmp/bloom-over-XXXX.png)"
    convert -size 48x48 xc:none \
        -fill 'rgba(0,0,0,0.07)' -draw "circle 24,24 26,24" \
        "$tmp_tile"
    convert -size "${W}x${H}" "tile:${tmp_tile}" "$tmp_over"
    rm -f "$tmp_tile"
    echo "$tmp_over"
}

# Hex grid: 52×60 hex tile (two staggered rows)
_make_hex_overlay() {
    local tmp_tile; tmp_tile="$(mktemp /tmp/bloom-tile-XXXX.png)"
    local tmp_over; tmp_over="$(mktemp /tmp/bloom-over-XXXX.png)"
    # Draw hexagon outlines in a tile using strokewidth hairlines
    convert -size 52x60 xc:none \
        -stroke 'rgba(255,255,255,0.055)' -strokewidth 1 -fill none \
        -draw "polygon 26,2  49,15  49,41  26,56  3,41  3,15" \
        "$tmp_tile"
    convert -size "${W}x${H}" "tile:${tmp_tile}" "$tmp_over"
    rm -f "$tmp_tile"
    echo "$tmp_over"
}

# ── Pattern wallpaper composer ───────────────────────────────────────────────
# Usage: make_wallpaper_pattern <output> <bg_hex> <logo> <logo_h> <pattern_fn>
make_wallpaper_pattern() {
    local out="$1" bg="$2" logo="$3" logo_h="$4" pattern_fn="$5"
    if [ ! -f "$logo" ]; then
        echo "  skipping $out — logo $logo not found"; return
    fi
    local tmp_logo; tmp_logo="$(mktemp /tmp/bloom-logo-XXXX.png)"
    convert "$logo" -resize "x${logo_h}" "$tmp_logo"

    local tmp_overlay; tmp_overlay="$($pattern_fn)"

    convert \
        -size "${W}x${H}" "xc:${bg}" \
        "$tmp_overlay" -compose Over -composite \
        "$tmp_logo" -gravity Center -geometry "+0-80" -composite \
        -strip "$out"

    rm -f "$tmp_logo" "$tmp_overlay"
    echo "  generated $out"
}

# ── Generate all variants ────────────────────────────────────────────────────
echo "Generating Bloom wallpapers..."

# ── Solid colour bases ───────────────────────────────────────────────────────
make_wallpaper "$OUT/bloom-wallpaper.png"  "#0D0618" "$PIXMAPS/bloom-white.png" 180  # default dark purple
make_wallpaper "$OUT/bloom-midnight.png"   "#05030C" "$PIXMAPS/bloom-white.png" 180  # near-black
make_wallpaper "$OUT/bloom-wine.png"       "#140611" "$PIXMAPS/bloom-white.png" 180  # dark burgundy
make_wallpaper "$OUT/bloom-dusk.png"       "#060E14" "$PIXMAPS/bloom-white.png" 180  # dark navy-teal
make_wallpaper "$OUT/bloom-light.png"      "#F5F3F7" "$PIXMAPS/bloom-black.png" 180  # light/cream

# ── Pattern variants (all on default dark purple bg) ─────────────────────────
make_wallpaper_pattern "$OUT/bloom-dots.png"   "#0D0618" "$PIXMAPS/bloom-white.png" 180 _make_dot_overlay
make_wallpaper_pattern "$OUT/bloom-lines.png"  "#0D0618" "$PIXMAPS/bloom-white.png" 180 _make_lines_overlay
make_wallpaper_pattern "$OUT/bloom-grain.png"  "#0D0618" "$PIXMAPS/bloom-white.png" 180 _make_grain_overlay
make_wallpaper_pattern "$OUT/bloom-radial.png" "#0D0618" "$PIXMAPS/bloom-white.png" 180 _make_radial_overlay
make_wallpaper_pattern "$OUT/bloom-hex.png"    "#0D0618" "$PIXMAPS/bloom-white.png" 180 _make_hex_overlay

# ── Pattern variants on other bases ──────────────────────────────────────────
make_wallpaper_pattern "$OUT/bloom-midnight-radial.png" "#05030C" "$PIXMAPS/bloom-white.png" 180 _make_radial_overlay
make_wallpaper_pattern "$OUT/bloom-midnight-dots.png"   "#05030C" "$PIXMAPS/bloom-white.png" 180 _make_dot_overlay
make_wallpaper_pattern "$OUT/bloom-wine-lines.png"      "#140611" "$PIXMAPS/bloom-white.png" 180 _make_lines_overlay
make_wallpaper_pattern "$OUT/bloom-dusk-hex.png"        "#060E14" "$PIXMAPS/bloom-white.png" 180 _make_hex_overlay
make_wallpaper_pattern "$OUT/bloom-light-dots.png"      "#F5F3F7" "$PIXMAPS/bloom-black.png" 180 _make_dot_overlay_dark

echo "Done. Wallpapers in $OUT"
