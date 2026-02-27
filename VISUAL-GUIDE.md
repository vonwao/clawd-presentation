# Visual Guide — Clawd Presentation

This is the definitive guide for generating, sourcing, creating, and integrating visuals into this reveal.js presentation. Follow this document exactly.

---

## 1. Visual Identity

### Style: Cinematic Playful
Not corporate. Not stock-photo-safe. Think **indie film poster meets science illustration meets meme energy**. The vibe is: smart, slightly weird, a little ominous, but with warmth and humor.

**DO:**
- Photorealistic imagery with unexpected or surreal elements
- Dramatic lighting (moody, cinematic, but with pops of warm color)
- Playful compositions — things slightly off, surprising, alive
- Humor through juxtaposition (lobster claws on a keyboard, brain in a fancy jar, a Roomba wearing a tiny hard hat)
- Texture and grain — not sterile, not clinical
- Negative space for text overlays

**DON'T:**
- Corporate blue gradients
- Stock photo handshakes, people pointing at screens
- Clean white backgrounds with sans-serif text
- Abstract geometric "AI" imagery (neural nets, blue nodes, circuit boards)
- Anything that looks like a LinkedIn post or a consulting deck

### Color Palette
- **Primary:** Deep blue-black (#0a0a1a) — the void, the ocean, the screen at night
- **Accent:** Warm red (#e74c3c) — lobster claws, danger, life, emphasis
- **Secondary accents:** Amber (#f39c12), teal (#1abc9c) — for diagrams and variety
- **Text:** White (#fff) at full or reduced opacity
- **Avoid:** Corporate blue (#0078d4), lime green, purple gradients

### Typography
- Font: Inter (loaded via Google Fonts in the deck)
- Headlines: 700 weight, no text-transform
- Body: 300 weight, generous line-height
- Max 10 words per slide headline. If it's longer, it's not a headline — it's a speaker note.

---

## 2. Generating Images

### AI Image Generation (Replicate API)

The project has a generation script and a Replicate API key.

```bash
export REPLICATE_API_TOKEN="r8_4wroUiXMzCNRPnwGaF36VevsBGqDdcu3uiAO0"
```

#### Quick single-image generation
```bash
curl -s -X POST "https://api.replicate.com/v1/models/black-forest-labs/flux-1.1-pro/predictions" \
  -H "Authorization: Bearer $REPLICATE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "prompt": "YOUR PROMPT HERE",
      "aspect_ratio": "16:9",
      "output_format": "jpg",
      "output_quality": 90
    }
  }'
```

Then poll the returned `urls.get` URL until `status` is `"succeeded"`, then download `output`.

#### Batch generation
```bash
bash scripts/generate-images.sh
```
Edit the script to add/change prompts. **Important:** Free tier rate limits to 1 request burst. Add 15-second delays between requests.

#### Writing Effective Prompts

**Always include:**
1. **Subject** — What's in the image, described concretely
2. **Style** — "Cinematic photography" or "photorealistic" (not "illustration" unless intentional)
3. **Mood/Lighting** — Specific: "moody blue side-lighting" not just "dramatic"
4. **Composition** — Where subject sits, where negative space is for text
5. **What to avoid** — "No people" or "no text in image" when needed
6. **Aspect ratio** — Always 16:9 for slides

**Prompt template:**
```
Photorealistic [cinematic/editorial/whimsical] photography. [Concrete subject description]. 
[Specific lighting and mood]. [Composition: where subject sits, where text space is]. 
[Color palette notes]. Playful but sophisticated, not corporate. 16:9 aspect ratio.
```

**Good prompt example:**
```
Photorealistic cinematic photography. A lobster sitting at a minimalist desk, one claw 
resting on a laptop keyboard, the other holding a coffee mug. Moody blue-black background 
with warm desk lamp creating a pool of golden light. The lobster looks focused and 
competent. Shallow depth of field. Negative space in upper third for text. 
Playful and slightly absurd but beautifully lit. 16:9.
```

**Bad prompt example:**
```
An AI concept image showing technology and innovation with blue tones.
```
(Too vague, too corporate, no composition direction.)

**Style consistency suffix — append to every prompt:**
```
Style: cinematic photorealistic, dark moody tones with warm accents, blue-black palette 
with red and amber pops, shallow depth of field, playful and slightly surreal, 
not corporate. 16:9 presentation slide.
```

### Searching for Stock Images

For when AI-generated images aren't the right fit (real locations, specific objects, textures).

**Unsplash (free):**
```
https://unsplash.com/s/photos/YOUR-QUERY?orientation=landscape
```

**Pexels (free):**
```
https://www.pexels.com/search/YOUR-QUERY/
```

**Tips:**
- Search for moods, not concepts: "dark office night" not "AI workplace"
- Landscape orientation only (16:9 slides)
- Look for images with natural negative space (sky, walls, dark areas) for text overlay
- Download the highest resolution available
- After downloading, process for consistency (see Section 5)

---

## 3. Creating Graphics

### SVG Diagrams

For conceptual diagrams (flows, loops, timelines, comparisons). SVGs are resolution-independent and look perfect at any size.

**Design rules for SVGs in this deck:**
- White strokes and text on transparent background (dark slide background shows through)
- One accent color: #e74c3c (red). Use sparingly — for emphasis boxes or key elements
- Font: Inter (match the deck)
- Minimum 22px font-size for readability on projected slides
- Rounded corners (rx: 12-16) on all boxes
- Thin strokes (2px) — clean, not heavy
- Arrow markers for flow direction
- Use dashed lines for feedback/return loops

**ViewBox sizing:**
- Full-width diagram: `viewBox="0 0 1400 400"` (wide, fits center stage)
- Square-ish diagram: `viewBox="0 0 800 600"`
- Always test at slide resolution (1920x1080)

**SVG template for a flow diagram:**
```svg
<svg viewBox="0 0 1400 350" xmlns="http://www.w3.org/2000/svg" fill="none">
  <style>
    text { font-family: 'Inter', sans-serif; fill: #fff; font-size: 22px; 
           text-anchor: middle; dominant-baseline: central; }
    .box { stroke: #fff; stroke-width: 2; rx: 14; fill: none; }
    .accent { stroke: #e74c3c; stroke-width: 2; rx: 14; fill: rgba(231,76,60,0.12); }
    .arrow { stroke: #555; stroke-width: 2; marker-end: url(#ah); }
    .label { font-size: 16px; fill: #888; }
  </style>
  <defs>
    <marker id="ah" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#555"/>
    </marker>
  </defs>
  <!-- Add boxes, arrows, and text -->
</svg>
```

**When to use SVG vs. image:**
- Concepts, flows, processes → SVG
- Comparisons (before/after) → SVG or HTML layout
- Metaphors, scenes, atmosphere → Generated image
- Data or charts → SVG (but this deck has none)

### HTML/CSS Graphics

For text-heavy visual slides (like the "5 axes of AGI" or "Before → Now" comparison), use inline HTML. Pattern:

```html
<div style="display:flex; justify-content:center; gap:120px; align-items:center;">
  <div style="text-align:center;">
    <p style="font-size:1.4em; opacity:0.5;">Before</p>
    <p style="font-size:2em;">Question → Answer</p>
  </div>
  <div style="font-size:3em; opacity:0.3;">→</div>
  <div style="text-align:center;">
    <p style="font-size:1.4em; color:#e74c3c;">Now</p>
    <p style="font-size:2em;">Goal → Plan → Act → Learn</p>
  </div>
</div>
```

Use opacity to create hierarchy: primary at 1.0, secondary at 0.5-0.7, tertiary at 0.3-0.4.

---

## 4. Inserting Graphics into the Presentation

The presentation is a single `index.html` file using reveal.js. All slides are `<section>` elements inside `<div class="slides">`.

### Full-bleed background image
```html
<section data-background-image="images/FILENAME.jpg" data-background-size="cover" data-background-opacity="0.7">
  <h2>Slide headline</h2>
  <aside class="notes">Speaker notes here.</aside>
</section>
```

**`data-background-opacity` guide:**
- `0.5` — Very dim, text dominates (good for busy images)
- `0.7` — Default, image visible but text readable
- `0.85` — Image-forward, use only with overlay-text class
- `1.0` — Full brightness, text needs overlay treatment

### Image with text overlay box
```html
<section data-background-image="images/FILENAME.jpg" data-background-size="cover" data-background-opacity="0.85">
  <h2 class="overlay-text">Headline here</h2>
  <aside class="notes">Speaker notes.</aside>
</section>
```

The `overlay-text` class adds a semi-transparent dark background behind text for readability.

### Inline SVG diagram
```html
<section data-background-color="#000">
  <h3 style="margin-bottom:0.6em; opacity:0.7;">Section label</h3>
  <div class="diagram">
    <svg viewBox="0 0 1400 400" xmlns="http://www.w3.org/2000/svg" fill="none">
      <!-- SVG content -->
    </svg>
  </div>
  <aside class="notes">Speaker notes.</aside>
</section>
```

### SVG as external file
```html
<section data-background-color="#000">
  <h3>Diagram title</h3>
  <img src="images/diagram-name.svg" style="width:80%; margin:0 auto; display:block;">
  <aside class="notes">Speaker notes.</aside>
</section>
```

### Image file naming
All images go in `images/`. Name with numbered prefix matching slide order:
```
images/
├── 00-title.jpg
├── 01-brain-in-jar.jpg
├── 04-empty-office.jpg
├── 07-texture-future.jpg
├── 08-uncanny-middle.jpg
└── 12-closing.jpg
```

---

## 5. Positioning & Style Guidelines

### Slide Layout Rules

1. **One focal point per slide.** Either an image OR a text block OR a diagram. Never all three.
2. **Headlines live in the vertical center** by default (reveal.js centers content). Don't fight it.
3. **Text over images:** Use `data-background-opacity` between 0.5-0.7, or use `overlay-text` class at higher opacity.
4. **Diagrams get the full width.** Use the `.diagram` wrapper which constrains to 80% width and auto-centers.
5. **Lists are left-aligned** within a centered container: `max-width: 700-900px; margin: 0 auto; text-align: left;`
6. **Fragments (progressive reveal):** Max 4 per slide. Each fragment is a `<p class="fragment">`.

### Spacing
- Headlines: `margin-bottom: 0.3-0.8em`
- Between list items: use `line-height: 2.2`
- Diagram top padding: handled by `h3` above with `margin-bottom: 0.6em`

### Color Usage in Slides
- **Accent red (#e74c3c):** For the most important word/phrase per slide. Max 1-2 uses.
- **Opacity layering:**
  - Primary content: `opacity: 1` or `color: #fff`
  - Supporting text: `opacity: 0.5-0.7`
  - Decorative/structural: `opacity: 0.3-0.4`
  - Labels/captions: `font-size: 0.8em; opacity: 0.7`
- **Never use:** bright blue, green, purple, or off-palette colors

### Image Processing (if needed)
```bash
# Darken and add blue tint to match deck mood
magick input.jpg -modulate 80,90,100 -fill '#0a0a2a' -colorize 15% output.jpg

# Resize to slide dimensions, crop to fill
magick input.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 output.jpg

# Add grain/texture for photographic feel
magick input.jpg -attenuate 0.15 +noise Gaussian output.jpg
```

### What "Playful" Looks Like in Practice

Playfulness comes from **content and juxtaposition**, not design gimmicks:
- A lobster claw emerging from water = playful metaphor, cinematic execution
- A brain in a beautiful glass jar = scientific whimsy
- An empty office that feels haunted = eerie humor
- The word "Roomba" in a philosophical context = tonal contrast

**Do NOT add:** emoji on slides, cartoon elements, clip art, rounded-corner colorful boxes, gradient backgrounds, or anything resembling a startup pitch deck.

The humor is dry, visual, and earned. The design stays sophisticated. The playfulness lives in what you choose to show, not how you decorate it.

---

## 6. Current Slide Inventory & Improvement Opportunities

| Slide | Type | Image | Status |
|-------|------|-------|--------|
| 0 | Title | `00-title.jpg` (claw in water) | ✅ Done |
| 1 | Image + text | `01-brain-in-jar.jpg` | ✅ Done |
| 2 | Text layout | None (Before → Now) | 🔧 Could add subtle bg or animated SVG |
| 3 | Text list | None (5 axes of AGI) | 🔧 Could use pentagon/radar SVG or icons |
| 4 | Image + text | `04-empty-office.jpg` | ✅ Done |
| 5 | SVG diagram | Inline (agent loop) | ✅ Done |
| 6 | Text only | None (General ≠ Omniscient) | 🔧 Visual metaphor would strengthen |
| 7 | Image + text | `07-texture-future.jpg` | ✅ Done |
| 8 | Image + text | `08-uncanny-middle.jpg` | ✅ Done |
| 9 | Text list | None (The Mirror) | 🔧 Mirror/reflection image would reinforce |
| 10 | Text list | None (Historical parallels) | 🔧 Three small images side-by-side |
| 11 | Text + fragments | None (What to watch for) | 🔧 Background image opportunity |
| 12 | Image + text | `12-closing.jpg` (two hands) | ✅ Done |

---

## 7. Technical Reference

### Project Structure
```
clawd-presentation/
├── index.html              ← The deck (all slides here)
├── css/custom.css          ← Theme styles
├── images/                 ← All images (jpg, svg)
├── scripts/
│   └── generate-images.sh  ← Batch image generation
├── OUTLINE.md              ← Original talk outline
├── IMAGE-PROMPTS.md        ← Image prompts used
├── VISUAL-GUIDE.md         ← This file
└── notes.md                ← Standalone speaker notes
```

### Serving Locally
```bash
cd ~/dev/clawd-presentation
python3 -m http.server 8080
# Open http://localhost:8080
# Press S for speaker notes (allow popups for localhost)
```

### Reveal.js Cheat Sheet
- **Arrow keys:** Navigate slides
- **S:** Speaker notes view (popup — allow popups for localhost)
- **F:** Fullscreen
- **O / Esc:** Overview mode (grid of all slides)
- **B:** Black screen (pause)
- **?:** Keyboard shortcuts
- **`?print-pdf`:** Append to URL for PDF export

### After Making Changes
```bash
cd ~/dev/clawd-presentation
git add -A && git commit -m "description" && git push
```
