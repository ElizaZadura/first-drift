(seed draft)
name: viaduct-analysis-skill
purpose: >
  A skill enabling structured comparative evaluation of LLM outputs
  through scaffolds, probes, and marker-based behavioral signatures.

capabilities:
  - run controlled prompt scaffolds
  - generate parallel model outputs
  - detect drift, smoothing, and form collapse
  - classify outputs with marker taxonomy
  - produce summaries or fossils

inputs:
  - scaffold file
  - probe file or probe directory
  - model list
  - optional: context window summary

outputs:
  - tagged fossils
  - drift/comparison report
  - behavioral markers detected

tools:
  - local_llm_runner
  - fossil_logger
  - marker_classifier
  - comparison_engine

progressive_disclosure:
  - start with single probe
  - scale to batch probes
  - add marker tags
  - compare across models
  - generate longitudinal analysis
