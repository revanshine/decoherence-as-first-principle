# Decoherence as First Principle: A Framework for Emergent Forces, Dark Matter, and Cosmological Structure

**What if cosmic structure arises from quantum decoherence itself?**

This project presents a new theoretical framework where ontological decoherence underlies gravity, dark matter, and the forces shaping our universe.

---

## 📄 Download the Latest Preprint

[⬇ Download or view the latest manuscript PDF](https://github.com/revanshine/decoherence-as-first-principle/releases/download/preprint-latest/manuscript.pdf)

---

## 🚀 What You'll Find
- Harvard-style, fully cited PDF + LaTeX sources
- Topics:
  - Quantum decoherence driving cosmic evolution
  - Emergence of gravity, dark matter, and classical laws
  - A unified perspective on forces and structure formation

---

## 🛠 How to Build

> **Just want the paper?**
> [Download the PDF above.](https://github.com/revanshine/decoherence-as-first-principle/releases/download/preprint-latest/manuscript.pdf)

To build from source:
1. Clone this repo.
2. `bash build/build.sh` (requires Pandoc and TeX Live).
3. Output: `build/out/manuscript.pdf` and `.tex`

---

## 🧪 Testing & Development

### Local Testing Options

**Quick Build Test (Recommended):**
```bash
# Test core manuscript building
bash build/build.sh
# Output: build/out/manuscript.pdf and .tex
```

**GitHub Actions Workflow Testing:**

The repository includes automated workflows for building and deploying:
- `site.yml` - Builds manuscript + deploys GitHub Pages site
- `build_letters.yml` - Builds research letters from markdown

**Using `act` for Local Workflow Testing:**

You can test workflows locally using [act](https://github.com/nektos/act):

```bash
# Validate workflow structure (fast)
act --container-architecture linux/amd64 --job build --dryrun

# Test individual workflow steps manually:
# 1. Build manuscript
bash build/build.sh

# 2. Test HTML generation
mkdir -p assets/paper
cp build/out/manuscript.pdf assets/paper/
cp build/out/manuscript.tex assets/paper/
pandoc build/out/manuscript.tex --standalone --mathjax --citeproc -o assets/paper/manuscript.html
```

**Limitations of Local Testing:**
- ✅ **Works well:** Workflow validation, core build logic, individual steps
- ❌ **Problematic:** GitHub Pages actions (GitHub-specific), heavy TeX Live installation (~10-15 min), multi-job dependencies

**Recommended Approach:**
1. Use direct script testing for fastest feedback
2. Test individual workflow steps manually
3. Use `act --dryrun` for workflow validation
4. Rely on GitHub Actions for full integration testing (Pages deployment is cloud-dependent)

### Build Requirements
- Pandoc 3.1.11+
- TeX Live (latex-recommended, latex-extra, fonts packages)
- For local testing: Docker (for `act`)

---

## 📖 Citation & License

- Please see [CITATION.cff](CITATION.cff) for citation info.
- Cite as:
    > Evanshine, R. *Decoherence as First Principle* (2025), GitHub: revanshine/decoherence-as-first-principle.
- License: CC-BY-4.0

---

## Credits

- Harvard Cite Them Right style (`references/harvard-cite-them-right.csl`)
- Inspired by open science and reproducibility best practices
