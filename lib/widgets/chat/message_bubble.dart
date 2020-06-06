import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final BuildContext context;

  MessageBubble(this.message, {this.context});

  final Radius radius = Radius.circular(8);

  @override
  Widget build(BuildContext context) {
    final bool isMe = BlocProvider.of<ChatsBloc>(
            this.context == null ? context : this.context)
        .isCurrentUser(otherId: message.userId);

    final String time = DateFormat.jm().format(message.createdAt.toDate());

    final String day = DateFormat.E().format(message.createdAt.toDate());

    final String timeStamp =
        isMe ? day + " \u2022 " + time : time + " \u2022 " + day;

    final timeStampWidget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        timeStamp,
        style:
            Theme.of(context).textTheme.caption.apply(color: Colors.grey[600]),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            if (isMe) timeStampWidget,
            Container(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.625,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? Theme
                      .of(context)
                      .accentColor
                      : Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(8),
//                  borderRadius: isMe
//                      ? BorderRadius.only(
//                          topLeft: radius, topRight: radius, bottomLeft: radius)
//                      : BorderRadius.only(
//                          topRight: radius,
//                          bottomLeft: radius,
//                          bottomRight: radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.isEdited)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Edited',
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    if (message.replyTo != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColorLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text('Replied to: '),
                          subtitle: Text(
                            message.replyTo,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    Container(
                      padding:
                      EdgeInsets.only(top: message.replyTo != null ? 8 : 0),
                      child: Text(
                        message.text,
                        style: Theme
                            .of(context)
                            .brightness == Brightness.light
                            ? TextStyle(fontSize: 16.0, color: Colors.white)
                            : TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                )),
            if (!isMe) timeStampWidget
          ],
        );
      },
    );
  }
}
