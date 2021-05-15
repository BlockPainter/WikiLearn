class QuizObject {
  String fach;
  String topic;
  String videoLink;
  List<QuizQuestion> questions = <QuizQuestion>[];
  bool isValid = false;

  QuizObject({this.fach = "mathe", this.topic = "", this.videoLink = ""});

  factory QuizObject.fromJson(Map<String, dynamic> json) => QuizObject(
        fach: json["fach"],
        topic: json["topic"],
        videoLink: json["videoLink"],
      )..questions = List<QuizQuestion>.from(
          json["questions"].map((x) => QuizQuestion.fromJson(x)));

  Map toJson() => {
        "fach": fach,
        "topic": topic,
        "videoLink": videoLink,
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
