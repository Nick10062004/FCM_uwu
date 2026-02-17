import os

file_path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
for i in range(len(lines)):
    # If the line is empty and the previous line was also effectively empty (or just whitespace)
    # We want to keep at most one empty line between blocks.
    if lines[i].strip() == '' and (i > 0 and lines[i-1].strip() == ''):
        continue
    new_lines.append(lines[i])

with open(file_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

print(f"Cleaned {len(lines)} lines down to {len(new_lines)} lines.")
