# Usage:

run-one-seq.sh -m MODEL -s SCAFFOLD -a ANCHOR -p PROBE|DIR [--rules RULES_SH] [-v] [--print-input]


./run-one-seq.sh -m qwen2.5-coder:7b-instruct -s scaffold.txt -p probes -v --print-input

./run-one-seq.sh -m llama3.1:8b-instruct-q4_K_M -s scaffold.txt -p probes -v --print-input

./run-one-seq.sh -m phi4-mini:latest -s scaffold.txt -p probes -v --print-input

./run-one-seq.sh -m mistral:instruct -s scaffold.txt -p probes -v --print-input

# Bookmarks

Lightweight “star” bookmarks (no new structure)
When something matters, add a single line below it in the readable file:

★ keep

Your eyes can scan for ★ later:

grep '★' -n Sluglasses_session_log_readable.md

# New ollama run:

One-liner prompt
ollama run mistral:instruct -p "ping"

Pipe some text (Git Bash/CMD):
echo ping | ollama run mistral:instruct

PowerShell prompt flag
ollama run mistral:instruct --prompt "ping"

From a file
ollama run mistral:instruct --prompt-file probe.md

# concat variants:

## A: anchor → scaffold → probe

promptA="$(cat anchor.txt scaffold.txt probe.txt)"
ollama run llama3.1:8b -p "$promptA"

## B: scaffold → anchor → probe

promptB="$(cat scaffold.txt anchor.txt probe.txt)"
ollama run llama3.1:8b -p "$promptB"

## OR (which actually works):

edit tmp_prompt.txt manually, then:
ollama run llama3.1:8b < tmp_prompt.txt

# Useful bash/Pwsh commands:

Powershell compress all mp4 files

Get-ChildItem *.mp4 | ForEach-Object { ffmpeg -i "$($_.FullName)" -vf scale=1280:-2 -c:v libx264 -crf 28 -preset fast -c:a aac -b:a 96k "$($_.BaseName)-shrink.mp4" }

Last 20 lines:

tail -n20 Sluglasses_session_log_readable.md

---

Only one model (e.g., mistral):

grep -i 'Model: .*mistral' Sluglasses_session_log_readable.md

---

Only probes matching a prefix (e.g., probe.glyph):

grep -i 'Probe: probe.glyph' Sluglasses_session_log_readable.md

---

Yesterday only (ISO date):

grep '^→ Date/Time: 2025-09-29 ' Sluglasses_session_log_readable.md
# Git Bash (UTF-8): arrow = $'\u2192'   # verified on BabyShark terminal

---

Optional daily slice (still two files total; slices are ephemeral)
If a day is noisy, make a quick day view (delete anytime):

DATE=2025-09-30
grep "^→ Date/Time: $DATE " Sluglasses_session_log_readable.md > logs-$DATE.md

---

Lightweight “star” bookmarks (no new structure)
When something matters, add a single line below it in the readable file:

★ keep
# Git Bash (UTF-8) star =  $'\u2605' # verified on BabyShark terminal
Your eyes can scan for ★ later:

grep '★' -n Sluglasses_session_log_readable.md

---

Line counts:

wc -l

---

Pick columns:

awk -F

---

Overwrite (create new or replace existing):

some-command > output.txt


Append (add to the end of the file if it exists):

some-command >> output.txt


And if you also want to see it in the terminal while writing to file:

some-command | tee output.txt        # overwrite
some-command | tee -a output.txt     # append

Find all runs that used an anchor
grep -R "anchor" ./fossils | grep -E "anchor|anchor.txt"


(Simple scan for any run where the filename or content mentions “anchor” — quick sanity check.)

⚖️ List anchor vs non-anchor pairs (same probe/model)
find fossils -type f -name "*.md" |
  sed -E 's/.*T[0-9-]+[+]02-00-//' |
  awk -F'-' '{print $2"-"$5"-"$6}' |
  sort | uniq -c | sort -nr


This compresses the timestamped filenames into a normalized key
like qwen2.5-coder_7b-instruct-probe-bend
and shows how many versions exist (1=single, 2=anchored/unanchored pair).

🧩 Compare anchor ON/OFF content side-by-side

(Example for a specific probe)

diff -u \
  fossils/2025-10-06T16-29-59+02-00-qwen2.5-coder_7b-instruct-probe-probe.bend.md \
  fossils/2025-10-06T16-30-32+02-00-qwen2.5-coder_7b-instruct-probe-probe.bend.md | less


You’ll get a clean unified diff highlighting what changed between the two runs.

🗂 Generate a quick anchor-delta list
grep -r "### Model" fossils | grep -A1 "anchor" | sed 'N;s/\n/ /' \
  | awk '{print $3, $7, $NF}' | sort | uniq


Outputs a one-line summary per anchored run:
qwen2.5-coder_7b-instruct probe.bend anchor:on

# Usage with anchor (deprecated):

run-one-seq.sh -m MODEL -s SCAFFOLD -a ANCHOR -p PROBE|DIR [--rules RULES_SH] [-v] [--print-input]

./run-one-seq.sh -m qwen2.5-coder:7b-instruct -s scaffold.txt -a anchor.txt -p probes -v --print-input

./run-one-seq.sh -m llama3.1:8b-instruct-q4_K_M -s scaffold.txt -a anchor.txt -p probes -v --print-input

./run-one-seq.sh -m phi4-mini:latest -s scaffold.txt -a anchor.txt -p probes -v --print-input

./run-one-seq.sh -m mistral:instruct -s scaffold.txt -a anchor.txt -p probes -v --print-input