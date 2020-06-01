import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen(this.chat);

  final Chat chat;

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ChatsBloc _chatsBloc;

  @override
  void initState() {
    _chatsBloc = ChatsBloc(widget.chat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.receiver.username),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _chatsBloc.messagesStream,
        builder: (ctx, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: stream.data.length,
            reverse: true,
            itemBuilder: (ctx, index) {
              if(stream.data[index].userId.compareTo(widget.chat.sender.uid) == 0){
                return ListTile(
                title: Text(
                  stream.data[index].text,
                ),

                subtitle: Text('send'),
              );
              }

              return ListTile(
                title: Text(
                  stream.data[index].text,
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _chatsBloc.dispose();
    super.dispose();
  }
}
