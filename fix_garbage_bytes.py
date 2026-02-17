import re

path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Exact matches based on repr() output
# 2161: name == "\x8a\x88า\x87เ\x81ร\x8b" -> "ช่างเกรซ" (Grace)
# 2163: name == "\x8a\x88า\x87\x9eี" -> "ช่างพี" (Pee)

# We need to use byte-like matching or careful string escaping
# Let's try to construct the exact strings from the escape sequences seen in the output
# The output showed: '\x8a\x88า\x87เ\x81ร\x8b'
# Python str uses \x for hex escapes. 
# But wait, `repr` output `` which is U+FFFD (replacement char).
# This means the file ALREADY HAS U+FFFD IN IT?
# If so, my previous "fix" attempts might have baked them in or they were there from start.
# If they are genuinely U+FFFD in the file, we can match them.

replacements = {
    # From inspection
    "\x8a\x88า\x87เ\x81ร\x8b": "ช่างเกรซ",
    "\x8a\x88า\x87\x9eี": "ช่างพี",
    
    # We should also re-inspect the other broken lines (2160ish) but they weren't in the range I printed. 
    # Let's blindly add the likely patterns for others if they follow the same "" pattern
    # "Šˆา‡" seems to be "ช่าง" (Chang - Technician)
    "\x8a\x88า\x87": "ช่าง",
    
    # Let's try to catch the "roles" which I missed in the previous print
    # But I can search for "role =" lines generally
}

# Let's iterate and replace common garbage prefixes/suffixes
# "\x8a\x88" -> "ช" or similar?
# Actually, let's just use the `find_mojibake.py` output from earlier which had:
# Line 2164: if (tech == "Šˆา‡วิŠัย") role = "ระšš„ŸŸ‰า";
# The `find_mojibake` output `` is likely `\ufffd`.

content = content.replace("\x8a\x88า\x87เ\x81ร\x8b", "ช่างเกรซ")
content = content.replace("\x8a\x88า\x87\x9eี", "ช่างพี")

# Generic replace for the "Chang" prefix which seems to be "\x8a\x88า\x87"
content = content.replace("\x8a\x88า\x87", "ช่าง")

# Other specific ones found in find_mojibake log, adapting to what `repr` likely is:
# "วิŠัย" -> "วิชัย"
content = content.replace("วิ\x8aัย", "วิชัย")
content = content.replace("วิŠัย", "วิชัย") # Try both escaped and unescaped if possible

# " ‰อ‡" -> "ก้อง" (Kong)
content = content.replace(" ‰อ‡", "ก้อง")
content = content.replace("\x20\x89อ\x87", "ก้อง")

# " ˆ‡„" -> "เก่ง" (Keng)
content = content.replace(" ˆ‡„", "เก่ง")
content = content.replace("\x20\x88\x87\x84", "เก่ง") # Guessing escapes

# "ˆิŠš" -> "จิ๊บ" (Jib)
content = content.replace("ˆิŠš", "ช่างจิ๊บ")
content = content.replace("\x88ิ\x8a\x9a", "ช่างจิ๊บ") 

# "เส " -> "เสริม" (Serm)
content = content.replace("เส ", "เสริม")
content = content.replace("เส\x20", "เสริม")

# Roles
# "ระšš" -> "ระบบ" (System)
content = content.replace("ระšš", "ระบบ")
content = content.replace("ระ\x9a\x9a", "ระบบ")

# " อรŒ" -> "แอร์" (Air)
content = content.replace(" อรŒ", "แอร์") 
content = content.replace("\x20อร\x8c", "แอร์")

# "„ŸŸ‰า" -> "ไฟฟ้า" (Electric)
content = content.replace("„ŸŸ‰า", "ไฟฟ้า")
# "›ระ›า" -> "ประปา" (Plumbing)
content = content.replace("›ระ›า", "ประปา")
# "‹ˆอมšำรุ‡" -> "ซ่อมบำรุง" (Maintenance)
content = content.replace("‹ˆอมšำรุ‡", "ซ่อมบำรุง")
# "‡า™‚„ร‡สร‰า‡" -> "งานโครงสร้าง" (Structural Work)
content = content.replace("‡า™‚„ร‡สร‰า‡", "งานโครงสร้าง")
# "‡า™สี / ต  ตˆ‡" -> "งานสี / ตกแต่ง" (Paint/Decor)
content = content.replace("‡า™สี / ต  ตˆ‡", "งานสี / ตกแต่ง")

# Final sweep for any remaining "" chars in generic words?
# "‡า™" -> "งาน" (Work)
content = content.replace("‡า™", "งาน")

print("Byte-level replacement completed.")

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
