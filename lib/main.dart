import 'package:flutter/material.dart';

import './screens/base_page.dart';

void main() {
  runApp(MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatty',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
          primaryColor: Colors.blue[800],
          scaffoldBackgroundColor: Colors.grey[100]),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()).copyWith(
        accentColor: Colors.blue[800],
      ),
      home: BasePage(),
    );
  }
}
