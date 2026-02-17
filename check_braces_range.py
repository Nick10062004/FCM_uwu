path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

depth = 0
found_class = False

# Fast forward to 1150
for i in range(1150):
    for char in lines[i]:
        if char == '{':
            depth += 1
            if 'class _LegalDashboardScreenState' in lines[i]:
                found_class = True
        elif char == '}':
            depth -= 1

print(f"Depth at 1150: {depth}")

for i in range(1150, 1250):
    line = lines[i].strip()
    for char in lines[i]:
        if char == '{':
            depth += 1
        elif char == '}':
            depth -= 1
    
    print(f"{i+1} ({depth}): {line}")
    if depth == 0 and found_class:
        print("HIT ZERO DEPTH!")
        break
