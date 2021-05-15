class QuizObject {
  String fach;
  String topic;
  String videoLink;
  List<QuizQuestion> questions = <QuizQuestion>[];

  QuizObject({this.fach = "mathe", 
    this.topic = "",  this.videoLink = ""});

  Map toJson() => {
    "fach" : fach,
    "topic" : topic,
    "videoLink" : videoLink,
    "questions" : questions,
  };
}

class QuizQuestion {
  String content;
  QuizQuestionType type;
  List<QuizAnswer> answers = <QuizAnswer>[];
  QuizQuestion({this.content = "",
    this.type = QuizQuestionType.multipleChoice});
  
  Map toJson() => {
    "content" : content,
    "type" : type.toString(),
    "answers" : answers
  };
}

class QuizAnswer {
  String content;
  bool correct;
  QuizAnswer({this.content = "",
    this.correct = false});
    Map toJson() => {
    "content" : content,
    "correct" : correct
  };
}

enum QuizQuestionType{
  multipleChoice
}