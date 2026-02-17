import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

try:
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
except Exception as e:
    print(f"Error reading file: {e}")
    exit(1)

print(f"Scanning {len(lines)} lines...")

found_issues = 0
for i, line in enumerate(lines):
    # Check for the known correct string
    if "สิ่งที่แจ้งซ่อมวันนี้" in line:
        print(f"Line {i+1}: Found CORRECT string 'สิ่งที่แจ้งซ่อมวันนี้'")

    # Find non-ascii
    non_ascii = [c for c in line if ord(c) > 127]
    if not non_ascii:
        continue
        
    # Check if mostly Thai
    thai_chars = [c for c in non_ascii if 0x0E00 <= ord(c) <= 0x0E7F]
    other_chars = [c for c in non_ascii if not (0x0E00 <= ord(c) <= 0x0E7F) and ord(c) != 0xA0 and ord(c) != 0x200B] 
    # Ignore nbsp (0xA0) and zero-width space (0x200B) which are common harmless
    
    if other_chars:
        found_issues += 1
        print(f"Line {i+1}: Found {len(other_chars)} suspicious chars: {repr(''.join(other_chars))}")
        print(f"Content: {line.strip()[:100]}...")
        if thai_chars:
             print(f"  (Also contains {len(thai_chars)} Thai chars)")
        print("-" * 20)

print(f"Scan complete. Found {found_issues} potential issues.")
