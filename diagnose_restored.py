import subprocess
import os
import codecs

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'
report_path = r'd:\FCM\analysis_report.txt'

# 1. Check File Stats
if not os.path.exists(path):
    print("File not found!")
    exit(1)

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()
    content = "".join(lines)

print(f"File Line Count: {len(lines)}")
print(f"File Char Count: {len(content)}")
print("-" * 20)
print("First 20 lines (Imports):")
print("".join(lines[:20]))
print("-" * 20)
print("Last 20 lines:")
print("".join(lines[-20:]))
print("-" * 20)

# 2. Check for Mojibake/Replacement chars
repl_count = content.count('\ufffd')
print(f"Replacement chars (U+FFFD) count: {repl_count}")

# 3. Check for specific known errors
if "StatefulBuilder" not in content and "import 'package:flutter/material.dart'" not in content:
    print("WARNING: Missing material import or StatefulBuilder")

# 4. Check for analysis report or run Analyze
print("Checking analysis...")
try:
    report_content = ""
    # Try reading existing report first
    if os.path.exists(report_path) and os.path.getsize(report_path) > 0:
        print("Reading existing analysis_report.txt...")
        try:
            # Powershell > redirection often uses UTF-16LE
            with codecs.open(report_path, 'r', 'utf-16') as f:
                report_content = f.read()
        except:
            try:
                with open(report_path, 'r', encoding='utf-8', errors='ignore') as f:
                    report_content = f.read()
            except Exception as e:
                print(f"Could not read report: {e}")
    
    if "error" not in report_content.lower() and "info" not in report_content.lower():
        print("Running flutter analyze fresh...")
        cmd = ["flutter", "analyze", path]
        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, shell=True)
        report_content = result.stdout

    print("Analyze Output Summary:")
    errors = [l for l in report_content.splitlines() if "error" in l.lower() or "info" in l.lower()]
    print(f"Total Log Lines: {len(report_content.splitlines())}")
    print(f"Issues Found: {len(errors)}")
    for e in errors[:10]:
        print(e.strip())
        
except Exception as e:
    print(f"Analysis check failed: {e}")
