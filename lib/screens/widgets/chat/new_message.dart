import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage(this.toUserId);
  final String toUserId;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final Map<String, Object> message = {
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
    };

    final String userID = user.uid;
    final String chatID = (userID.compareTo(widget.toUserId) > 0)
        ? userID + widget.toUserId
        : widget.toUserId + userID;

    final Firestore db = Firestore.instance;

    final CollectionReference messagesCollection =
        db.collection('chats/$chatID/messages')
          ..add(
            message,
          );

    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
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
                onPressed: _enteredMessage.trim().isEmpty ? null : (){},
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
