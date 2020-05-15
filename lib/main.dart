import 'package:chatty/screens/root_page.dart';
import 'package:chatty/screens/widgets/auth/auth.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        accentColor: Colors.blue[600],
        scaffoldBackgroundColor: Colors.black,
      ),
      home: RootPage(Auth()),
    );
  }
}
