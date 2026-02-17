path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if '"ภาษา„ทย (THAI)"ช่างวิชัย"ช่างเสริม"' in line or 'ภาษา„ทย (THAI)' in line:
        print(f"Found bad line at {i+1}: {line.strip()}")
        # Check indentation
        indent = line[:line.find('_settingsRow')]
        # Replace strictly
        lines[i] = indent + '_settingsRow("LANGUAGE", "ภาษาไทย (THAI)", false),\n'
        print(f"Replaced with: {lines[i].strip()}")
        break

with open(path, 'w', encoding='utf-8') as f:
    f.writelines(lines)
