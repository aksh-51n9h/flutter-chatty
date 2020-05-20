import 'package:chatty/screens/base_page.dart';

import './screens/root_page.dart';
import './provider/authentication/auth.dart';

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
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
        primaryColor: Colors.blue[800],
      ),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()).copyWith(
        accentColor: Colors.blue[800],
      ),
      home: RootPage(Auth()),
    );
  }
}
