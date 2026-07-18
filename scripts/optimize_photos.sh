#!/usr/bin/env bash
# Prepare photos for the /photos/ gallery.
#
# Usage: scripts/optimize_photos.sh <folder-with-original-photos>
#
# Writes web-sized versions (1800px, for the lightbox) to assets/photos/
# and small thumbnails (640px, for the grid) to assets/photo_thumbs/.
# Originals are left untouched — keep them out of the repo, they are
# too large for GitHub Pages.
#
# Requires ImageMagick (`convert`).

set -euo pipefail

src="${1:?Usage: scripts/optimize_photos.sh <folder-with-original-photos>}"
repo="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$repo/assets/photos" "$repo/assets/photo_thumbs"

find "$src" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 |
  xargs -0 -P 8 -I{} bash -c '
    f="{}"
    n="$(basename "$f")"
    convert "$f" -auto-orient -strip -resize "1800x1800>" -quality 82 "'"$repo"'/assets/photos/$n"
    convert "$f" -auto-orient -strip -resize "640x640>" -quality 78 "'"$repo"'/assets/photo_thumbs/$n"
    echo "$n"
  '

echo "Done. Review with: bundle exec jekyll serve"
