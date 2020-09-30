import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetQuiz;

  Result(this.totalScore, this.resetQuiz);

  String get result {
    var resultText = "";
    if (totalScore > 18)
      resultText = "Good Boy";
    else if (totalScore > 15) {
      resultText = "Can do better";
    } else if (totalScore > 10) {
      resultText = "50-50";
    } else {
      resultText = "Need Improvement";
    }

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(result,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            FlatButton(
              child: Text("Reset Quiz"),
              onPressed: resetQuiz,
              textColor: Colors.blue,
            )
          ],
        ));
  }
}
