

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset('assets/images/chat_icon.png',width: 100,height: 100,),
      ),
    );
  }

}