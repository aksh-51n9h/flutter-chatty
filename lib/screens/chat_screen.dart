import 'package:chatty/screens/widgets/chat/messages.dart';
import 'package:chatty/screens/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    @required this.senderID,
    @required this.receiverID,
    @required this.receiverUserName,
    @required this.isNewChat,
  });
  final String senderID;
  final String receiverID;
  final String receiverUserName;
  final bool isNewChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverUserName),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(receiverID),
            ),
            NewMessage(
              senderID: senderID,
              receiverID: receiverID,
              isNewChat: isNewChat,
            ),
          ],
        ),
      ),
    );
  }
}
