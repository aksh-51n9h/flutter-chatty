import 'package:flutter/material.dart';

class EmptyStateUI extends StatefulWidget {
  @override
  _EmptyStateUIState createState() => _EmptyStateUIState();
}

class _EmptyStateUIState extends State<EmptyStateUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('No network connection \u2639'),
      ),
    );
  }
}
