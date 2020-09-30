import 'package:flutter/material.dart';

import 'TextToChange.dart';


class AppState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextControl();
  }
}

class _TextControl extends State<AppState> {

  final _textArray = const [
    "A for apple",
    "B for ball",
    "C for cat",
    "D for dog"
  ];
  var _textIndex = 0;

  void _changeText() {
    setState(() {
      if (_textIndex < _textArray.length - 1)
        _textIndex++;
      else
        _textIndex = 0;
    });

    print(_textIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextToChange(_textArray[_textIndex]),
      RaisedButton(
        child: Text("Change Text"),
        onPressed: _changeText,
      )
    ],);
  }
}
