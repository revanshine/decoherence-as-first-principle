# Jekyll Book Theme Integration Documentation

**Issue #5**: Add dark mode and new Jekyll-based 'open book' presentation for site

## Project Goals
- Present both 'letters and notes' and the main paper side by side, as if in a book
- No direct links to the paper unless via right-hand page anchors
- Site feels like evolving from initial theoretical paper to dynamic, growing work
- Maintain all GitHub Actions automatic deployment/integration
- Add dark mode support

## Current Setup Analysis
- **Current Theme**: Minima
- **Jekyll Plugins**: jekyll-seo-tag, jekyll-sitemap
- **GitHub Actions**: site.yml workflow with Jekyll Pages deployment, pandoc 3.1.11, TeX Live
- **Content Structure**: 
  - Main paper in `/build/` directory
  - Letters in `/letters/` directory
  - Research notes in `/research/notes/`
  - Assets in `/assets/` directory

## Theme Testing Process

### Test 1: Just-the-Docs Theme
**Repository**: `just-the-docs/just-the-docs` (8,488 stars)
**Started**: 2025-08-25T03:04:51Z

#### Initial Assessment
- ✅ Built-in dark mode support
- ✅ GitHub Pages compatible
- ✅ Active maintenance
- ✅ Excellent documentation structure
- ✅ Highly customizable

#### Integration Steps
1. [ ] Examine theme structure and requirements
2. [ ] Test basic integration with current setup
3. [ ] Assess compatibility with existing GitHub Actions workflow
4. [ ] Evaluate customization potential for book layout
5. [ ] Document any issues or limitations

#### Findings
- ✅ Theme configuration successfully created
- ✅ Gemfile and dependencies defined
- ✅ Bundle install completed successfully
- ✅ Docker environment created successfully
- ✅ **GitHub Pages gem resolved all compatibility issues**
- ✅ **Jekyll build successful with act (local GitHub Actions testing)**
- ✅ **Just-the-Docs theme fully functional**
- ❌ Local Jekyll serve fails due to protobuf dependency issues on macOS
- ❌ Docker Jekyll build fails with same protobuf dependency issues

#### Struggles Encountered
**Local Development Issues:**
1. **Protobuf dependency error**: `LoadError: cannot load such file -- google/protobuf_c`
   - Common issue with Jekyll 4.3+ and sass-embedded on both macOS and Alpine Linux
   - Affects both `jekyll serve` and `jekyll build` commands
   - Persists even in Docker environment (Ruby 3.1-alpine)
   - **RESOLVED**: Using GitHub Pages gem with Jekyll 3.10.0 and sass 3.7.4

**Docker Setup:**
- ✅ Successfully created Dockerfile and docker-compose.yml
- ✅ Docker build completed successfully
- ❌ Same protobuf issues in containerized environment
- **RESOLVED**: GitHub Pages gem uses compatible versions

**GitHub Actions Testing with `act`:**
- ✅ **Successful Jekyll build** using GitHub Pages environment
- ✅ **Just-the-Docs theme loaded correctly** (version 0.10.1)
- ✅ **Dark mode CSS generated** (`just-the-docs-dark.css`)
- ✅ **67 files generated** including all assets
- ⚠️ Layout warnings expected (Just-the-Docs uses different layout names)
- ❌ Artifact upload failed (expected - act doesn't have GitHub runtime tokens)

**Key Success Factors:**
- **Jekyll 3.10.0** (GitHub Pages version) vs Jekyll 4.3+
- **sass 3.7.4** (stable) vs sass-embedded (problematic)
- **GitHub Pages gem** provides exact compatibility versions

---

### Test 2: The Book Theme
**Repository**: `mesinkasir/the-book`
**Status**: Pending

#### Initial Assessment
*To be filled*

---

### Test 3: Electric Book Themes
**Repository**: `electricbookworks/electric-book-classic-theme`
**Status**: Pending

#### Initial Assessment
*To be filled*

---

## Implementation Notes
- Must maintain compatibility with existing pandoc build process
- Need to preserve current content structure
- GitHub Actions workflow must continue to work
- Dark mode implementation is priority

## Final Recommendations

### Current Status: Just-the-Docs Theme Integration ✅ WORKING

**Key Finding**: The theme works perfectly in GitHub Actions environment, local development issues are not blocking.

### Next Steps for Issue #5 Implementation

#### Phase 1: Book Layout Design (PRIORITY)
1. **Create custom layouts for book presentation:**
   - `_layouts/book.html` - Main book container with left/right pages
   - `_layouts/book-page.html` - Individual book pages
   - `_layouts/book-chapter.html` - Chapter/section pages

2. **Implement side-by-side presentation:**
   - Left page: Letters/notes navigation and content
   - Right page: Main paper sections
   - CSS Grid or Flexbox for responsive book layout

3. **Remove direct paper links:**
   - Replace with right-hand page anchors
   - Implement smooth scrolling between sections

#### Phase 2: Content Structure Reorganization
1. **Create book-style navigation:**
   - Table of contents as left page
   - Chapter/section progression
   - Page turning animations (optional)

2. **Integrate existing content:**
   - Main paper sections as right-hand pages
   - Letters as left-hand supplementary content
   - Research notes as margin notes or appendices

#### Phase 3: Dark Mode Enhancement
- ✅ Just-the-Docs already provides dark mode
- Customize dark mode colors for book aesthetic
- Add toggle button in book header

### Development Workflow Recommendation

**Use GitHub Actions as primary development environment:**
1. Make changes locally
2. Push to feature branch
3. GitHub Actions builds and deploys preview
4. Iterate based on live preview

**Benefits:**
- No local protobuf dependency issues
- Exact production environment
- Automatic deployment
- All existing workflows preserved

### Implementation Priority
1. **HIGH**: Create book layout CSS and HTML structure
2. **HIGH**: Implement side-by-side content presentation  
3. **MEDIUM**: Add page navigation and anchors
4. **LOW**: Polish animations and transitions

**Estimated Timeline**: 2-3 iterations (1 week with GitHub Actions workflow)
