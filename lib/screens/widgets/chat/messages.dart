import 'package:chatty/screens/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  Messages(this.toUserId);

  final String toUserId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final String userID = futureSnapshot.data.uid;
        final String chatID = (userID.compareTo(toUserId) > 0)
            ? userID + toUserId
            : toUserId + userID;

        return StreamBuilder(
          stream: Firestore.instance
              .collection(
                  'chats/$chatID/messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatsSnapshot) {
            if (chatsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final chatsDocs = chatsSnapshot.data.documents;

            return ListView.builder(
              reverse: true,
              itemCount: chatsDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatsDocs[index]['text'],
                chatsDocs[index]['userId'] == futureSnapshot.data.uid,
                chatsDocs[index]['userId'],
                chatsDocs[index]['createdAt'],
                key: ValueKey(chatsDocs[index].documentID),
              ),
            );
          },
        );
      },
    );
  }
}
