import 'package:recase/recase.dart';

class QuizObject {
  String subject;
  String topic;
  String videoType;
  String videoLink;
  List<QuizQuestion> questions = <QuizQuestion>[];
  bool isValid = false;
  String get fachCapi => fach.sentenceCase;
  QuizObject(
      {this.subject = "mathe",
      this.topic = "",
      this.videoLink = "",
      this.videoType = 'youtube'});

  factory QuizObject.fromJson(Map<String, dynamic> json) => QuizObject(
        subject: json["subject"],
        topic: json["topic"],
        videoLink: json["videoLink"],
        videoType: json["videoType"],
      )..questions = List<QuizQuestion>.from(
          json["questions"].map((x) => QuizQuestion.fromJson(x)));

  Map toJson() => {
        "subject": subject,
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

enum QuizQuestionType { multipleChoice }
