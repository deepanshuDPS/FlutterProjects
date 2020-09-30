import 'package:flutter/material.dart';
import 'package:flutter_basics/Answer.dart';
import 'package:flutter_basics/Question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> question;
  final int questionIndex;
  final Function answerQuestion;

  Quiz(
      {@required this.question,
      @required this.questionIndex,
      @required this.answerQuestion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(question[questionIndex]["questionText"]),
        ...(question[questionIndex]["answers"] as List<Map<String, Object>>)
            .map((answer) => Answer(
                () => answerQuestion(answer["score"]), answer["answerText"]))
            .toList()
      ],
    );
  }
}
