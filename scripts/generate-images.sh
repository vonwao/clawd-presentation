#!/bin/bash
# Generate all slide images via Replicate Flux Pro
# Usage: REPLICATE_API_TOKEN=xxx bash scripts/generate-images.sh

set -e
OUTDIR="$(dirname "$0")/../images"
mkdir -p "$OUTDIR"

MODEL="black-forest-labs/flux-1.1-pro"
STYLE="Style guide: cinematic photography, dark moody tones, blue-black palette with subtle red accents, shallow depth of field, minimal compositions with generous negative space. 16:9 aspect ratio, presentation quality."

declare -A PROMPTS
PROMPTS["00-title.jpg"]="Dark ocean surface at night, a single lobster claw breaking through the water from below, lit by cold moonlight. Minimal, ominous, beautiful. Deep blue-black water, subtle red on the claw. Wide shot with negative space in upper half for title text. $STYLE"
PROMPTS["01-brain-in-jar.jpg"]="A luminous human brain suspended in a large glass bell jar, sitting on a dark wooden surface. The brain glows with soft blue-white bioluminescence. Dark background, dramatic side lighting. Mood: beautiful but isolated, intelligence without agency. $STYLE"
PROMPTS["04-empty-office.jpg"]="A modern minimalist office at dusk. One desk, one laptop open with screen glowing, an ergonomic chair slightly pulled back as if someone just left or was never there. No people. Floor-to-ceiling windows showing a city skyline at blue hour. Slightly eerie, liminal. Cool blue-gray palette. Wide shot. $STYLE"
PROMPTS["07-texture-future.jpg"]="Morning light filtering through sheer curtains onto a desk with a coffee cup, phone, and laptop. Everything looks normal but subtly uncanny, the screen shows work being done with no one at the keyboard. Warm golden light meets cool blue screen glow. Intimate, quiet, slightly surreal. $STYLE"
PROMPTS["08-uncanny-middle.jpg"]="A long empty hallway in a modern office building, fluorescent lights creating pools of light and shadow. One door slightly ajar at the end. Liminal space aesthetic. Cool blue-green tones, slightly desaturated. No people. The feeling of presence without a person. Wide shot, centered perspective. $STYLE"
PROMPTS["12-closing.jpg"]="Two hands reaching toward each other, one human hand and one elegant mechanical robotic hand, in dark space, lit by a single warm light source from above. Not touching yet. Inspired by Michelangelo Creation of Adam but modern and restrained. The mechanical hand should be elegant not threatening. Warm light, dark background. $STYLE"

for FILE in "${!PROMPTS[@]}"; do
  echo "🎨 Generating $FILE..."
  PROMPT="${PROMPTS[$FILE]}"
  
  # Create prediction
  RESPONSE=$(curl -s -X POST "https://api.replicate.com/v1/models/$MODEL/predictions" \
    -H "Authorization: Bearer $REPLICATE_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"input\":{\"prompt\":\"$PROMPT\",\"aspect_ratio\":\"16:9\",\"output_format\":\"jpg\",\"output_quality\":90}}")
  
  PRED_URL=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('urls',{}).get('get',''))" 2>/dev/null)
  
  if [ -z "$PRED_URL" ]; then
    echo "  ❌ Failed to create prediction for $FILE"
    echo "  $RESPONSE"
    continue
  fi
  
  # Poll until complete
  echo "  ⏳ Waiting..."
  for i in $(seq 1 60); do
    sleep 3
    STATUS=$(curl -s "$PRED_URL" -H "Authorization: Bearer $REPLICATE_API_TOKEN")
    STATE=$(echo "$STATUS" | python3 -c "import sys,json; print(json.load(sys.stdin).get('status',''))" 2>/dev/null)
    
    if [ "$STATE" = "succeeded" ]; then
      IMG_URL=$(echo "$STATUS" | python3 -c "import sys,json; o=json.load(sys.stdin).get('output',''); print(o if isinstance(o,str) else o[0] if isinstance(o,list) else '')" 2>/dev/null)
      curl -sL "$IMG_URL" -o "$OUTDIR/$FILE"
      echo "  ✅ Saved $OUTDIR/$FILE"
      break
    elif [ "$STATE" = "failed" ]; then
      echo "  ❌ Generation failed for $FILE"
      break
    fi
  done
done

echo ""
echo "Done! Images saved to $OUTDIR/"
ls -lh "$OUTDIR/"
