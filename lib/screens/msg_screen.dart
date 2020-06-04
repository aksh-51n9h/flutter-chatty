import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:chatty/widgets/chat/messages.dart';
import 'package:chatty/widgets/chat/new_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/chats_bloc.dart';
import '../models/chat.dart';

//todo:implement message bubble.
//todo:implement new message send.
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
    super.initState();
    _chatsBloc = ChatsBloc(widget.chat);
  }

  @override
  Widget build(BuildContext context) {
    print('building msg screen');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.receiver.username),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _chatsBloc.chatSettingsStream.listen((event) {
                print(event);
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (ctx) {
                    return Container(
                      child: ListView(
                        children: [
                          SwitchListTile(
                            value: event.primaryChat,
                            onChanged: null,
                            title: Text('Primary Chat'),
                          ),
                          SwitchListTile(
                            value: event.blocked,
                            onChanged: null,
                            title: Text('Blocked'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
            },
          ),
        ],
      ),
      body: BlocProvider(
        bloc: _chatsBloc,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              NewMessage(
                isNewChat: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatsBloc.dispose();
    super.dispose();
  }
}
