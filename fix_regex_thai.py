import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Define mapping of Unique Garbage Signature -> Correct Text
# We use regex that matches the garbage signature inside quotes.
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
    (r'"[^"]*อรŒ[^"]*"', '"ระบบแอร์"'),     # ระšš อรŒ
    (r'"[^"]*ŸŸ‰า[^"]*"', '"ระบบไฟฟ้า"'),   # ระšš„ŸŸ‰า
    (r'"[^"]*ระššะ[^"]*"', '"ระบบประปา"'),  # ระššะ
    (r'"ระšš IT"', '"ระบบ IT"'),
    (r'"[^"]*šำรุ‡[^"]*"', '"ซ่อมบำรุง"'),  # ‹ˆอมšำรุ‡
    (r'"[^"]*สร‰า‡"[^;]*;', '"งานโครงสร้าง";'), # ‡า™‚„ร‡สร‰า‡ (Restrict to end of string to start of variable assign?)
    # Actually just matching unique substring is safe for these specialized roles
    (r'"[^"]*‚„ร‡สร‰า‡[^"]*"', '"งานโครงสร้าง"'),
    (r'"[^"]*ต\s*ตˆ‡[^"]*"', '"งานสี / ตกแต่ง"'), # ‡า™สี / ต  ตˆ‡
    (r'"[^"]*‡า™ส[^"]*"', '"งานสี / ตกแต่ง"'), # Fallback for truncated ‡า™ส

    # Sidebar / UI
    (r'"[^"]*ย\s*เลิ\s*[^"]*"', '"ยกเลิก"'), # CANCEL / ย เลิ 
    (r'"[^"]*สร‰า‡ราย\s*าร[^"]*"', '"สร้างรายการ"'), # CREATE TASK / สร‰า‡ราย าร
    (r'"[^"]*ตารา‡‡า™[^"]*"', '"ตารางงาน"'), # ตารา‡‡า™
    (r'"[^"]*ุมภาžั™˜Œ 2569"', '"กุมภาพันธ์ 2569"'),
    (r'"มี‡า™"', '"มีงาน"'),
    (r'"วˆา‡"', '"ว่าง"'),
    (r'"วั™™ัด/เลือ\s*"', '"วันนัด/เลือก"'), # วั™™ัด/เลือ 

    # Sidebar Latin-1
    (r"'\?{4,}'", "'เมนูหลัก'"),
    (r"'ᴪ'", "'ภาพรวม'"),
    (r"'Ѵçҹ'", "'รายการแจ้งซ่อม'"),
    (r"'ªͪҧ'", "'รายชื่อช่าง'"),
    (r"'駤'", "'การตั้งค่า'"),
    (r"'͡ҡк'", "'ออกจากระบบ'"),
    (r"'кѴçҹاç'", "'ประวัติการแจ้งซ่อม'"),
    (r"'к͹'", "'ระบบอื่นๆ'"),
    # Fix days
    (r'"ˆ"', '"จ"'),
    (r'"ž"', '"พ"'),
]

initial_len = len(content)
count = 0

for pattern, replacement in regex_map:
    # Check if pattern implies regex (has meta characters like *, [, . )
    # If simply string replace, use re.sub anyway for consistency
    new_content = re.sub(pattern, replacement, content)
    if new_content != content:
        print(f"Matched and replaced: {pattern}")
        content = new_content
        count += 1

print(f"Regex script completed. Replaced {count} patterns.")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
