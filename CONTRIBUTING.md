# Contribution and Style Guide

This document outlines the conventions for contributing to the **Decoherence Thesis** project.
Following these rules ensures consistency across all sections and makes the final LaTeX/PDF build clean.

---

## Headings
- **Top-level sections**: Use `##` (do not manually number — LaTeX handles numbering).
- **Subsections**: Use `###`.
- **Sub-subsections**: Use `####`.
- No trailing punctuation in headings.

## Paragraphs
- One idea per paragraph.
- Leave one blank line between paragraphs.
- Avoid overly long sentences; split for clarity.

## Emphasis
- Use `**bold**` for key technical terms being defined or emphasized in conclusions.
- Use `*italics*` for:
  - Newly introduced terms (*decoherence bootstrap*)
  - Variables/concepts referred to in running text
- Avoid combining italics and bold unless necessary.

## Lists
- Use `-` for unordered lists.
- Use `1.` for ordered lists (Markdown will auto-increment).
- Keep bullets concise; each bullet ≤ 2 sentences.

## Equations
- Inline math: `$a^2 + b^2 = c^2$`
- Display math:
  ```markdown
  $$E = mc^2$$