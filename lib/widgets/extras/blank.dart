import 'package:flutter/material.dart';

class Blank extends StatelessWidget {
  const Blank({
    @required this.height,
    @required this.width,
  });

  final double height, width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      width: this.width,
    );
  }
}
