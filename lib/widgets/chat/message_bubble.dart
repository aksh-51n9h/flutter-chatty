import 'package:chatty/blocs/chats_bloc.dart';
import 'package:chatty/models/message.dart';
import 'package:chatty/provider/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble(this.message);

  final Radius radius = Radius.circular(12);

  @override
  Widget build(BuildContext context) {
    final bool isMe = BlocProvider.of<ChatsBloc>(context)
            .chat
            .sender
            .uid
            .compareTo(message.userId) ==
        0;

    final timeStampWidget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        "${DateFormat.jm().format(message.createdAt.toDate())}",
        style:
            Theme.of(context).textTheme.caption.apply(color: Colors.grey[700]),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            // if (!isMe)
            //   Container(
            //       margin: const EdgeInsets.only(left:4, tosp: 8),
            //       child: CircleAvatar(
            //         radius: 8,
            //         backgroundColor: Colors.amber,
            //       ),
            //     ),
            if (isMe) timeStampWidget,
            Container(
              // width: constraints.maxWidth * 0.625,
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.625,
              ),
              decoration: BoxDecoration(
                color:
                isMe ? Theme
                    .of(context)
                    .accentColor : Colors.blueGrey[700],
                borderRadius: isMe
                    ? BorderRadius.only(
                    topLeft: radius, topRight: radius, bottomLeft: radius)
                    : BorderRadius.only(
                    topRight: radius,
                    bottomLeft: radius,
                    bottomRight: radius),
                // border: Border.all(
                //   color: isMe ? Colors.teal : Colors.blueGrey,
                //   width: 2
                // ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
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
            ),
            if (!isMe) timeStampWidget
          ],
        );
      },
    );
  }
}
