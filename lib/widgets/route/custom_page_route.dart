import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({@required this.child})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ClipRRect(
              child: child,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(15.0),
            );
          },
//          transitionDuration: Duration(seconds: 3),
//          transitionDuration: Duration(milliseconds: 450),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.96,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1.125),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}
