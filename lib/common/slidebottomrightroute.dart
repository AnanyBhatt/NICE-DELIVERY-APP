import 'package:flutter/material.dart';

class SlideBottomRightPageRoute extends MaterialPageRoute {
  SlideBottomRightPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom =
        Tween<Offset>(begin: Offset(1.0, 1.0), end: Offset(0.0, 0.0))
            .animate(animation);
    return SlideTransition(position: custom,child: child,);
  }
}
