import os
import codecs

report_path = r'd:\FCM\analysis_report_final.txt'

if not os.path.exists(report_path):
    print("Report final not found. Waiting/checking...")
    exit(1)

content = ""
try:
    with codecs.open(report_path, 'r', 'utf-8-sig', errors='ignore') as f:
        content = f.read()
except Exception as e:
    print(f"Error reading report: {e}")
    exit(1)

print(f"Total Lines: {len(content.splitlines())}")
# Print first 50 lines
lines = content.splitlines()
for i in range(min(50, len(lines))):
    print(lines[i])

print("-" * 20)
# Print last 20 lines
for i in range(max(0, len(lines)-20), len(lines)):
    print(lines[i])
