#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Configuration
const NOTES_DIR = 'research/notes';
const OUTPUT_FILE = '_data/tag-cloud.json';

// Common physics/research terms to extract
const PHYSICS_KEYWORDS = [
  'quantum', 'decoherence', 'gravity', 'black hole', 'cosmology', 'universe',
  'relativity', 'spacetime', 'entropy', 'information', 'dynamics', 'evolution',
  'field', 'particle', 'wave', 'energy', 'mass', 'force', 'interaction',
  'symmetry', 'gauge', 'invariance', 'conservation', 'thermodynamics',
  'statistical', 'mechanics', 'equation', 'solution', 'theory', 'model',
  'observation', 'experiment', 'measurement', 'uncertainty', 'probability',
  'superposition', 'entanglement', 'coherence', 'interference', 'collapse',
  'eigenvalue', 'operator', 'hamiltonian', 'lagrangian', 'action',
  'geodesic', 'curvature', 'metric', 'tensor', 'manifold', 'topology',
  'singularity', 'horizon', 'radiation', 'temperature', 'pressure',
  'density', 'velocity', 'acceleration', 'momentum', 'angular', 'spin',
  'charge', 'electromagnetic', 'nuclear', 'weak', 'strong', 'fundamental',
  'standard', 'beyond', 'extension', 'modification', 'alternative',
  'phenomenology', 'prediction', 'constraint', 'bound', 'limit',
  'galaxy', 'stellar', 'planetary', 'cosmic', 'dark', 'matter', 'energy',
  'inflation', 'expansion', 'redshift', 'luminosity', 'magnitude',
  'spectrum', 'frequency', 'wavelength', 'photon', 'neutrino', 'boson',
  'fermion', 'lepton', 'quark', 'gluon', 'higgs', 'supersymmetry',
  'string', 'brane', 'dimension', 'compactification', 'duality',
  'holography', 'correspondence', 'emergence', 'effective', 'renormalization'
];

// Extract tags from markdown content
function extractTags(content, filename) {
  const tags = new Set();
  
  // Extract from frontmatter if present
  const frontmatterMatch = content.match(/^---\n([\s\S]*?)\n---/);
  if (frontmatterMatch) {
    const frontmatter = frontmatterMatch[1];
    const tagsMatch = frontmatter.match(/tags:\s*\[(.*?)\]/);
    if (tagsMatch) {
      const frontmatterTags = tagsMatch[1].split(',').map(t => t.trim().replace(/['"]/g, ''));
      frontmatterTags.forEach(tag => tags.add(tag.toLowerCase()));
    }
  }
  
  // Extract from title (filename)
  const titleWords = filename.replace('.md', '').split(/[\s\-_]+/);
  titleWords.forEach(word => {
    if (word.length > 3 && PHYSICS_KEYWORDS.includes(word.toLowerCase())) {
      tags.add(word.toLowerCase());
    }
  });
  
  // Extract from headers
  const headers = content.match(/^#+\s+(.+)$/gm) || [];
  headers.forEach(header => {
    const headerText = header.replace(/^#+\s+/, '').toLowerCase();
    const words = headerText.split(/[\s\-_]+/);
    words.forEach(word => {
      if (word.length > 3 && PHYSICS_KEYWORDS.includes(word)) {
        tags.add(word);
      }
    });
  });
  
  // Extract physics keywords from content
  const contentLower = content.toLowerCase();
  PHYSICS_KEYWORDS.forEach(keyword => {
    if (contentLower.includes(keyword)) {
      tags.add(keyword);
    }
  });
  
  // Extract mathematical terms (LaTeX)
  const mathTerms = content.match(/\$\$?([^$]+)\$\$?/g) || [];
  mathTerms.forEach(term => {
    const cleanTerm = term.replace(/\$+/g, '').trim();
    if (cleanTerm.match(/\\(rho|psi|phi|theta|lambda|sigma|gamma|delta|alpha|beta)/)) {
      tags.add('mathematics');
    }
    if (cleanTerm.includes('\\frac') || cleanTerm.includes('\\int')) {
      tags.add('calculus');
    }
    if (cleanTerm.includes('\\sum') || cleanTerm.includes('\\prod')) {
      tags.add('algebra');
    }
  });
  
  return Array.from(tags);
}

// Generate fake popularity weights
function generateWeight(tag, filename, allTags) {
  // Base weight on tag frequency across all files
  const frequency = allTags.filter(t => t === tag).length;
  
  // Add some randomness for visual variety
  const randomFactor = Math.random() * 0.5 + 0.5; // 0.5 to 1.0
  
  // Boost certain important tags
  const boostTerms = ['quantum', 'decoherence', 'gravity', 'black hole', 'cosmology'];
  const boost = boostTerms.includes(tag) ? 1.5 : 1.0;
  
  return Math.round((frequency * randomFactor * boost) * 10) / 10;
}

// Main function
function generateTagCloud() {
  console.log('🏷️  Generating tag cloud from research notes...');
  
  // Ensure output directory exists
  const outputDir = path.dirname(OUTPUT_FILE);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }
  
  // Read all markdown files
  const notesPath = path.resolve(NOTES_DIR);
  const files = fs.readdirSync(notesPath).filter(f => f.endsWith('.md'));
  
  console.log(`📚 Found ${files.length} note files`);
  
  const allTags = [];
  const noteData = [];
  
  // Process each file
  files.forEach(filename => {
    const filepath = path.join(notesPath, filename);
    const content = fs.readFileSync(filepath, 'utf8');
    const tags = extractTags(content, filename);
    
    allTags.push(...tags);
    noteData.push({
      filename,
      title: filename.replace('.md', '').replace(/[-_]/g, ' '),
      tags,
      path: `research/notes/${filename}`
    });
    
    console.log(`   ✓ ${filename}: ${tags.length} tags`);
  });
  
  // Create weighted tag cloud
  const tagCounts = {};
  allTags.forEach(tag => {
    tagCounts[tag] = (tagCounts[tag] || 0) + 1;
  });
  
  const tagCloud = Object.entries(tagCounts).map(([tag, count]) => ({
    tag,
    weight: generateWeight(tag, '', allTags),
    count,
    notes: noteData.filter(note => note.tags.includes(tag)).map(note => ({
      title: note.title,
      filename: note.filename,
      path: note.path
    }))
  })).sort((a, b) => b.weight - a.weight);
  
  // Output data
  const output = {
    generated: new Date().toISOString(),
    totalNotes: files.length,
    totalTags: tagCloud.length,
    tagCloud,
    notes: noteData
  };
  
  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(output, null, 2));
  
  console.log(`✨ Generated tag cloud with ${tagCloud.length} unique tags`);
  console.log(`📊 Top tags: ${tagCloud.slice(0, 5).map(t => `${t.tag}(${t.weight})`).join(', ')}`);
  console.log(`💾 Saved to ${OUTPUT_FILE}`);
}

// Run if called directly
if (require.main === module) {
  generateTagCloud();
}

module.exports = { generateTagCloud };
