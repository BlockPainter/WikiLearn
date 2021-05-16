/* import 'dart:io';

import 'package:path/path.dart'; */

// final languageDir = Directory(join("Language"));

/* class LanguageInit {
  bool hasLanguages = false;
  List<String> languages;

  List<String> getLanguages() {
    if (!hasLanguages) {
      final languages = <String>[];
      for (var file in languageDir.listSync()) {
        if (file is File) {
          languages.add(file.path);
        }
      }

      this.languages = languages;
      hasLanguages = true;
    }
    return this.languages;
  }

  bool readLanguages(String l) {
    final file = File(join(languageDir.path, l));
    if (file.existsSync()) return true;
    String str = file.readAsStringSync();
    List<String> lines = str.split("\n");
    for (var l in lines) {
      List<String> args = str.split("=");
      Language[args[0]] = args[1];
    }
    return false;
  }
} */

/* final Language = <String, String>{
  "heading": "WikiLearn Editior",
  "overview.heading": "Übersicht",
  "overview.add": "Hinzufügen",
  "settings.chooseLanguage": "Sprache ändern",
  "editor.heading": "Json Editor",
  "editor.topic": "Tehmer",
  "editor.url": "Youtube Video Link oder Code",
  "editor.url.error.empty": "Die URL ist noch leer",
  "editor.url.error.invalid": "Es gibt leider kein Video :(",
  "editor.add.question": "Frage Hinzufügen",
  "editor.content": "Fragestellung / Frage",
  "editor.add.answer": "Antwort Hinzufügen",
  "editor.answer": "Antwort",
  "editor.valid": "Richtig",
};
 */