import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:chatty/widgets/chat/message_bubble.dart';
import 'package:chatty/widgets/extras/waiting.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Message>>(
        stream: BlocProvider.of<ChatsBloc>(context).messagesStream,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final List<Message> messages = snapshot.data;
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) {
                final Message message = messages[index];

                return MessageBubble(message);
              },
              itemCount: snapshot.data.length,
            );
          }

          return Waiting();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
