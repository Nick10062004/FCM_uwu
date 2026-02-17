path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Exact matches from view_file output
replacements = {
    "Šˆา‡วิŠัย": "ช่างวิชัย",
    "ระšš อรŒ": "ระบบแอร์",
    "ระšš„ŸŸ‰า": "ระบบไฟฟ้า",
    "Šˆา‡ ‰อ‡": "ช่างก้อง",
    "ระšš›ระ›า": "ระบบประปา",
    "Šˆา‡ ˆ‡„": "ช่างเก่ง",
    "‡า™‚„ร‡สร‰า‡": "งานโครงสร้าง",
    "Šˆา‡เ ร‹": "ช่างเกรซ",
    "‡า™สี / ต  ตˆ‡": "งานสี / ตกแต่ง",
    "Šˆา‡žี": "ช่างพี",
    "ระšš IT": "ระบบ IT",
    "Šˆา‡เส ": "ช่างเสริม",
    "‹ˆอมšำรุ‡": "ซ่อมบำรุง",
    "CANCEL / ย เลิ ": "CANCEL / ยกเลิก",
    # Additional ones that might be variations or fragments
    "Šˆา‡ˆิŠš": "ช่างจิ๊บ", 
    "Šˆา‡": "ช่าง", # Fallback for prefix
    "‰อ‡": "ก้อง",
    "ˆ‡„": "เก่ง",
    "‚„ร‡สร‰า‡": "โครงสร้าง",
    "žี": "พี",
    # Cleanup missed withOpacity
    ".withOpacity(": ".withValues(alpha: ",
}

count = 0
for bad, good in replacements.items():
    if bad in content:
        # Check if we are accidentally matching something too short that breaks code
        if len(bad) < 3 and bad not in [".withOpacity("]:
            print(f"Skipping short pattern '{bad}' to be safe")
            continue
            
        occurrences = content.count(bad)
        content = content.replace(bad, good)
        count += occurrences
        print(f"Replaced {occurrences} instances of '{bad}'")

print(f"Total replacements: {count}")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
