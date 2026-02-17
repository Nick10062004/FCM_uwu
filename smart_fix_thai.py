import sys
import os

def smart_fix(path):
    print(f"Smart-fixing {path}...")
    try:
        with open(path, 'r', encoding='utf-8') as f:
            text = f.read()
    except Exception as e:
        print(f"Failed to read file: {e}")
        return

    # Map for the 3rd byte (after เธ or เน)
    # Most 3rd bytes are in the range 0x80-0xBF or Thai range.
    byte_map = {}
    for i in range(256):
        # We try CP1252 and Latin1 to find which character maps to this byte
        try:
            c = bytes([i]).decode('cp1252')
            byte_map[c] = i
        except: pass
        try:
            c = bytes([i]).decode('latin1')
            if c not in byte_map: byte_map[c] = i
        except: pass
    
    # Add common Thai chars as fallback mappings (just in case they were used as the 3rd byte)
    # though usually 3rd byte is 128-191.
    for i in range(128, 256):
        try:
            c = bytes([i]).decode('cp874')
            if c not in byte_map: byte_map[c] = i
        except: pass

    output_bytes = bytearray()
    i = 0
    total_fixed = 0
    
    while i < len(text):
        found_mojibake = False
        if i + 2 < len(text):
            prefix = text[i:i+2]
            if prefix == 'เธ' or prefix == 'เน':
                found_mojibake = True
                # Start of 3rd byte sequence
                b1 = 0xE0
                b2 = 0xB8 if prefix == 'เธ' else 0xB9
                next_char = text[i+2]
                
                if next_char in byte_map:
                    output_bytes.append(b1)
                    output_bytes.append(b2)
                    output_bytes.append(byte_map[next_char])
                    total_fixed += 1
                    i += 3
                else:
                    # Not in map? Keep it as is but it might break utf8
                    output_bytes.extend(text[i:i+2].encode('utf-8'))
                    i += 2
            
        if not found_mojibake:
            output_bytes.extend(text[i].encode('utf-8'))
            i += 1

    try:
        fixed_text = output_bytes.decode('utf-8')
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write(fixed_text)
        print(f"SUCCESS: Fixed {total_fixed} mojibake sequences.")
    except UnicodeDecodeError as e:
        print(f"ERROR: Restored text is not valid UTF-8 at position {e.start}: {e}")
        # Save bytes as fallback
        with open(path + ".smart_failed", 'wb') as f:
            f.write(output_bytes)

if __name__ == "__main__":
    path = r"d:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart"
    smart_fix(path)
