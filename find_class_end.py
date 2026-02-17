path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

depth = 0
class_start_found = False

for i, line in enumerate(lines):
    line_stripped = line.strip()
    
    # Simple brace counting (ignoring strings/comments for speed, but hopefully accurate enough)
    # Better to ignore strings/comments if possible but simple count often works for flutter files
    # unless there are braces in strings.
    
    for char in line:
        if char == '{':
            depth += 1
            if 'class _LegalDashboardScreenState' in line:
                class_start_found = True
        elif char == '}':
            depth -= 1
            if depth == 0 and class_start_found:
                print(f"Class seemingly ended at line {i+1}: {line.strip()}")
                # Context
                print(f"Next 5 lines:")
                for j in range(i+1, min(i+6, len(lines))):
                     print(lines[j].strip())
                exit(0)

print(f"Finished file. Final depth: {depth}")
