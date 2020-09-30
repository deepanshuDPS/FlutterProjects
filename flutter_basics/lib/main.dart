import 'package:flutter/material.dart';
import 'package:flutter_basics/Quiz.dart';
import 'package:flutter_basics/Result.dart';

/*void main() {
  runApp(MyApp());
}*/

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;

  final _questions = const [
    {
      "questionText": "What's your name?",
      "answers": [
        {"answerText": "Deepanshu", "score": 9},
        {"answerText": "Rudraksh", "score": 8},
        {"answerText": "Deepu", "score": 5},
        {"answerText": "Rudru", "score": 5}
      ]
    },
    {
      "questionText": "What's your favourite color?",
      "answers": [
        {"answerText": "Red", "score": 3},
        {"answerText": "Green", "score": 5},
        {"answerText": "Blue", "score": 4},
        {"answerText": "Yellow", "score": 6}
      ]
    },
    {
      "questionText": "What's your hobby?",
      "answers": [
        {"answerText": "Sports", "score": 6},
        {"answerText": "Study", "score": 5},
        {"answerText": "Animation", "score": 9},
        {"answerText": "Coding", "score": 6}
      ]
    }
  ];

  void _resetQuiz() {
    setState(() {
      _totalScore = 0;
      _questionIndex = 0;
    });
  }

  void _answerQuestion(int totalScore) {
    _totalScore += totalScore;
    setState(() {
      _questionIndex++;
    });
    if (_questionIndex < _questions.length) {
      print("Next Question" + _totalScore.toString());
    } else {
      print("No More Question");
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First Application"),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                question: _questions,
                questionIndex: _questionIndex,
                answerQuestion: _answerQuestion)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
