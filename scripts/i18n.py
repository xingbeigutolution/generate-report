import json
import csv

with open('scripts/translations.csv', encoding="utf8") as translations:
    translations_reader = csv.reader(translations)
    languages = next(translations_reader)[1:]
    all_translations = {
        row[0].strip(): {
            language: row[i + 1].strip() for i, language in enumerate(languages)
        } for row in translations_reader
    }
    with open("templates/Gleneagles_ENG/i18n.json", "w", encoding="utf8") as i18n:
        json.dump(all_translations, i18n, ensure_ascii=False, indent=2)
    with open("templates/Gleneagles_CN/i18n.json", "w", encoding="utf8") as i18n:
            json.dump(all_translations, i18n, ensure_ascii=False, indent=2)