import 'package:flutter/material.dart';

///This widget is used to create blank box of the given dimensons.
class Blank extends StatelessWidget {
  const Blank({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height, width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
    );
  }
}
