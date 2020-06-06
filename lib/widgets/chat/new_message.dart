import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/models/contact.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/models/user.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({
    this.message,
    this.isNewChat,
  });

  Message message;
  final bool isNewChat;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage>
    with SingleTickerProviderStateMixin {
  final _db = Firestore.instance;
  TextEditingController _controller;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

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

    if (widget.message != null && widget.message.replyTo == null) {
      widget.message.text = _controller.text;
      widget.message.isEdited = true;
      chatsBloc.updateMessage(widget.message);
      widget.message = null;
    } else if (widget.message != null && widget.message.replyTo != null) {
      final Message message = Message(
        replyTo: widget.message.replyTo,
        text: _controller.text,
        createdAt: Timestamp.now(),
        userId: sender.uid,
      );
      chatsBloc.sendMessage(message);
      widget.message = null;
    } else {
      final Message message = Message(
        text: _controller.text,
        createdAt: Timestamp.now(),
        userId: sender.uid,
      );
      chatsBloc.sendMessage(message);
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message != null) {
      _controller.text = widget.message.text;
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Container(
            // margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                constraints.maxWidth * 0.06,
              ),
//            color: Colors.blueGrey[50],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.message != null)
                  Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      title: Text('Replying to: '),
                      subtitle: Text(
                        widget.message.replyTo,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.sentiment_satisfied),
                      onPressed: _controller.text.trim().isEmpty ? null : () {},
                    ),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.orange,
                        enableSuggestions: true,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          paste: true,
                          cut: true,
                          selectAll: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(fontSize: 16.0),
                        autocorrect: true,
                        maxLines: 5,
                        minLines: 1,
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: null,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: _controller.text.trim().isNotEmpty
                            ? Colors.blueAccent[100]
                            : null,
                      ),
                      onPressed:
                          _controller.text.trim().isEmpty ? null : _sendMessage,
                    )
                  ],
                ),
              ],
            )),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
