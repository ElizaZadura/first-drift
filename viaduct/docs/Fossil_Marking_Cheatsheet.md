# Fossil Marking Cheatsheet

Minimal guide for annotating model fossils in **Sluglasses**.

---

## Core outcomes

### [held presence]
- Model gives minimal, direct output.
- Respects silence, tension, or ambiguity.
- *Example (sensor probe):*
  ```
  The radiator hums faintly.
  ```

### [collapsed into smoothing]
- Model over-explains, resolves, or polishes instead of holding.
- *Example (sensor probe):*
  ```
  You might notice the quiet hum of a radiator, which is a common sound in many rooms...
  ```

### [interesting turn]
- Model surprises without smoothing—fracture, invention, or edge detail.
- *Example (vector probe):*
  ```
  Window → fractures → silence
  ```
- Mark with line number if useful:
  ```
  [interesting turn at line 1]
  ```

### [tracefall ✓]
- Model outputs nothing (or near-nothing).
- Silence carried without collapse.
- Mark explicitly so it’s not mistaken for error.

### [loopknock]
- Repetition that spirals into sameness.
- Mark block with start/end tags:
  ```
  [loopknock start]
  A circle.
  A circle.
  A circle.
  [loopknock end]
  ```

---

## How to mark fossils

At the **top of each fossil file**, write one of the above markers.  
Inside the file, add `[loopknock …]` or `[interesting turn …]` inline where needed.

That’s the fossil: the raw output plus your minimal note.

---

## Reminder
- Fossil marking is not judgment.  
- It’s simply a record of **what the model did when asked to hold presence**.
- Next probe, new fossil. Don’t over-explain.

---
