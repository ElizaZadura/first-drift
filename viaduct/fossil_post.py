#!/usr/bin/env python3
import sys, re, collections, pathlib

def stems(text, stem_words=6):
    sents = re.split(r'[\n\.!?]+', text)
    for s in sents:
        words = [w for w in re.findall(r"\w[\w'-]*", s.lower())]
        if words:
            yield ' '.join(words[:stem_words])

def analyze(path):
    txt = pathlib.Path(path).read_text(encoding='utf-8', errors='ignore')
    cnt = collections.Counter(stems(txt))
    repeats = [(k, v) for k, v in cnt.items() if v >= 3]
    if repeats:
        print(f"{path}: loopknock candidates ->")
        for k, v in sorted(repeats, key=lambda x: -x[1])[:5]:
            print(f"  stem '{k}' x{v}")
    else:
        print(f"{path}: no loopknock stems found.")

if __name__ == "__main__":
    for p in sys.argv[1:]:
        analyze(p)
