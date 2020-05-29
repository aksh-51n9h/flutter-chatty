import './screens/root_page.dart';
import './provider/authentication/auth.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  ///Holds an instance of [Auth] class.
  final Auth _auth = Auth.getInstance();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatty',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
        primaryColor: Colors.blue[800],
      ),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()).copyWith(
        accentColor: Colors.blue[800],
      ),
      home: BasePage(_auth),
    );
  }
}
