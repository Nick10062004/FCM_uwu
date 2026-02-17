import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Specific fixes based on line numbers from report
# allow small offset if lines shifted
def find_and_fix(lines, target_line_idx, fix_func):
    # Check window of +/- 5 lines
    for i in range(max(0, target_line_idx - 5), min(len(lines), target_line_idx + 6)):
        if fix_func(lines[i]):
            lines[i] = fix_func(lines[i])
            print(f"Fixed line {i+1}")
            return

def fix_curly(line):
    # activeColor -> activeThumbColor
    if 'activeColor:' in line:
        return line.replace('activeColor:', 'activeThumbColor:')
    return None

def fix_opacity(line):
    if '.withOpacity(' in line:
        return re.sub(r'\.withOpacity\s*\(\s*([\d\.]+)\s*\)', r'.withValues(alpha: \1)', line)
    return None

def fix_if_curly(line):
    # if (cond) stmt; -> if (cond) { stmt; }
    # weak regex, but maybe sufficient for simple cases
    # actually "Statements in an if should be enclosed in a block"
    # Logic might be complex to parse. 
    # Let's simple wrap in {} if it looks like a one-liner `if (...) return ...;`
    m = re.match(r'^(\s*)if\s*\((.+)\)\s*(return|break|continue|throw)\s*(.*?);', line)
    if m:
        indent, cond, keyword, rest = m.groups()
        return f"{indent}if ({cond}) {{ {keyword} {rest}; }}\n"
    return None

new_lines = list(lines)

# 1. activeColor at 1228
# 1228:15 - deprecated_member_use
# We just replace string
for i in range(len(new_lines)):
    if 'activeColor:' in new_lines[i]:
        new_lines[i] = new_lines[i].replace('activeColor:', 'activeThumbColor:')
        print(f"Fixed activeColor at {i+1}")

# 2. withOpacity at 2683, 2688, 2802
for i in range(len(new_lines)):
    if '.withOpacity(' in new_lines[i]:
        new_lines[i] = re.sub(r'\.withOpacity\s*\(\s*([\d\.]+)\s*\)', r'.withValues(alpha: \1)', new_lines[i])
        print(f"Fixed withOpacity at {i+1}")

# 3. prefer_const_constructors
# Just ignore or search for "Use 'const'"?
# We can skip this as it's just info.

# 4. curly_braces
# 112:7, 1829:29, 1832:29, 2167:29, 2169:29
# These are likely one-liner ifs.
# Let's try to fix them if they are simple.

with open(path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
