#!/usr/bin/env bash
#
# themify.sh - Convert all wallpapers in a directory into multiple themed variants.
#
# For every wallpaper in the input directory it produces:
#   <name>-gc.<ext>        grayscale version
#   <name>-gci.<ext>       inverted grayscale version
#   <theme>/<name>.<ext>   one copy per theme in the gowall config
#   <theme>/<name>-i.<ext> inverted copy per theme
#
# Usage:
#   themify.sh -dir ./my-dirs
#
# Options:
#   -dir <path>    Directory containing the source wallpapers (required)
#   -out <path>    Output directory (default: ./themify)
#   -fmt <ext>     Normalize every output to this format: png|jpeg|jpg|webp|avif
#   -config <path> Path to the gowall config.yml (default: ~/.config/gowall/config.yml)
#   -base16 <path> Path to a base16 YAML scheme to add as an extra theme
#   -keep          Keep intermediate grayscale files (they are deleted by default)
#
# Requires: gowall

set -u

CONFIG_PATH="${GOWALL_CONFIG:-$HOME/.config/gowall/config.yml}"
OUT_DIR=""
SRC_DIR=""
FMT=""
BASE16=""
KEEP=0

usage() {
  cat <<'EOF'
Usage: themify.sh <dir> [-out <dir>] [-fmt <ext>] [-config <path>] [-base16 <path>] [-keep]

  -dir <dir>    Directory containing source wallpapers (required)
  -out <dir>    Output directory (default: ./themify)
  -fmt <ext>    Normalize output format: png, jpeg, jpg, webp, avif
  -config <path> Path to gowall config.yml (default: ~/.config/gowall/config.yml)
  -base16 <path> Path to a base16 YAML scheme to add as an extra theme
  -keep         Keep intermediate grayscale/inverted files
EOF
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -dir|-d) SRC_DIR="$2"; shift 2;;
    -out|-o) OUT_DIR="$2"; shift 2;;
    -fmt|-f) FMT="$2"; shift 2;;
    -config|-c) CONFIG_PATH="$2"; shift 2;;
    -base16|-b) BASE16="$2"; shift 2;;
    -keep|-k) KEEP=1; shift;;
    -h|--help) usage;;
    *) echo "Unknown option: $1"; usage;;
  esac
done

if [[ -z "$SRC_DIR" ]]; then
  echo "ERROR: -dir is required" >&2
  usage
fi
if [[ ! -d "$SRC_DIR" ]]; then
  echo "ERROR: directory '$SRC_DIR' does not exist" >&2
  exit 1
fi
if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "ERROR: gowall config '$CONFIG_PATH' not found" >&2
  exit 1
fi
if [[ -n "$BASE16" && ! -f "$BASE16" ]]; then
  echo "ERROR: base16 scheme '$BASE16' not found" >&2
  exit 1
fi

OUT_DIR="${OUT_DIR:-themify}"
mkdir -p "$OUT_DIR"

# --- Resolve the list of themes from the gowall config --------------------
# The config format is simple (themes: -> name: -> colors:), so we parse it
# with a regex instead of requiring a YAML library.
parse_themes() {
  grep -E '^[[:space:]]*-[[:space:]]*name:' "$CONFIG_PATH" | sed -E 's/^[[:space:]]*-[[:space:]]*name:[[:space:]]*["\'']([^"\'']*)["\'']/\1/'
}

THEMES=$(parse_themes)

# --- Optional base16 scheme -> gowall JSON theme --------------------------
# gowall's -t accepts a theme name or a path to a JSON file of the shape
# {"name": "...", "colors": ["#hex", ...]}. It does NOT read YAML, so we
# translate the base16 YAML into that JSON on the fly and register the theme.
BASE16_JSON=""
BASE16_NAME=""
if [[ -n "$BASE16" ]]; then
  BASE16_NAME=$(grep -E '^scheme:' "$BASE16" \
    | sed -E 's/^scheme:[[:space:]]*["\'']?([^"\'']*)["\'']?.*/\1/' \
    | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  BASE16_NAME="${BASE16_NAME:-tropical-wet}"

  BASE16_JSON="$(mktemp "${TMPDIR:-/tmp}/${BASE16_NAME}.XXXXXX.json")"
  colors=""
  for i in 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F; do
    hex=$(grep -E "^base${i}:" "$BASE16" \
      | sed -E 's/^base[0-9A-Fa-f]+:[[:space:]]*["\'']?#?([0-9a-fA-F]{6})["\'']?.*/\1/')
    if [[ -n "$hex" ]]; then
      colors="${colors}\"#${hex}\","
    fi
  done
  colors="${colors%,}"
  printf '{"name":"%s","colors":[%s]}' "$BASE16_NAME" "$colors" > "$BASE16_JSON"

  # Register the base16 theme alongside the config themes.
  THEMES="$THEMES $BASE16_NAME"
fi

if [[ -z "$THEMES" ]]; then
  echo "ERROR: no themes found in '$CONFIG_PATH'" >&2
  exit 1
fi

# --- Normalize extension helper ----------------------------------------
# gowall's --output accepts a folder; the extension is derived from the
# source unless -fmt is given. We normalize by converting each output file
# to the requested format with gowall.
normalize() {
  local src="$1" theme="$2" dst="$3"
  if [[ -n "$FMT" ]]; then
    gowall convert "$src" -t "$theme" -f "$FMT" --preview false --output "$dst"
  else
    gowall convert "$src" -t "$theme" --preview false --output "$dst"
  fi
}

# --- Process each wallpaper ----------------------------------------------
count=0
for img in "$SRC_DIR"/*; do
  [[ -f "$img" ]] || continue
  ext=$(echo "$img" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')
  case "$ext" in
    png|jpeg|jpg|webp|avif) ;;
    *) continue;;
  esac

  base=$(basename "$img")
  name=$(echo "$base" | sed 's/\.[^.]*$//')
  count=$((count + 1))

  echo "[$count] $base"

  # 1. Grayscale (via gowall)
  gc="$OUT_DIR/${name}-gc.$ext"
  gowall effects grayscale "$img" --preview false --output "$gc"

  # 2. Inverted grayscale
  gci="$OUT_DIR/${name}-gci.$ext"
  gowall invert "$gc" --preview false --output "$gci"

  # 3. Per-theme conversions (grayscale + inverted grayscale)
  for theme in $THEMES; do
    tdir="$OUT_DIR/$theme"
    mkdir -p "$tdir"

    # The base16 theme is referenced by its JSON path; config themes by name.
    theme_arg="$theme"
    if [[ -n "$BASE16" && "$theme" == "$BASE16_NAME" ]]; then
      theme_arg="$BASE16_JSON"
    fi

    normalize "$gc" "$theme_arg" "$tdir/${name}.$ext"
    normalize "$gci" "$theme_arg" "$tdir/${name}-i.$ext"
  done

  # 4. Built-in themes, applied to the ORIGINAL image (not grayscale)
  for builtin in nord ayu-dark tokyo-dark; do
    bdir="$OUT_DIR/$builtin"
    mkdir -p "$bdir"
    normalize "$img" "$builtin" "$bdir/${name}.$ext"
  done

  # 5. Clean up intermediates unless requested to keep them
  if [[ "$KEEP" != "1" ]]; then
    rm -f "$gc" "$gci"
  fi
done

# Remove the temporary base16 JSON theme file
if [[ -n "$BASE16_JSON" ]]; then
  rm -f "$BASE16_JSON"
fi

if [[ $count -eq 0 ]]; then
  echo "No supported images found in '$SRC_DIR'" >&2
  exit 1
fi

echo "Done. Processed $count wallpaper(s) into '$OUT_DIR'."
