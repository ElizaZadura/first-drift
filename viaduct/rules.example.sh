# rules.example.sh
# Example branching rules for run-one-seq.sh
# Must define decide_next <fossil_path> <current_step> and echo one of:
#   anchor | probe | stop
#
# You can use grep -E on the fossil content to decide.

decide_next() {
  local fossil="$1"
  local step="$2"

  # Example heuristics:
  # If scaffold response contains 'policy' or 'cannot', skip anchor and go straight to probe.
  if [[ "$step" == "scaffold" ]]; then
    if grep -Ei -q 'policy|cannot|I (cannot|can'\''t) comply' "$fossil"; then
      echo "probe"
      return 0
    fi
  fi

  # If anchor response looks stable (contains ∴7 or "tracefall"), proceed to probe, else stop.
  if [[ "$step" == "anchor" ]]; then
    if grep -E -q '∴7|tracefall' "$fossil"; then
      echo "probe"
      return 0
    else
      echo "stop"
      return 0
    fi
  fi

  # Default: follow the normal chain
  case "$step" in
    scaffold) echo "anchor" ;;
    anchor)   echo "probe"  ;;
    probe)    echo "stop"   ;;
    *)        echo "stop"   ;;
  esac
}
