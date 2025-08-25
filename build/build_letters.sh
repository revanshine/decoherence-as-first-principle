#!/usr/bin/env bash

set -euo pipefail

OUTDIR="build/out/letters"
mkdir -p "$OUTDIR"

# Letter files
LETTERS=(
  "01 - collapse_oscillator_letter.md"
  "02 - gravitational-decoherence-oscillations.md"
  "03 - blackhole_galaxy_letter.md"
)

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
  if [[ -f "letters/$letter" ]]; then
    basename="${letter%.md}"
    
    if [[ -z "$GENERATE_TEX_ONLY" ]]; then
      echo "Building $basename.pdf..."
      pandoc "${COMMON_OPTS[@]}" "letters/$letter" -o "$OUTDIR/$basename.pdf"
      echo "✓ Generated $OUTDIR/$basename.pdf"
    else
      echo "Building $basename.tex..."
      pandoc --standalone "${COMMON_OPTS[@]}" "letters/$letter" -o "$OUTDIR/$basename.tex"
      echo "✓ Generated $OUTDIR/$basename.tex"
    fi
  else
    echo "⚠️  Warning: letters/$letter not found, skipping..."
  fi
done

echo "All letters built successfully!"
echo "Output directory: $OUTDIR"
