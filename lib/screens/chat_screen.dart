import 'package:chatty/screens/widgets/app_bar_title.dart';

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
        title: AppbarTitle(title: receiver.username, subtitle: receiver.fullname),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: null),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(receiver.uid),
            ),
            NewMessage(
              sender: sender,
              receiver: receiver,
              isNewChat: isNewChat,
            ),
          ],
        ),
      ),
    );
  }
}
