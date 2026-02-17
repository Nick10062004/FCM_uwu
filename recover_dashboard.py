import sys
import os
import re

def recover_file(backup_path, target_path):
    print(f"Recovering from {backup_path}...")
    
    if not os.path.exists(backup_path):
        print("Backup file not found!")
        return

    with open(backup_path, 'rb') as f:
        data = f.read()
    
    # 1. Fix known invalid byte sequences if possible
    # Step 5026 showed error at 5484: invalid continuation byte
    # We'll replace invalid sequences with a placeholder or try to salvage
    
    # Simple strategy: decode with 'replace' to get a working string first
    text = data.decode('utf-8', errors='replace')
    
    # 2. Fix Double Newlines 
    # The file has \n\n (0x0A 0x0A) or \r\n\r\n
    # We want to reduce multiple newlines to single newlines, 
    # BUT we must be careful not to merge code that relies on spacing (unlikely in Dart)
    # Safe approach: Replace 3 or more newlines with 2, and 2 with 1?
    # Actually, if EVERYTHING is double spaced, we can replace \n\n with \n.
    
    # Let's inspect the first few chars
    print(f"Start of text: {repr(text[:50])}")
    
    # Python's universal newlines might hide \r. 
    # Let's try to just replace generic multiple newlines with single
    clean_text = re.sub(r'(\r?\n){2,}', '\n', text)
    
    print(f"Recovered size: {len(clean_text)} chars")
    
    with open(target_path, 'w', encoding='utf-8') as f:
        f.write(clean_text)
    
    print(f"Wrote recovered content to {target_path}")

if __name__ == "__main__":
    backup = r"d:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart.fixed_bytes"
    target = r"d:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart"
    recover_file(backup, target)
