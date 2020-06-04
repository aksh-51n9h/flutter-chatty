import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:chatty/widgets/chat/message_bubble.dart';
import 'package:chatty/widgets/extras/waiting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MessageEditOptions { edit, copy, delete, info, none }

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
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (ctx, index) {
                final Message message = messages[index];

                return PopupMenuButton<MessageEditOptions>(
                  itemBuilder: (ctx) {
                    return <PopupMenuEntry<MessageEditOptions>>[
                      PopupMenuItem<MessageEditOptions>(
                        value: MessageEditOptions.edit,
                        child: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        value: MessageEditOptions.copy,
                        child: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.content_copy),
                          label: Text('Copy'),
                        ),
                      ),
                      if (BlocProvider.of<ChatsBloc>(context)
                          .isCurrentUser(otherId: message.userId))
                        PopupMenuItem(
                          value: MessageEditOptions.delete,
                          child: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.delete),
                            label: Text('Delete'),
                          ),
                        ),
                      PopupMenuItem(
                        value: MessageEditOptions.info,
                        child: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(Icons.info),
                          label: Text('Info'),
                        ),
                      ),
                    ];
                  },
                  onSelected: (selectedItem) {
                    switch (selectedItem) {
                      case MessageEditOptions.info:
                        print(message.toJson());
                        break;

                      case MessageEditOptions.copy:
                        Clipboard.setData(ClipboardData(text: message.text));
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Content copied'),
                          ),
                        );
                        break;

                      case MessageEditOptions.delete:
                        BlocProvider.of<ChatsBloc>(context)
                            .deleteMessage(message);
                        break;
                      default:
                        break;
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MessageBubble(message),
                );

                return GestureDetector(
                  onTap: () {},
                  child: MessageBubble(message),
                );
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
