#!/usr/bin/env bash
# Comprehensive build script for Jekyll assets
# TEX is source of truth, PDF is vehicle, HTML is salesman (generated from markdown)

set -euo pipefail

echo "🔨 Building all assets for Jekyll..."

# Create assets directory structure
mkdir -p assets/paper assets/letters

echo "📄 Building main manuscript (TEX/PDF)..."
bash build/build.sh

echo "📝 Building research letters (PDF)..."
bash build/build_letters.sh

echo "🌐 Generating HTML from markdown sources..."

# Generate HTML from manuscript markdown sources (for proper bib/math)
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

echo "   Converting manuscript markdown to HTML..."
pandoc \
    --from=markdown+smart \
    --standalone \
    --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js \
    --citeproc \
    --metadata link-citations=true \
    --bibliography="references/references.bib" \
    --csl="references/harvard-cite-them-right.csl" \
    --metadata title="Decoherence as First Principle" \
    --metadata author="R. Evanshine" \
    --css="/assets/css/paper.css" \
    "${INPUTS[@]}" \
    -o assets/paper/manuscript.html
echo "   ✓ Generated assets/paper/manuscript.html"

# Copy the good TEX/PDF (source of truth & vehicle)
if [[ -f "build/out/manuscript.pdf" ]]; then
    cp build/out/manuscript.pdf assets/paper/
    echo "   ✓ Copied manuscript.pdf"
fi

if [[ -f "build/out/manuscript.tex" ]]; then
    cp build/out/manuscript.tex assets/paper/
    echo "   ✓ Copied manuscript.tex"
fi

# Generate HTML for letters from their markdown sources
echo "   Converting letters markdown to HTML..."
LETTERS=(
  "01 - collapse_oscillator_letter.md"
  "02 - gravitational-decoherence-oscillations.md"
  "03 - blackhole_galaxy_letter.md"
)

for letter in "${LETTERS[@]}"; do
    if [[ -f "letters/$letter" ]]; then
        basename="${letter%.md}"
        echo "   Converting $letter to HTML..."
        pandoc \
            --from=markdown+smart \
            --standalone \
            --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js \
            --citeproc \
            --metadata link-citations=true \
            --bibliography="references/references.bib" \
            --csl="references/harvard-cite-them-right.csl" \
            --css="/assets/css/paper.css" \
            "letters/$letter" \
            -o "assets/letters/$basename.html"
        echo "   ✓ Generated assets/letters/$basename.html"
        
        # Copy corresponding PDF if it exists
        if [[ -f "build/out/letters/$basename.pdf" ]]; then
            cp "build/out/letters/$basename.pdf" "assets/letters/"
            echo "   ✓ Copied $basename.pdf"
        fi
    else
        echo "   ⚠️  Warning: letters/$letter not found, skipping..."
    fi
done

echo "🏷️  Generating research notes tag cloud..."
if [[ -f "scripts/generate-tag-cloud.js" ]]; then
    node scripts/generate-tag-cloud.js
    echo "   ✓ Tag cloud generated"
else
    echo "   ⚠ Tag cloud script not found"
fi

echo "📝 Converting research notes to HTML..."
mkdir -p assets/notes
if [[ -d "research/notes" ]]; then
    for note in research/notes/*.md; do
        if [[ -f "$note" ]]; then
            basename=$(basename "$note" .md)
            pandoc "$note" -o "assets/notes/${basename}.html" \
                --standalone \
                --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js \
                --css="/assets/css/notes.css" \
                --metadata title="$basename" 2>/dev/null || echo "   ⚠ Failed to convert $note"
            echo "   ✓ Converted $basename.md"
        fi
    done
else
    echo "   ⚠ No research/notes directory found"
fi
echo "   Source of Truth: build/out/manuscript.tex (untouched)"
echo "   Vehicle (PDF):   assets/paper/manuscript.pdf (copied from build)"
echo "   Salesman (HTML): assets/paper/manuscript.html (fresh from markdown)"
echo ""
echo "   Letters PDFs:    assets/letters/*.pdf (copied from build)"
echo "   Letters HTML:    assets/letters/*.html (fresh from markdown)"
echo ""
echo "✅ All Jekyll assets built successfully!"
echo "   HTML has proper bib injection and math rendering via pandoc"
