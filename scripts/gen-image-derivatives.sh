#!/usr/bin/env bash
#
# gen-image-derivatives.sh
# ------------------------
# Generate lean WebP + JPEG renditions of the heavy content photos so the
# site can serve <picture> elements (WebP first, JPEG fallback) instead of
# the oversized PNG/JPEG masters. Appearance-preserving: the masters in
# assets/ are left untouched; derivatives land in assets/opt/.
#
# Several "photos" on the About page were saved as PNG (a poor format for
# photographs) at 0.6-1.8 MB each. Re-encoding to WebP/JPEG shrinks them by
# ~90% with no visible change at web display sizes.
#
# Tools: cwebp (WebP) + sips (macOS, resize + PNG->JPEG). No ImageMagick.
#
# Usage:
#   ./scripts/gen-image-derivatives.sh          # incremental
#   FORCE=1 ./scripts/gen-image-derivatives.sh  # rebuild all

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC="$ROOT/assets"
OUT="$ROOT/assets/opt"

WEBP_Q=82
JPEG_Q=85
MAXW=1600   # cap very large masters; smaller images are never upscaled

CWEBP="$(command -v cwebp)"
SIPS="$(command -v sips)"
mkdir -p "$OUT"

# List of heavy content images to optimise (relative to assets/).
IMAGES=(
  "A.png" "B.png" "C.png" "D.png" "E.png" "F.png" "G.png"
  "elizabeth-saenz-5.png"
  "Silvia_Cabrelles.jpg"
)

img_width() { "$SIPS" -g pixelWidth "$1" 2>/dev/null | awk '/pixelWidth/{print $2}'; }
imin() { (( $1 < $2 )) && echo "$1" || echo "$2"; }

for rel in "${IMAGES[@]}"; do
  src="$SRC/$rel"
  [[ -f "$src" ]] || { echo "  MISSING: $rel" >&2; continue; }
  name="${rel%.*}"
  w="$(img_width "$src")"; [[ -z "$w" ]] && w=$MAXW
  target="$(imin "$MAXW" "$w")"

  webp="$OUT/$name.webp"
  jpg="$OUT/$name.jpg"

  if [[ "${FORCE:-0}" == "1" || ! -f "$webp" || "$src" -nt "$webp" ]]; then
    "$CWEBP" -quiet -q "$WEBP_Q" -resize "$target" 0 "$src" -o "$webp"
    echo "  webp: assets/opt/$name.webp (${target}px)"
  fi
  if [[ "${FORCE:-0}" == "1" || ! -f "$jpg" || "$src" -nt "$jpg" ]]; then
    # copy->resize->reencode as JPEG (sips writes in place, so stage a copy)
    tmp="$OUT/.$name.tmp.${rel##*.}"
    cp "$src" "$tmp"
    # resample by WIDTH (matches cwebp -resize W 0) so webp/jpeg share dimensions
    "$SIPS" --resampleWidth "$target" -s format jpeg -s formatOptions "$JPEG_Q" "$tmp" --out "$jpg" >/dev/null
    rm -f "$tmp"
    echo "  jpeg: assets/opt/$name.jpg  (${target}px)"
  fi
done

echo "Done. Derivatives in assets/opt/  (WebP q${WEBP_Q}, JPEG q${JPEG_Q}, max ${MAXW}px)."
