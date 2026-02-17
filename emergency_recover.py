path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

print("Reading file...")
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

print(f"Original size: {len(content)} chars")

# The corruption string
noise = "บัญชีผู้ใช้"

# Remove it
fixed_content = content.replace(noise, "")

print(f"Fixed size: {len(fixed_content)} chars")

with open(path, 'w', encoding='utf-8') as f:
    f.write(fixed_content)

print("File repaired.")
