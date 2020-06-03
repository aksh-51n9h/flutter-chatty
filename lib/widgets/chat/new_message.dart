import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/models/contact.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/models/user.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({
    this.isNewChat,
  });

  final bool isNewChat;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _db = Firestore.instance;
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    final ChatsBloc chatsBloc = BlocProvider.of<ChatsBloc>(context);
    final Chat chat = chatsBloc.chat;
    final User sender = chat.sender;
    final Contact receiver = chat.receiver;

    final String chatID = chat.chatID;

    if (widget.isNewChat) {
      final WriteBatch batch = _db.batch();

      final DocumentReference userChats =
          _db.collection('chats').document(chatID);
      batch.setData(
        userChats,
        {
          'senderID': sender.uid,
          'requestedChat': true,
          'receiverID': receiver.receiverID,
          'primaryChat': false,
          'messageAllowed': false,
          'blocked': false,
          'blockedBy': null,
        },
      );

      CollectionReference chatsList =
          _db.collection('users/${sender.uid}/chats_list');
      chatsList.add(
        {
          'fullname': receiver.fullname,
          'username': receiver.username,
          'receiverID': receiver.receiverID,
          'imageUrl': '',
          'blocked': false,
          'blockedBy': null,
        },
      );

      chatsList = _db.collection('users/${receiver.receiverID}/chats_list');
      chatsList.add(
        {
          'fullname': sender.fullname,
          'username': sender.username,
          'receiverID': sender.uid,
          'imageUrl': sender.imageUrl,
          'blocked': false,
          'blockedBy': null,
        },
      );

      batch.commit();
    }

    final Message message = Message(
      text: _enteredMessage,
      createdAt: Timestamp.now(),
      userId: sender.uid,
    );

    chatsBloc.sendMessage(message);

    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Container(
          // margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              constraints.maxWidth * 0.06,
            ),
//            color: Colors.blueGrey[50],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.sentiment_satisfied),
                onPressed: _enteredMessage.trim().isEmpty ? null : () {},
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 16.0),
                  autocorrect: true,
                  maxLines: 5,
                  minLines: 1,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
//                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: _enteredMessage.trim().isNotEmpty
                      ? Colors.blueAccent[100]
                      : null,
                ),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              )
            ],
          ),
        ),
      );
    });
  }
}
