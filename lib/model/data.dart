import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recase/recase.dart';

class QuizObject {
  QuizSubjectType subject;
  String topic;
  String videoType;
  String videoLink;
  List<QuizQuestion> questions = <QuizQuestion>[];
  bool isValid = false;

  String get subjectCapi => QuizSubjectTypeInfo[subject].displayName;

  QuizObject(
      {this.subject = QuizSubjectType.math,
      this.topic = "",
      this.videoLink = "",
      this.videoType = 'youtube'});

  factory QuizObject.fromJson(Map<String, dynamic> json) => QuizObject(
        subject: fromName(json["subject"]),
        topic: json["topic"],
        videoLink: json["videoLink"],
        videoType: json["videoType"],
      )..questions = List<QuizQuestion>.from(
          json["questions"].map((x) => QuizQuestion.fromJson(x)));

  Map toJson() => {
        "subject": QuizSubjectTypeInfo[subject].name,
        "topic": topic,
        "videoLink": videoLink,
        "videoType": videoType,
        "questions": questions,
      };
}

class QuizQuestion {
  String content;
  QuizQuestionType type;
  List<QuizAnswer> answers = <QuizAnswer>[];
  QuizQuestion(
      {this.content = "", this.type = QuizQuestionType.multipleChoice});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        content: json["content"],
        type: {
          'QuizQuestionType.multipleChoice': QuizQuestionType.multipleChoice,
        }[json["type"]],
      )..answers = List<QuizAnswer>.from(
          json["answers"].map((x) => QuizAnswer.fromJson(x)));

  Map toJson() =>
      {"content": content, "type": type.toString(), "answers": answers};
}

class QuizAnswer {
  String content;
  bool correct;
  QuizAnswer({this.content = "", this.correct = false});

  factory QuizAnswer.fromJson(Map<String, dynamic> json) => QuizAnswer(
        content: json["content"],
        correct: json["correct"],
      );

  Map toJson() => {"content": content, "correct": correct};
}

enum QuizQuestionType {
  multipleChoice,
}
enum QuizSubjectType {
  math,
  german,
  englisch,
  history,
  it,
  physik,
  biologie,
  chemie,
  politik,
  sport,
  witschaft,
  ethik,
  musik,
}

class InfoForEnum {
  String name;
  String displayName;
  IconData symbol;
  InfoForEnum(String name, String displayName, IconData symbol) {
    this.name = name;
    this.displayName = displayName;
    this.symbol = symbol;
  }
}

QuizSubjectType fromName(String name) {
  for (var s in QuizSubjectType.values) {
    if (QuizSubjectTypeInfo[s].name == name) return s;
  }
  return null;
}

/*    for (var item in [
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '', // bank-out...
                        '',
                        '',
                        '',
                        '',
                      ]) */
final QuizSubjectTypeInfo = <QuizSubjectType, InfoForEnum>{
  QuizSubjectType.math: InfoForEnum(
      "mathe", "Mathe", MdiIcons.androidStudio), //calculatorVariantOutline
  QuizSubjectType.it:
      InfoForEnum("informatik", "Informatik", MdiIcons.serverSecurity),
  QuizSubjectType.physik:
      InfoForEnum("physik", "Physik", MdiIcons.arrowExpandVertical),
  QuizSubjectType.biologie:
      InfoForEnum("biologie", "Biologie", MdiIcons.babyFaceOutline),
  QuizSubjectType.chemie:
      InfoForEnum("chemie", "Chemie", MdiIcons.puzzleOutline),
  QuizSubjectType.politik:
      InfoForEnum("politik", "Politik", MdiIcons.bankOutline),
  QuizSubjectType.englisch:
      InfoForEnum("englisch", "Englisch", MdiIcons.attachment),
  QuizSubjectType.sport:
      InfoForEnum("sport", "Sport", MdiIcons.seatReclineExtra),
  QuizSubjectType.history:
      InfoForEnum("geschichte", "Geschichte", Icons.auto_stories),
  QuizSubjectType.german: InfoForEnum("deutsch", "Deutsch", Icons.language),
  QuizSubjectType.witschaft:
      InfoForEnum("witschaft", "Witschaft", Icons.calculate_outlined),
  QuizSubjectType.ethik:
      InfoForEnum("ethik", "Ethik", MdiIcons.accountCheckOutline),
  QuizSubjectType.musik: InfoForEnum("musik", "Musik", MdiIcons.accountVoice),
};

final QuizQuestionTypeInfo = <QuizQuestionType, InfoForEnum>{
  QuizQuestionType.multipleChoice:
      InfoForEnum("multipleChoice", "Mehrfachauswahl", Icons.ballot_sharp)
};

/*final icons = <QuizSubjectType, IconData>{
  QuizSubjectType.math: Icons.add_chart,
  QuizSubjectType.history: Icons.auto_stories,
  QuizSubjectType.german: Icons.language,
};
final names = <QuizSubjectType, String>{
  QuizSubjectType.math: "mathe",
  QuizSubjectType.history: "geschichte",
  QuizSubjectType.german: "deutsch"
};*/
/*final namesQuizQuestionType = <QuizQuestionType, String>{
  QuizQuestionType.multipleChoice: "Mehrfachauswahl"
};*/
