import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Map of context/unique-substring to Correct Text
replacements = [
    # Technician Names & Roles
    (r'"ระ.{1,10}อร.{1,2}"', '"ระบบแอร์"'), # ระ... อร... -> ระบบแอร์ (Air System)
    (r'"ระ.{1,10}ฟ.{1,5}า"', '"ระบบไฟฟ้า"'), # ระบบไฟฟ้า (Electrical)
    (r'"ระ.{1,10}ะ.{1,2}"', '"ระบบประปา"'), # ระบบประปา (Plumbing) - guessed from context of Water char? Or "ระบบสุขาภิบาล"? Let's use "ระบบประปา"
    (r'"ระ.{1,5} IT"', '"ระบบ IT"'),
    (r'"งานโครงสร.{1,5}ง"', '"งานโครงสร้าง"'), # งานโครงสร้าง
    (r'"งานสี / ตกแต่.{1,3}"', '"งานสี / ตกแต่ง"'),
    (r'"ซ.{1,5}อมบำรุ.{1,2}"', '"ซ่อมบำรุง"'), # ซ่อมบำรุง
    
    (r'"ช่างวิชัย"', '"ช่างวิชัย"'), # Already correct? Check scan. Scan said "Šˆา‡วิŠัย".
    (r'"[^"]*วิ[^"]*ัย"', '"ช่างวิชัย"'), # fallback for Wichai using 'วิ' 'ัย'
    (r'"[^"]*ก้อง"', '"ช่างก้อง"'), 
    (r'"[^"]*เก่ง"', '"ช่างเก่ง"'),
    (r'"[^"]*จิ๊บ"', '"ช่างจิ๊บ"'),
    (r'"[^"]*เกรซ"', '"ช่างเกรซ"'), # OR "ช่างเคน"? Scan was "เ ร <"
    (r'"[^"]*พี"', '"ช่างพี"'),
    (r'"[^"]*เสริม"', '"ช่างเสริม"'),

    # Harder ones (Technician names might be totally garbled)
    # Use the variable assignment context if possible, or broad regex
    # "Šˆา‡วิŠัย". 'วิ' is 'E26 E34'. 
    # Let's try to match the corrupt sequences from the scan log roughly
    
    # Sidebar items
    (r"'\?{4,}'", "'เมนูหลัก'"), # Placeholder for '????'
    (r"'[^']*ภาพรวม[^']*'", "'ภาพรวม'"),
    (r"Icons.grid_view_rounded,\s*'[^']*'", "Icons.grid_view_rounded, 'ภาพรวม'"),
    (r"Icons.assignment_outlined,\s*'[^']*'", "Icons.assignment_outlined, 'รายการแจ้งซ่อม'"),
    (r"Icons.people_outline,\s*'[^']*'", "Icons.people_outline, 'รายชื่อช่าง'"),
    (r"Icons.settings_outlined,\s*'[^']*'", "Icons.settings_outlined, 'การตั้งค่า'"),
    (r"Icons.person_outline,\s*'[^']*'", "Icons.person_outline, 'บัญชีผู้ใช้'"),
    (r"'ออกจากระบบ'", "'ออกจากระบบ'"), # Likely corrupted.
    (r"text: '[^']*ยกเลิก'", "text: 'ยกเลิก'"), # CANCEL / ยกเลิก
]

# Targeted replacements based on Scan output signatures
# We rely on unique substrings or neighboring code.

# 1. Sidebar Headers
content = re.sub(r"_sectionLabel\('[^']*'\),\s*//\s*Section:\s*[^']*main", "_sectionLabel('เมนูหลัก'),", content, flags=re.IGNORECASE)
content = re.sub(r"_sectionLabel\('[^']*'\),\s*//\s*Section:\s*system", "_sectionLabel('ระบบอื่นๆ'),", content, flags=re.IGNORECASE)
content = re.sub(r"_sectionLabel\('พื้นที่ส่วนกลาง'\)", "_sectionLabel('พื้นที่ส่วนกลาง')", content) # Keep if correct
# In scan: "Line 2875: _sectionLabel('ѡ')" -> matches 'เมนูหลัก' (Main Menu)
content = content.replace("'_sectionLabel('ѡ')", "_sectionLabel('เมนูหลัก')") # Latin garbage

# Direct string replacements for known garbage
garbage_map = {
    "Šˆา‡วิŠัย": "ช่างวิชัย",
    "Šˆา‡ ‰อ‡": "ช่างก้อง",
    "Šˆา‡ ˆ‡„": "ช่างเก่ง",
    "Šˆา‡ˆิŠš": "ช่างจิ๊บ",
    "Šˆา‡เ ร‹": "ช่างเกรซ",
    "Šˆา‡žี": "ช่างพี",
    "Šˆา‡เส ": "ช่างเสริม",
    "ระšš อรŒ": "ระบบแอร์",
    "ระšš„ŸŸ‰า": "ระบบไฟฟ้า",
    "ระššะ": "ระบบประปา",
    "‡า™‚„ร‡สร‰า‡": "งานโครงสร้าง",
    "‡า™สี / ต  ตˆ‡": "งานสี / ตกแต่ง",
    "ระšš IT": "ระบบ IT",
    "‹ˆอมšำรุ‡": "ซ่อมบำรุง",
    "CANCEL / ย เลิ ": "CANCEL / ยกเลิก",
    "CREATE TASK / สร‰า‡ราย าร": "CREATE TASK / สร้างรายการ",
    "ตารา‡‡า™": "ตารางงาน",
    " ุมภาžั™˜Œ 2569": "กุมภาพันธ์ 2569",
    "มี‡า™": "มีงาน",
    "วˆา‡": "ว่าง",
    "วั™™ัด/เลือ ": "วันนัด/เลือก",
    "ดูประวัติทั้งหมด โ†’": "ดูประวัติทั้งหมด →",
    # Sidebar Latin-1 garbage (heuristically matched by scan output)
    "ᴪ": "ภาพรวม",
    "Ѵçҹ": "รายการแจ้งซ่อม",
    "ªͪҧ": "รายชื่อช่าง",
    "駤": "การตั้งค่า",
    "": "บัญชีผู้ใช้",
    "͡ҡк": "ออกจากระบบ",
    "к͹": "ระบบอื่นๆ",
    "ѡ": "เมนูหลัก",
    # Specific one from scan
    "кѴçҹاç": "ประวัติการแจ้งซ่อม",
}

count = 0
for bad, good in garbage_map.items():
    if bad in content:
        content = content.replace(bad, good)
        count += 1
    # Also try to match regex for the Latin-1 stuff as they might be volatile
    # But direct replace is safer if exact match.

# Fallback RegEx for Sidebar
content = re.sub(r"_navItem\(Icons\.grid_view_rounded, '[^']+', 0\)", "_navItem(Icons.grid_view_rounded, 'ภาพรวม', 0)", content)
content = re.sub(r"_navItem\(Icons\.assignment_outlined, '[^']+', 1\)", "_navItem(Icons.assignment_outlined, 'รายการแจ้งซ่อม', 1)", content)
content = re.sub(r"_navItem\(Icons\.people_outline, '[^']+', 2\)", "_navItem(Icons.people_outline, 'รายชื่อช่าง', 2)", content)
content = re.sub(r"_navItem\(Icons\.settings_outlined, '[^']+', 3\)", "_navItem(Icons.settings_outlined, 'การตั้งค่า', 3)", content)
content = re.sub(r"_navItem\(Icons\.person_outline, '[^']+', 4\)", "_navItem(Icons.person_outline, 'บัญชีผู้ใช้', 4)", content)
content = re.sub(r"onTap: \(\) => _showLogoutDialog\(context\),\s*child: _sectionLabel\('[^']+'\)", "onTap: () => _showLogoutDialog(context), child: _sectionLabel('ออกจากระบบ')", content)

# Fix calendar days if broken
# "อา", "ˆ", "อ", "ž", "žฤ", "ศ", "ส"
# "ˆ" -> "จ" (Mon)
# "ž" -> "พ" (Wed)
days_map = {
    '"ˆ"': '"จ"',
    '"ž"': '"พ"',
    '"žฤ"': '"พฤ"',
}
for bad, good in days_map.items():
    content = content.replace(bad, good)

print(f"Replaced {count} exact garbage strings and applied regex fixes.")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
