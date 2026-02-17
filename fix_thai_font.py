import sys
import os

def fix_mojibake(input_path):
    print(f"Processing {input_path}...")
    try:
        with open(input_path, 'r', encoding='utf-8') as f:
            text = f.read()
    except UnicodeDecodeError:
        print(f"Error: Could not decode {input_path} as UTF-8. Trying to read as bytes...")
        with open(input_path, 'rb') as f:
            data = f.read()
        # If it's already bytes, maybe it's partially fixed or totally broken
        # Let's try to decode as latin1 as a fallback?
        text = data.decode('latin1')

    # Build reverse maps
    # CP874: Thai
    cp874_rev = {}
    for i in range(128, 256):
        try:
            char = bytes([i]).decode('cp874')
            cp874_rev[char] = i
        except:
            pass
            
    # CP1252: Western (for 0x80-0x9F range mostly)
    cp1252_rev = {}
    for i in range(128, 256):
        try:
            char = bytes([i]).decode('cp1252')
            cp1252_rev[char] = i
        except:
            pass

    # Priority mapping
    # Most corrupted sequences start with e0 b8 or e0 b9
    # e0 -> เ (CP874)
    # b8 -> ธ (CP874)
    # b9 -> น (CP874)
    # Special chars like Š, ˆ, — come from CP1252
    
    output_bytes = bytearray()
    unknown_chars = set()
    
    for char in text:
        cp = ord(char)
        if cp < 128:
            output_bytes.append(cp)
        elif char in cp874_rev:
            # Prioritize CP874 because the mojibake is mostly Thai chars
            output_bytes.append(cp874_rev[char])
        elif char in cp1252_rev:
            output_bytes.append(cp1252_rev[char])
        else:
            # Chars like U+2014 (—) or U+201C (“) which might be in CP1252 but not CP874
            # let's try direct encoding or manual mapping if known
            unknown_chars.add(f"{char} (U+{cp:04X})")
            output_bytes.extend(char.encode('utf-8'))

    if unknown_chars:
        print(f"Found {len(unknown_chars)} chars outside 8bit range: {list(unknown_chars)[:10]}...")

    try:
        fixed_text = output_bytes.decode('utf-8')
        with open(input_path, 'w', encoding='utf-8', newline='') as f:
            f.write(fixed_text)
        print(f"Successfully fixed {input_path}")
    except UnicodeDecodeError as e:
        print(f"Error Decoding Fixed Bytes in {input_path}: {e}")
        # Save as .fixed as emergency backup
        backup_path = input_path + ".fixed_bytes"
        with open(backup_path, 'wb') as f:
            f.write(output_bytes)
        print(f"Saved raw fixed bytes to {backup_path} for manual inspection.")

if __name__ == "__main__":
    target_file = r"d:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart"
    if os.path.exists(target_file):
        fix_mojibake(target_file)
    else:
        print(f"File not found: {target_file}")
