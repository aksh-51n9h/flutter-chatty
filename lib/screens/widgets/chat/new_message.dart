import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewMessage extends StatefulWidget {
  NewMessage({
    @required this.senderID,
    @required this.receiverID,
    @required this.isNewChat,
  });
  final String senderID;
  final String receiverID;
  final bool isNewChat;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _db = Firestore.instance;
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    final String chatID = (widget.senderID.compareTo(widget.receiverID) > 0)
        ? widget.senderID + widget.receiverID
        : widget.receiverID + widget.senderID;

    if (widget.isNewChat) {
      final WriteBatch batch = _db.batch();

      final DocumentReference userChats =
          _db.collection('chats').document(chatID);
      batch.setData(
        userChats,
        {
          'senderID': widget.senderID,
          'requestedChat': true,
          'receiverID': widget.receiverID,
          'primaryChat': false,
          'messageAllowed': false,
          'blocked': false,
          'blockedBy': null,
        },
      );
      _getUserName().then((senderUserName) {
        CollectionReference chatsList =
            _db.collection('users/${widget.senderID}/chats_list');
        chatsList.add(
          {
            'username': senderUserName,
            'receiverID': widget.receiverID,
            'blocked': false,
            'blockedBy': null,
            'mute': false,
          },
        );

        chatsList = _db.collection('users/${widget.receiverID}/chats_list');
        chatsList.add(
          {
            'username': senderUserName,
            'receiverID': widget.senderID,
            'blocked': false,
            'blockedBy': null,
            'mute': false,
          },
        );
      });

      batch.commit();
    }

    final Map<String, Object> message = {
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': widget.senderID,
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

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
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
