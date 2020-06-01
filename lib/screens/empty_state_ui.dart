import 'package:flutter/material.dart';

class EmptyStateUI extends StatefulWidget {
  @override
  _EmptyStateUIState createState() => _EmptyStateUIState();
}

class _EmptyStateUIState extends State<EmptyStateUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.search,
            size: 64,
          ),
          Text("Search Contacts"),
        ],
      ),
    );
  }
}
