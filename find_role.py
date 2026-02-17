path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'
try:
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    for i, line in enumerate(lines):
        if "String role =" in line:
            print(f"Line {i+1}: {line.strip()}")
            # Print context
            for j in range(i+1, min(i+10, len(lines))):
                 print(f"Line {j+1}: {lines[j].strip()}")
except Exception as e:
    print(e)
