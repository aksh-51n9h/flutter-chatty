import '../models/user.dart';
import '../screens/widgets/chat/messages.dart';
import '../screens/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    @required this.sender,
    @required this.receiver,
    @required this.isNewChat,
  });
  final User sender;
  final User receiver;
  final bool isNewChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.username),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(receiver.uid),
            ),
            NewMessage(
              sender:sender,
              receiver:receiver,
              isNewChat: isNewChat,
            ),
          ],
        ),
      ),
    );
  }
}
