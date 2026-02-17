import os
import codecs

report_path = r'd:\FCM\analysis_report_v2.txt'

if not os.path.exists(report_path):
    print("Report v2 not found. Waiting/checking...")
    exit(1)

content = ""
try:
    with codecs.open(report_path, 'r', 'utf-16') as f:
        content = f.read()
except:
    try:
        with open(report_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading report: {e}")

lines = content.splitlines()
errors = [l for l in lines if "error" in l.lower() or "info" in l.lower()]

print(f"Total Lines: {len(lines)}")
print(f"Issues Found: {len(errors)}")
for e in errors:
    print(e.strip())
