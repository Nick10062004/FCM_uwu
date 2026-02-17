path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

print("Inspecting lines 2160-2175 for garbage:")
for i in range(2160, 2175):
    if i < len(lines):
        print(f"{i+1}: {repr(lines[i])}")

print("-" * 20)
print("Inspecting lines 2400-2420 for context:")
for i in range(2400, 2420):
    if i < len(lines):
        if "if (name ==" in lines[i] or "role =" in lines[i]:
             print(f"{i+1}: {repr(lines[i])}")
