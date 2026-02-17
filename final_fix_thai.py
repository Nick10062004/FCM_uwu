import sys
import os

def final_fix(path):
    print(f"Applying final fix to {path}...")
    
    # 1. Build the character-to-byte map
    # We need to cover all possible ways a byte was turned into a character
    char_to_byte = {}
    
    # ASCII
    for i in range(128):
        char_to_byte[chr(i)] = i
        
    # CP874 (Thai) - High priority as most mojibake is Thai
    for i in range(128, 256):
        try:
            c = bytes([i]).decode('cp874')
            char_to_byte[c] = i
        except: pass
        
    # Windows-1252 (Western) - For those 0x80-0x9F chars
    for i in range(128, 256):
        try:
            c = bytes([i]).decode('cp1252')
            if c not in char_to_byte:
                char_to_byte[c] = i
        except: pass
        
    # Latin-1 (ISO-8859-1) - Fallback for everything else
    for i in range(128, 256):
        try:
            c = bytes([i]).decode('latin1')
            if c not in char_to_byte:
                char_to_byte[c] = i
        except: pass

    # 2. Read the file
    try:
        with open(path, 'r', encoding='utf-8') as f:
            text = f.read()
    except UnicodeDecodeError:
        print("UTF-8 read failed, trying latin1 as raw source...")
        with open(path, 'r', encoding='latin1') as f:
            text = f.read()

    # 3. Convert characters back to bytes
    output_bytes = bytearray()
    unmapped = []
    
    for char in text:
        if char in char_to_byte:
            output_bytes.append(char_to_byte[char])
        else:
            # This shouldn't happen for 8-bit encodings, but just in case
            # (e.g. if a 'real' 2-byte char was already in the file)
            unmapped.append(char)
            output_bytes.extend(char.encode('utf-8'))
            
    if unmapped:
        print(f"Warning: {len(unmapped)} characters were not in the 8-bit maps. Examples: {unmapped[:5]}")

    # 4. Decode as UTF-8
    try:
        fixed_text = output_bytes.decode('utf-8')
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write(fixed_text)
        print(f"SUCCESS: {path} has been restored.")
        
        # Verification
        for word in ["ช่าง", "ทั้งหมด", "เมนู", "Dashboard"]:
            if word in fixed_text:
                print(f"Found restored word: '{word}'")
    except UnicodeDecodeError as e:
        print(f"CRITICAL ERROR: Restored bytes are not valid UTF-8: {e}")
        # Save bytes just in case
        with open(path + ".failed_bytes", 'wb') as f:
            f.write(output_bytes)

if __name__ == "__main__":
    path = r"d:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart"
    final_fix(path)
