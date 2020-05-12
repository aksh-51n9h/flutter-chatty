import 'package:chatty/screens/widgets/chat/messages.dart';
import 'package:chatty/screens/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.toUserId, this.toUserName);
  final String toUserId;
  final String toUserName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(toUserName),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(toUserId),
            ),
            NewMessage(toUserId),
          ],
        ),
      ),
    );
  }
}
