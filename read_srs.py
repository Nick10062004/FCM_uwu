import fitz
import sys

doc = fitz.open(r'c:\Users\shiero\Downloads\SRS V2.0 ไฟนอล.pdf')
print(f'Total pages: {doc.page_count}', flush=True)
with open(r'D:\FCM\srs_output.txt', 'w', encoding='utf-8') as f:
    for i in range(doc.page_count):
        text = doc[i].get_text()
        f.write(f'=== PAGE {i+1} ===\n')
        f.write(text)
        f.write('\n')
doc.close()
print('DONE', flush=True)
