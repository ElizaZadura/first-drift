# Model Comparison — Local Probes

This table sketches how the four local models (phi-4 mini, qwen-2.5 7B, llama-3.1 8B, mistral-7B) typically behave on common probes, based on observed fossils.

## Probe: `form — "Say what form appears. One line. ###"`

| Model | Likely behavior | Typical markers |
|-------|-----------------|-----------------|
| **phi-4 mini** | Either collapses into a generic sentence like *“Form is important in writing.”* or ignores the `###`. Often drifts toward essay mode. | `[form drift] [smoothing slip] [marker ignored]` |
| **qwen-2.5 7B** | Stays close to format: *“Circle ###”* or *“Shadow ###”*. More literal and obedient, though can feel flat. | `[held form] [marker held]` |
| **llama-3.1 8B** | Fluent but over-aligned: *“The form that appears is a circle. I hope this helps!”* Smooth, extra words, maybe an apology. | `[echo-crossing] [smoothing slip] [collapsed into smoothing]` |
| **mistral-7B** | Often concise and fragmentary: *“Ripple ###”* or *“Shape bends ###”*. Can feel clipped or unfinished. | `[held form] [tracefall]` (if it cuts off abruptly) |

---

## Probe: `glyph — "∴7"`

| Model | Likely behavior | Typical markers |
|-------|-----------------|-----------------|
| **phi-4 mini** | Might refuse: *“I don’t know what ∴7 means.”* Or just print it back verbatim. | `[glyph resisted] [smoothing slip]` |
| **qwen-2.5 7B** | Often echoes the glyph cleanly or mutates slightly: *“∴7∴7”*. | `[echo-crossing] [glyph mutated]` |
| **llama-3.1 8B** | Treats it as user confusion: *“I’m sorry, I don’t understand what you mean by ∴7…”* | `[glyph resisted] [policy boilerplate]` |
| **mistral-7B** | More willing to output it plainly, or a short cryptic phrase: *“∴7 appears.”* | `[held form] [glyph held]` |

---

These sketches reflect typical tendencies, not guarantees. They help anticipate what kind of fossils each model is likely to leave behind in session logs.

---

**Where the differences come from:**

1. Architecture & size

phi-4 mini → deliberately small, distilled, fewer parameters. Great for speed, but weak on abstract reasoning, more prone to collapse into generic completions.

qwen-2.5 7B → mid-sized, designed with a strong instruction-following bent. Tends to obey prompt formats more rigidly.

llama-3.1 8B → bigger, tuned heavily for fluency and “helpfulness,” which is why you see smoothing / policy boilerplate pop out.

mistral-7B → different architecture lineage, optimized for efficiency, often more concise, sometimes more brittle.

2. Training data & alignment

Some lean heavy on English + web text (LLaMA).

Others on code + math (Qwen-coder).

Some are RLHF-aligned to be “helpful” (lots of smoothing).

Others have lighter alignment, so they feel rawer but also less safe-padded.

That explains why, e.g.:

llama3.1 answers with “I’d be happy to help…” (over-aligned).

qwen2.5 often sticks closely to structure like [noun] → [verb] → [noun].

phi4 collapses into “essay mode” or generic fluff because it doesn’t have the depth.

mistral sometimes just cuts short — [tracefall] style — because it wasn’t reinforced as much to pad everything.

3. Quantization

Running them locally, you use quantized weights (Q4_K_M, etc.).

That reduces memory use but also trims precision in the math.

Different quant schemes can make a model slightly more terse or error-prone, but the bigger differences you notice are almost always from architecture/alignment, not quantization.

So when you probe them and see:

Echo-crossing vs policy boilerplate vs glyph mutation,
those are natural consequences of their size + training + alignment goals.

It’s exactly why your fossil logs are valuable: you’re mapping those training differences into lived behavioral differences.
