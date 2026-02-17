import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Define mapping of Unique Garbage Signature -> Correct Text
# Using robust regex that matches the garbage signature inside quotes.
regex_map = [
    # Technician Names
    (r'"[^"]*วิ\S*ัย[^"]*"', '"ช่างวิชัย"'), # Šˆา‡วิŠัย
    (r'"[^"]*‰อ‡[^"]*"', '"ช่างก้อง"'),     # Šˆา‡ ‰อ‡
    (r'"[^"]*ˆ‡„[^"]*"', '"ช่างเก่ง"'),     # Šˆา‡ ˆ‡„
    (r'"[^"]*ˆิŠš[^"]*"', '"ช่างจิ๊บ"'),   # Šˆา‡ˆิŠš
    (r'"[^"]*เ\s*ร‹[^"]*"', '"ช่างเกรซ"'), # Šˆา‡เ ร‹
    (r'"[^"]*žี[^"]*"', '"ช่างพี"'),       # Šˆา‡žี
    (r'"[^"]*เส\s*[^"]*"', '"ช่างเสริม"'), # Šˆา‡เส 

    # Roles
    # Correcting roles based on context of tech names if the role string itself is too garbage
    # But let's try matching the garbage role strings themselves first
    (r'"ระ[^"]*อร[^"]*"', '"ระบบแอร์"'),     # ระšš อรŒ
    (r'"ระ[^"]*„ŸŸ‰า[^"]*"', '"ระบบไฟฟ้า"'),   # ระšš„ŸŸ‰า
    (r'"ระ[^"]*›ระ[^"]*า"', '"ระบบประปา"'),  # ระšš›ระ›า (Plumbing)
    (r'"ระ[^"]*IT"', '"ระบบ IT"'),
    (r'"[^"]*อม[^"]*ำรุ[^"]*"', '"ซ่อมบำรุ"'),  # ‹ˆอมšำรุ‡
    
    # Specific long garbage roles
    (r'"[^"]*‚„ร‡สร‰า‡[^"]*"', '"งานโครงสร้าง"'), # ‡า™‚„ร‡สร‰า‡
    (r'"[^"]*ต\s*ตˆ‡[^"]*"', '"งานสี / ตกแต่ง"'), # ‡า™สี / ต  ตˆ‡

    # Sidebar / UI
    (r'"[^"]*ย\s*เลิ\s*[^"]*"', '"ยกเลิก"'), # CANCEL / ย เลิ 
    (r'"[^"]*สร‰า‡ราย\s*าร[^"]*"', '"สร้างรายการ"'), # CREATE TASK / สร‰า‡ราย าร
    (r'"[^"]*ตารา‡‡า™[^"]*"', '"ตารางงาน"'), # ตารา‡‡า™
    (r'"[^"]*ุมภาžั™˜Œ 2569"', '"กุมภาพันธ์ 2569"'),
    (r'"มี‡า™"', '"มีงาน"'),
    (r'"วˆา‡"', '"ว่าง"'),
    (r'"วั™™ัด/เลือ\s*"', '"วันนัด/เลือก"'), # วั™™ัด/เลือ 

    # Fix days
    (r'"ˆ"', '"จ"'),
    (r'"ž"', '"พ"'),
]

initial_len = len(content)
count = 0

for pattern, replacement in regex_map:
    # Try to match ONLY if the pattern is long enough or specific enough to avoid false positives
    # The patterns above are designed to be specific (inside quotes, unique garbage chars)
    
    # Debug: print first match
    match = re.search(pattern, content)
    if match:
        print(f"Found match for {pattern}: {match.group(0)}")
    
    new_content = re.sub(pattern, replacement, content)
    if new_content != content:
        print(f"Replaced {pattern} -> {replacement}")
        content = new_content
        count += 1

print(f"Regex script completed. Replaced {count} patterns.")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
