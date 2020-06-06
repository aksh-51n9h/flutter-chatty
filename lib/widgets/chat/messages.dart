import 'dart:math';

import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:chatty/widgets/chat/message_bubble.dart';
import 'package:chatty/widgets/extras/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MessageEditOptions { reply, edit, copy, delete, info, none }

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: 0.0)
      ..addListener(() {
        //todo: add scroll listener
      });
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

                return MessageThreadEditOptionsHolder(message: message);
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
    _controller.dispose();
    super.dispose();
  }
}

class MessageThreadEditOptionsHolder extends StatelessWidget {
  const MessageThreadEditOptionsHolder({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MessageEditOptions>(
      initialValue: MessageEditOptions.none,
      itemBuilder: (ctx) => _buildEditOptions(context),
      onSelected: (selectedItem) =>
          _onEditOptionSelected(context, selectedItem),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: MessageBubble(message),
    );
  }

  void _onEditOptionSelected(
      BuildContext context, MessageEditOptions selectedItem) {
    switch (selectedItem) {
      case MessageEditOptions.info:
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          context: context,
          builder: (ctx) {
            return Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Text(
                      message.text,
                      softWrap: true,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
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
        BlocProvider.of<ChatsBloc>(context).deleteMessage(message);
        break;

      case MessageEditOptions.edit:
        BlocProvider.of<ChatsBloc>(context)
            .messageEditStreamController
            .sink
            .add(message);
        break;

      case MessageEditOptions.reply:
        final Message newMessage = Message(replyTo: message.text);
        BlocProvider.of<ChatsBloc>(context)
            .messageEditStreamController
            .sink
            .add(newMessage);
        break;
      default:
        break;
    }
  }

  List<PopupMenuEntry<MessageEditOptions>> _buildEditOptions(
      BuildContext context) {
    return <PopupMenuEntry<MessageEditOptions>>[
      _buildEditOption(Icons.reply, 'Reply', MessageEditOptions.reply),
      if (BlocProvider.of<ChatsBloc>(context)
          .isCurrentUser(otherId: message.userId))
        _buildEditOption(Icons.edit, 'Edit', MessageEditOptions.edit),
      _buildEditOption(Icons.content_copy, 'Copy', MessageEditOptions.copy),
      if (BlocProvider.of<ChatsBloc>(context)
          .isCurrentUser(otherId: message.userId))
        _buildEditOption(Icons.delete, 'Delete', MessageEditOptions.delete),
      _buildEditOption(Icons.info, 'Info', MessageEditOptions.info),
    ];
  }

  PopupMenuItem<MessageEditOptions> _buildEditOption(
      IconData icon, String label, MessageEditOptions value) {
    return PopupMenuItem(
      value: value,
      child: FlatButton.icon(
        onPressed: null,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class ClipRThread extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double chatRadius = 4;
    final Path path = Path();
    path.lineTo(0.0, chatRadius);
    final r = chatRadius;
    final angle = 0.785;

    path.conicTo(
      r - r * sin(angle),
      r + r * cos(angle),
      r - r * sin(angle * 0.5),
      r - r * cos(angle * 0.5),
      1,
    );

    final moveIn = 2 * r;
    path.lineTo(moveIn, r * tan(angle));
    path.lineTo(moveIn, size.height - chatRadius);

    path.conicTo(
      moveIn + r - r * cos(angle),
      size.height - r + r * sin(angle),
      moveIn + r,
      size.height,
      1,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
