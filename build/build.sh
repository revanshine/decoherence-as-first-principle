#!/usr/bin/env bash

set -euo pipefail

OUTDIR="build/out"
mkdir -p "$OUTDIR"

# Files in order
SECTIONS=(
  manuscript/sections/00-abstract.md
  manuscript/sections/01-introduction.md
  manuscript/sections/02-decoherence-bootstrap.md
  manuscript/sections/03-gravity-primary-basis.md
  manuscript/sections/04-emergence-of-forces.md
  manuscript/sections/05-dark-matter.md
  manuscript/sections/06-black-holes-and-decoherence-limit.md
  manuscript/sections/07-quantum-aliasing.md
  manuscript/sections/08-conservation-law.md
  manuscript/sections/09-related-work.md
  manuscript/sections/10-conclusion.md
  manuscript/sections/11-appendix.md
  manuscript/sections/99-break-before-refs.md
)

INPUTS=(manuscript/main.md "${SECTIONS[@]}")

BIB="references/references.bib"
CSL="references/harvard-cite-them-right.csl"

COMMON_OPTS=(
  --from=markdown+smart
  --citeproc
  --metadata link-citations=true
  --bibliography="$BIB"
  --csl="$CSL"
)

# Build manuscript.tex (for arXiv upload)
pandoc --standalone "${COMMON_OPTS[@]}" "${INPUTS[@]}" -o "$OUTDIR/manuscript.tex"

# Build PDF (for preview/sharing)
pandoc "${COMMON_OPTS[@]}" "${INPUTS[@]}" -o "$OUTDIR/manuscript.pdf"
