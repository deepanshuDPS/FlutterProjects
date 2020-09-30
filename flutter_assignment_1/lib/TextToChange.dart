import 'package:flutter/material.dart';


class TextToChange extends StatelessWidget{

  final String textChange;

  TextToChange(this.textChange);

  @override
  Widget build(BuildContext context) {
    return Text(textChange);
  }


}