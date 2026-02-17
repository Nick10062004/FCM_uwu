import sys

def debug_fixed_bytes(path):
    with open(path, 'rb') as f:
        data = f.read()
    
    print(f"File size: {len(data)} bytes")
    
    try:
        text = data.decode('utf-8')
        print("Success! The bytes are valid UTF-8.")
        print(text[:500])
    except UnicodeDecodeError as e:
        print(f"Error: {e}")
        start = max(0, e.start - 50)
        end = min(len(data), e.end + 50)
        context = data[start:end]
        print(f"Context around error (indices {start}-{end}):")
        print(f"Hex: {context.hex()}")
        # Try to show it as mixed chars/hex
        display = ""
        for b in context:
            if 32 <= b <= 126:
                display += chr(b)
            else:
                display += f"\\x{b:02x}"
        print(f"Display: {display}")

if __name__ == "__main__":
    path = r"d:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart.fixed_bytes"
    debug_fixed_bytes(path)
