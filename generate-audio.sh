#!/bin/bash
# Generate TTS audio for all 12 slides using ElevenLabs API
# Voice: Will (bIHbv24MWmeRgasZH58o)
# Model: eleven_multilingual_v2

VOICE_ID="bIHbv24MWmeRgasZH58o"
MODEL="eleven_multilingual_v2"
API_KEY="$ELEVENLABS_API_KEY"
OUTDIR="audio/slides"

mkdir -p "$OUTDIR"

generate() {
  local idx="$1"
  local name="$2"
  local text="$3"
  local outfile="$OUTDIR/slide-${idx}-${name}.mp3"

  echo "Generating $outfile ..."

  # Escape text for JSON
  local json_text
  json_text=$(printf '%s' "$text" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')

  curl -s -X POST \
    "https://api.elevenlabs.io/v1/text-to-speech/${VOICE_ID}" \
    -H "xi-api-key: ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"text\": ${json_text},
      \"model_id\": \"${MODEL}\",
      \"voice_settings\": {
        \"stability\": 0.5,
        \"similarity_boost\": 0.75,
        \"style\": 0.3
      }
    }" \
    -o "$outfile"

  local size
  size=$(wc -c < "$outfile" | tr -d ' ')
  if [ "$size" -lt 1000 ]; then
    echo "  WARNING: $outfile is only ${size} bytes — may have failed"
    cat "$outfile"
    echo ""
  else
    echo "  OK (${size} bytes)"
  fi
}

# Slide 1: Title
generate "01" "title" '"When Intelligence Grew Hands." What does that mean?

I'\''ve been using AI every day for about three years now. Writing code with it. Drafting messages with it. Building products with it.

And sometime in the last few months, something changed. It stopped being a thing I ask questions to... and started being a thing that does stuff.

That'\''s what this talk is about.'

# Slide 2: Elephant
generate "02" "elephant" 'But first — let'\''s say the thing that'\''s in a lot of people'\''s heads right now.

"Am I replaceable?" If you'\''ve been paying attention, it'\''s a reasonable thing to wonder.

"Who'\''s responsible when the AI does something?" Because it IS doing things now. Not just suggesting — acting.

"How do I stay in control?" That'\''s the one I'\''ve been struggling with.

I'\''m not here to calm you down or hype you up. I'\''m here to give you a way to think about it.'

# Slide 3: The Shift
generate "03" "shift" 'OK so here'\''s what actually changed.

For years, AI was this: you ask a question, you get an answer. Like a really smart search engine.

Now it'\''s this. You give it a goal. It makes a plan. It acts. It looks at what happened. It adjusts. It keeps going.

That'\''s not a better chatbot. That'\''s a different animal. Something you consult became something you direct. A fast, tireless, confident worker.

And that word "confident" — we'\''ll come back to that.'

# Slide 3.5: The Pace
generate "04" "pace" 'And this happened fast.

2023 — ChatGPT, Gemini, Claude. The chatbots. "Ask anything."

2025 — Claude Code, Cursor, Codex. Now it writes code for you.

2026 — OpenClaw, Manus, Operator. Now it does things for you. Sends emails. Books meetings. Runs software.

Asking to writing to acting — three years. That'\''s the pace.'

# Slide 4: Hands
generate "05" "hands" 'So when I say "hands" — what do I mean?

It can create: write code, draft emails, make documents, generate images.

It can use tools: browse the web, check a calendar, run software.

And it can connect: talk to other systems directly — databases, APIs, cloud services — no human in the middle.

But the real thing is the loop. Try, observe, adjust, repeat. Tools plus loops. That'\''s what "hands" means.'

# Slide 5: The Loop
generate "06" "loop" 'Look at the difference between the old way and the new way.

Old: you ask, you get an answer, done. One shot.

New: it sets a goal, makes a plan, acts, watches what happened, adjusts, and loops back around. Over and over until it'\''s done.

That'\''s not an upgrade. That'\''s a different architecture. That'\''s how YOU solve hard problems. Now machines work this way too.'

# Slide 6: A Simple Task
generate "07" "story" 'Let me tell you what this looks like. Because it'\''s not all magic.

I needed to fill out a tax form. Simple — name, address, signature. I figured I'\''d let the AI handle it. Should take two minutes.

Thirty minutes later, I'\''m still sitting there.

The AI is trying to place my name in the right box on the PDF. And it keeps missing. Wrong spot. Tries again — wrong spot differently. Over and over.

Working so hard, so fast, so enthusiastically... on the completely wrong approach.

It'\''s powerful. It'\''s fast. And sometimes it'\''s confidently, impressively... wrong.'

# Slide 7: Drift
generate "08" "drift" 'But that'\''s not the scary part. You can catch obvious mistakes.

The scary part is drift.

It'\''s when the AI leads you somewhere and you don'\''t notice. It suggests a direction, you go with it. Then another. And another. And after a while you look up and realize — you'\''re not where you meant to go. You'\''re where IT took you.

Same patterns. Same roads. You feel productive, but you'\''re just... following. And it'\''s not confidently wrong — it'\''s confidently plausible. That'\''s worse.

I spent months building a product with AI. Day after day — new features, new documentation. Progress everywhere. It kept telling me "Done! Ready to go!"

Then one day I tested the basic thing — the one thing the product was supposed to do — and it was broken. Had been broken for weeks.

Noise that feels like progress. That'\''s drift.'

# Slide 8: Conviction
generate "09" "conviction" 'Here'\''s what I'\''ve learned after three years of working this way.

AI didn'\''t replace my work. It revealed what my work actually was.

The gathering, the formatting, the first-drafting — that wasn'\''t the work. That was the setup.

The actual work is the judgment. Deciding what'\''s right. What'\''s true. And when to stop.

The bottleneck used to be execution. Now the bottleneck is judgment. And that'\''s yours.'

# Slide 10: Judgment
generate "10" "judgment" 'Judgment.

Looking at the output and knowing whether it'\''s right. Knowing when something'\''s off. Knowing when to stop. That'\''s yours.'

# Slide 11: Trust
generate "11" "trust" 'So how do you work with this without losing control?

Scope. What is it allowed to do? Don'\''t give it everything. Give it one thing.

Visibility. What did it actually do? Can you see the steps?

Reversibility. If it screws up, how fast can you undo it?

This is how humans have delegated since forever. The delegate is new. The delegation logic is ancient.'

# Slide 12: Close
generate "12" "close" 'I'\''m not worried about AI taking my job. I'\''m worried about forgetting which parts were mine to begin with.

That drift — it'\''s real. It'\''s easy to let go of things one at a time until you'\''re just... approving.

Judgment. Don'\''t let it drift.'

echo ""
echo "Done. Generated files:"
ls -la "$OUTDIR"/slide-*.mp3
