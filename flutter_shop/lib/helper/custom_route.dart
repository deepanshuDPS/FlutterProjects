import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder widgetBuilder, RouteSettings settings})
      : super(builder: widgetBuilder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/')
      return child;
    else
      return FadeTransition(
        opacity: animation,
        child: child,
      );
  }
}

class CustomPageTransactionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> route,
      BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (route.settings.name == '/')
      return child;
    else
      return FadeTransition(
        opacity: animation,
        child: child,
      );
  }

}
