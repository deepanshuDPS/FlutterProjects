import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, // match parent
        margin: EdgeInsets.all(10), // all sides margin
        child: Text(
          questionText,
          style: TextStyle(fontSize: 26),
          textAlign: TextAlign.center,
        ) // Text,
        );
  }
}
