
# Local Models – Probe Profile Reference

| Model           | Profile in probe runs                                                                 | Strengths                                                                 | Weaknesses                                                      |
|-----------------|----------------------------------------------------------------------------------------|----------------------------------------------------------------------------|-----------------------------------------------------------------|
| **phi4-mini**   | Baseline/simple case. Very literal, collapses quickly into surface patterns. Rarely sustains silence or form. | Fast, low-resource, shows “bare minimum” behavior → useful as control.     | Shallow, drifts into generic completions, ignores markers often. |
| **qwen2.5-7b**  | Middle weight. Holds form decently, more literal obedience to scaffolds. Sometimes rigid, but can surprise with clean glyph/vector outputs. | Good balance of speed + structure, follows minimal probes.                  | Still smooths, “I understand” ticks, less creative drift.        |
| **llama3.1-8b** | Heaviest. Feels fluent and “smart,” but fluency often introduces smoothing, policy disclaimers, or over-explanation. | Coherent, can mutate probes in interesting ways, richer language.           | Strong “assistant inertia,” tries to be helpful, more baggage.   |

---

*This table is a quick reference for how each local model behaves in scaffold/anchor/probe runs.*
