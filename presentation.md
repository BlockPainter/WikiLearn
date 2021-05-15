---
marp: true
---

# Der WikiLearn Editor

Ein JHFFM2021 Projekt.

---

# Übersicht und Gesamtziel

- Daten für die Frontend Gruppe
- Lernvideos sammeln und kategorisieren
- Quiz-Fragen zu den Videos erstellen

---

# Technologien

- JSON-Strukturen für die andere Gruppe
- Desktop App in Flutter zum einfachen Bearbeiten
- Hochladen der Daten zu Sia Skynet (bald)

---

# Live-Demo des Editors

---

# Die Datenstruktur • index.json

```json
{
  "geschichte": [
    {
      "subject": "geschichte",
      "topic": "Industrialisierung",
      "image": "https://i3.ytimg.com/vi/QRjH3bxsRao/mqdefault.jpg",
      "questionCount": 2,
      "url": "https://jhackt.hns.siasky.net/geschichte/Industrialisierung.json"
    }
  ]
}
```

---

# Die Datenstruktur • Quizdaten

```json
{
  "subject": "geschichte",
  "topic": "Industrialisierung",
  "videoType": "youtube",
  "videoLink": "QRjH3bxsRao",
  "questions": [
    {
      "content": "Welches Geschlecht hat meist am Spinrad gearbeitet?",
      "type": "QuizQuestionType.multipleChoice",
      "answers": [
        {
          "content": "Mann",
          "correct": false
        },
        {
          "content": "Frau",
          "correct": true
        },
        {
          "content": "Divers",
          "correct": false
        }
      ]
    }
  ]
}
```

---

# Danke fürs Zuhören
