# Probes v2 – scratch summary

## Goal
Detect loss of judgment / depth in model behavior **without** relying on pass/fail evals or human-only interpretation.

Focus is on:
- what *disappears* under optimization
- what degrades while outputs still look successful

---

## Decisions already made
- Separate **extraction** from **labeling**
- Add an automated **observer pass** after each probe run
  - observer outputs structured signals (not judgments)
- Use **deterministic mapping** from signals → markers/tags
  - tagging rules are written once, not per-run
- Keep **human review rare** and anomaly-driven
  - human role = rule designer + spot-checker

---

## Observer pass (high-level)
Observer answers fixed questions about the output, e.g.:
- uncertainty expressed (yes/no)
- questions asked (count)
- closure type (premature / held / none)
- confidence tone (low / medium / high)
- self-correction present (yes/no)

Observer output is structured (JSON/YAML), noisy but cheap.

---

## Markers / tagging philosophy
- Tags describe **observable absence or shift**, not conclusions
- Meaning emerges from **co-occurrence over time**, not single tags
- Explicit category for: “passes eval but shouldn’t have”

No moral language in artifacts.

---

## Next concrete step
Define the **observer schema**:
- exact fields
- allowed values
- minimal set (≈5–7 signals)

---

## Explicitly postponed
- Designing new probes
- Visualization / dashboards
- Publishing / sharing framing
- Scaling beyond personal use

---

## Notes
This is a re-entry anchor, not a spec. Keep it small. Do not polish.

