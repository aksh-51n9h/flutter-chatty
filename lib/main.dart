import 'package:cloud_firestore/cloud_firestore.dart';

import './screens/all_chats.dart';
import 'package:flutter/material.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            final Firestore db = Firestore.instance;
            DocumentReference userDocs =
                db.collection('users').document('${userSnapshot.data.uid}');

            userDocs.get().then((userInfo) {
              if (userInfo.exists) {
                _saveUserInfo(userInfo);
              }
            });

            return AllChats();
          }

          return AuthScreen();
        },
      ),
    );
  }

  void _saveUserInfo(DocumentSnapshot userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    userInfo.data.forEach((key, value) {
      prefs.setString(key, value);
    });
  }
}
