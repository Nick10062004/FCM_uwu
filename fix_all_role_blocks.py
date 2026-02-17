path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
skip = False

# We want to replace EVERY block that starts with `String role =`
# until we hit `return Padding`

for i, line in enumerate(lines):
    # ---------------------------------------------------------
    # Rule: Role Block Replacement
    # ---------------------------------------------------------
    # Trigger on `String role =`
    if 'String role =' in line:
        # We replace the entire block of if/ifs following this
        # We reuse the indent from the found line
        indent = line[:line.find('String')]
        
        new_lines.append(f'{indent}String role = "ระบบแอร์";\n')
        new_lines.append(f'{indent}if (tech == "ช่างวิชัย") role = "ระบบไฟฟ้า";\n')
        new_lines.append(f'{indent}if (tech == "ช่างก้อง") role = "ระบบประปา";\n')
        new_lines.append(f'{indent}if (tech == "ช่างเก่ง") role = "งานโครงสร้าง";\n')
        new_lines.append(f'{indent}if (tech == "ช่างจิ๊บ") role = "ระบบแอร์";\n')
        new_lines.append(f'{indent}if (tech == "ช่างเกรซ") role = "งานสี / ตกแต่ง";\n')
        new_lines.append(f'{indent}if (tech == "ช่างพี") role = "ระบบ IT";\n')
        new_lines.append(f'{indent}if (tech == "ช่างเสริม") role = "ซ่อมบำรุง";\n')
        
        skip = True
        continue
    
    if skip:
        # We are skipping the old role logic
        # Stop skipping when we hit `return Padding` or `_buildTechScheduleCalendar`
        if 'return Padding' in line or '_buildTechScheduleCalendar' in line:
            skip = False
            new_lines.append(line)
        continue

    # Note: We are NOT touching the schedule block here as it was already fixed 
    # and "if (name == ...)" logic is complex to re-match if already fixed.
    # The previous script fixed the schedule block, so it should remain fixed in `lines`.
    
    new_lines.append(line)

with open(path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

print("All role logic blocks rewritten.")
