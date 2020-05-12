import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.userId, this.timeStamp,
      {this.key});
  final String message;
  final bool isMe;
  final String userId;
  final Timestamp timeStamp;
  final Key key;

  final Radius radius = Radius.circular(12);

  @override
  Widget build(BuildContext context) {
    final timeStampWidget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        "${DateFormat.jm().format(timeStamp.toDate())}",
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
            //       margin: const EdgeInsets.only(left:4, top: 8),
            //       child: CircleAvatar(
            //         radius: 8,
            //         backgroundColor: Colors.amber,
            //       ),
            //     ),
            if (isMe)
              timeStampWidget,
            Container(
              // width: constraints.maxWidth * 0.625,
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.625,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.teal[700] : Colors.blueGrey[700],
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
                message,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
            if (!isMe)
              timeStampWidget
          ],
        );
      },
    );
  }
}
