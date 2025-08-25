---
layout: default
title: Letters
nav_order: 2
permalink: /letters/
---

# Research Letters

Short research notes and explorations related to decoherence as a first principle.

## Available Letters

{% assign letter_files = site.static_files | where: "extname", ".html" | where_exp: "file", "file.path contains '/assets/letters/'" %}

{% for file in letter_files %}
  {% assign basename = file.basename %}
  {% assign pdf_path = file.path | replace: ".html", ".pdf" %}
  
- **{{ basename | replace: "-", " " | replace: "_", " " | capitalize }}**
  - [Read HTML]({{ file.path | relative_url }})
  - [Download PDF]({{ pdf_path | relative_url }})

{% endfor %}

{% if letter_files.size == 0 %}
*No letters available yet. Run `./make` to generate them.*
{% endif %}
