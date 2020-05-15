import 'package:chatty/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({
    @required this.sender,
    @required this.receiver,
    @required this.isNewChat,
  });
  final User sender;
  final User receiver;
  final bool isNewChat;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _db = Firestore.instance;
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    final User sender = widget.sender;
    final User receiver = widget.receiver;

    final String chatID = _getChatID(sender, receiver);

    if (widget.isNewChat) {
      final WriteBatch batch = _db.batch();

      final DocumentReference userChats =
          _db.collection('chats').document(chatID);
      batch.setData(
        userChats,
        {
          'senderID': sender.uid,
          'requestedChat': true,
          'receiverID': receiver.uid,
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
          'receiverID': receiver.uid,
          'imageUrl': receiver.imageUrl,
          'blocked': false,
          'blockedBy': null,
        },
      );

      chatsList = _db.collection('users/${receiver.uid}/chats_list');
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

    final Map<String, Object> message = {
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': sender.uid,
    };

    _db.collection('chats/$chatID/messages')
      ..add(
        message,
      );

    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  String _getChatID(User sender, User receiver) {
    final String chatID = (sender.uid.compareTo(receiver.uid) > 0)
        ? sender.uid + receiver.uid
        : receiver.uid + sender.uid;
    return chatID;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrainst) {
      print(constrainst.maxWidth * 0.08);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Container(
          // margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              constrainst.maxWidth * 0.06,
            ),
            color: Colors.blueGrey[700],
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
                    hintStyle: TextStyle(color: Colors.white),
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
