import 'package:flutter/material.dart';

class LastMessageWaiting extends StatefulWidget {
  @override
  _LastMessageWaitingState createState() => _LastMessageWaitingState();
}

class _LastMessageWaitingState extends State<LastMessageWaiting>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.11, end: 0.32).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (ctx, child) {
          return Container(
            height: 6,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).accentColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.01, _animation.value, 0.4],
                ),
                borderRadius: BorderRadius.circular(4)),
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
