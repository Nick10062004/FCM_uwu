import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Fix deprecated withOpacity
# Pattern: .withOpacity(0.5) -> .withValues(alpha: 0.5)
# Regex to capture: \.withOpacity\s*\(\s*([\d\.]+)\s*\)
fixed_text = re.sub(r'\.withOpacity\s*\(\s*([\d\.]+)\s*\)', r'.withValues(alpha: \1)', text)

# 2. Fix replacement characters (U+FFFD)
# These are likely from the 3rd byte of Thai characters that failed decoding.
# Since we can't easily guess what they were, we should probably remove them 
# or replace them with something valid if they break syntax.
# Most are likely inside strings. if so, removing them might be okay or leaving them as ? is visible.
# But 1500 of them suggests a lot of text is damaged.
# However, the user said "It looks cut off", which suggests UI renders.
# If these chars are in comments or strings, it compiles.
# If in code, it fails.
# Given `flutter analyze` only showed deprecation warnings and "statements in if should be block",
# it implies the syntax is largely valid.
# So I will just check if any \ufffd is outside a string? Hard to tell with regex.
# For now, let's just replace them with a placeholder like '?' to be safe, or empty string.
# Actually, let's keep them for now, but focus on the compilation warnings.

print(f"Fixed withOpacity instances.")

with open(path, 'w', encoding='utf-8') as f:
    f.write(fixed_text)
