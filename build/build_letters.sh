#!/usr/bin/env bash

set -euo pipefail

OUTDIR="build/out/letters"
mkdir -p "$OUTDIR"

# Letter files in _letters directory
LETTERS=(
  "collapse-length-oscillation.md"
  "gravitational-decoherence-oscillations.md"
  "blackhole-galaxy-letter.md"
)

LETTERS_DIR="_letters"

BIB="references/references.bib"
CSL="references/harvard-cite-them-right.csl"

COMMON_OPTS=(
  --from=markdown+smart
  --citeproc
  --metadata link-citations=true
  --bibliography="$BIB"
  --csl="$CSL"
  --standalone
)

echo "Building letters..."

# Build each letter as PDF
for letter in "${LETTERS[@]}"; do
  if [[ -f "$LETTERS_DIR/$letter" ]]; then
    basename="${letter%.md}"
    
    if [[ -z "${GENERATE_TEX_ONLY:-}" ]]; then
      echo "Building $basename.pdf..."
      pandoc "${COMMON_OPTS[@]}" "$LETTERS_DIR/$letter" -o "$OUTDIR/$basename.pdf"
      echo "✓ Generated $OUTDIR/$basename.pdf"
    else
      echo "Building $basename.tex..."
      pandoc --standalone "${COMMON_OPTS[@]}" "$LETTERS_DIR/$letter" -o "$OUTDIR/$basename.tex"
      echo "✓ Generated $OUTDIR/$basename.tex"
    fi
  else
    echo "⚠️  Warning: $LETTERS_DIR/$letter not found, skipping..."
  fi
done

echo "All letters built successfully!"
echo "Output directory: $OUTDIR"
