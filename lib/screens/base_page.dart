import 'package:chatty/provider/authentication/auth.dart';
import 'package:chatty/screens/all_chats.dart';
import 'package:chatty/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FirebaseUser>(
        future: _auth.getCurrentUser(),
        builder: (ctx, future) {
          if (future.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (future.data != null) {
            return AllChats(auth: _auth,username: "akshay",);
          }

          return AuthScreen();
        },
      ),
    );
  }
}
