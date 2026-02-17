import sys

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'rb') as f:
    raw = f.read()

# Strip BOM
if raw[:3] == b'\xef\xbb\xbf':
    raw = raw[3:]

text = raw.decode('utf-8')

# Find the first "label:" and examine what follows
idx_label = text.find('label: "')
if idx_label >= 0:
    # The text after label: " should be Thai
    # Expected: "ทั้งหมด" = U+0E17 U+0E31 U+0E49 U+0E07 U+0E2B U+0E21 U+0E14
    start = idx_label + 8  # skip 'label: "'
    sample = text[start:start+30]
    print(f"Text sample after first label: [{sample}]")
    print(f"Chars:")
    for j, ch in enumerate(sample):
        if ch == '"':
            break
        print(f"  [{j}] U+{ord(ch):04X} = {ch} ({repr(ch)})")

    # Get the raw bytes for this section
    byte_offset = len(text[:start].encode('utf-8'))
    raw_bytes = raw[byte_offset:byte_offset+100]
    print(f"\nRaw bytes at this location:")
    for k in range(0, min(60, len(raw_bytes)), 3):
        three = raw_bytes[k:k+3]
        hex_str = three.hex()
        try:
            decoded = three.decode('utf-8')
            print(f"  {hex_str} -> {decoded} (U+{ord(decoded):04X})")
        except:
            print(f"  {hex_str} -> (invalid utf8)")

# Also show what "ทั้งหมด" looks like in UTF-8
print("\n\nExpected 'ทั้งหมด' bytes:")
expected = 'ทั้งหมด'
for ch in expected:
    b = ch.encode('utf-8')
    print(f"  {b.hex()} -> {ch} (U+{ord(ch):04X})")

sys.exit(0)
