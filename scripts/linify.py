import json

with open("scripts/effects.txt", encoding="utf8") as f:
    contents = f.read()
    paragraphs = contents.split("\n\n")
    lines = [ "".join(paragraph.split("\n")).strip() for paragraph in paragraphs ]
    with open("templates/Gleneagles_CN/sections/disease-risks-assessment/bacteria-effects-autoimmunity.json", 'w', encoding="utf8") as results:
        json.dump(lines, results, ensure_ascii=False, indent=2)