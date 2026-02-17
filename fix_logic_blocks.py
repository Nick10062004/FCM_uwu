path = r'd:\FCM\lib\features\legal\presentation\screens\legal_dashboard_screen.dart'

with open(path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
skip = False
custom_role_block_inserted = False
custom_schedule_block_inserted = False

# Logic for Roles (around line 2163)
# We look for `String role = "..."`
# And then the sequence of ifs.

# Logic for Schedule (around line 2152)
# We look for `if (name == "ช่างวิชัย")`

for i, line in enumerate(lines):
    # ---------------------------------------------------------
    # 1. Schedule Block Replacement
    # ---------------------------------------------------------
    if 'if (name == "ช่างวิชัย")' in line and 'busyDays =' in lines[i+1]:
        # Start of schedule block
        new_lines.append(line) # Keep Wichai line as it is correct
        continue
    
    # Check if inside schedule block to replace garbage ones
    # We identify them by the unique array content in the NEXT line
    if 'else if (name ==' in line:
        next_line = lines[i+1] if i+1 < len(lines) else ""
        
        # Kong: [5, 11, 12, 14, 15, 22]
        if '[5, 11, 12, 14, 15, 22]' in next_line:
            new_lines.append('              } else if (name == "ช่างก้อง") {\n')
            continue
            
        # Keng: [3, 9, 20, 21]
        if '[3, 9, 20, 21]' in next_line:
             new_lines.append('              } else if (name == "ช่างเก่ง") {\n')
             continue

        # Jib: [8, 16, 21, 28]
        if '[8, 16, 21, 28]' in next_line:
             new_lines.append('              } else if (name == "ช่างจิ๊บ") {\n')
             continue

        # Grace: [4, 10, 17, 24]
        if '[4, 10, 17, 24]' in next_line:
             new_lines.append('              } else if (name == "ช่างเกรซ") {\n')
             continue

        # Pee: [6, 14, 19, 27]
        if '[6, 14, 19, 27]' in next_line:
             new_lines.append('              } else if (name == "ช่างพี") {\n')
             continue

    # ---------------------------------------------------------
    # 2. Role Block Replacement
    # ---------------------------------------------------------
    # We look for the start: `String role =`
    if 'String role =' in line and not custom_role_block_inserted:
        # We replace the entire block of if/ifs following this
        # Default role = Air (Jib)
        new_lines.append('                          String role = "ระบบแอร์";\n')
        new_lines.append('                          if (tech == "ช่างวิชัย") role = "ระบบไฟฟ้า";\n')
        new_lines.append('                          if (tech == "ช่างก้อง") role = "ระบบประปา";\n')
        new_lines.append('                          if (tech == "ช่างเก่ง") role = "งานโครงสร้าง";\n')
        new_lines.append('                          if (tech == "ช่างจิ๊บ") role = "ระบบแอร์";\n') # Explicitly redundancy or just rely on default
        new_lines.append('                          if (tech == "ช่างเกรซ") role = "งานสี / ตกแต่ง";\n')
        new_lines.append('                          if (tech == "ช่างพี") role = "ระบบ IT";\n')
        new_lines.append('                          if (tech == "ช่างเสริม") role = "ซ่อมบำรุง";\n')
        
        custom_role_block_inserted = True
        skip = True # Skip existing lines until we exit the block
        continue
    
    if skip:
        # We are skipping the old role logic
        # We stop skipping once we hit `return Padding` or `_buildTechScheduleCalendar`
        if 'return Padding' in line or '_buildTechScheduleCalendar' in line:
            skip = False
            new_lines.append(line)
        continue

    new_lines.append(line)

with open(path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

print("Logic blocks rewritten.")
