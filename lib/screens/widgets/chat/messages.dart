import 'package:animations/animations.dart';
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
              .collection('chats/$chatID/messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatsSnapshot) {
            return PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation primaryAnimation,
                  Animation secondaryAnimation) {
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  child: child,
                );
              },
              child: chatsSnapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      reverse: true,
                      itemCount: chatsSnapshot.data.documents.length,
                      itemBuilder: (ctx, index) => MessageBubble(
                        chatsSnapshot.data.documents[index]['text'],
                        chatsSnapshot.data.documents[index]['userId'] ==
                            futureSnapshot.data.uid,
                        chatsSnapshot.data.documents[index]['userId'],
                        chatsSnapshot.data.documents[index]['createdAt'],
                        key: ValueKey(
                            chatsSnapshot.data.documents[index].documentID),
                      ),
                    ),
            );
            // if (chatsSnapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // }

            // final chatsDocs = chatsSnapshot.data.documents;

            // return ListView.builder(
            //   reverse: true,
            //   itemCount: chatsDocs.length,
            //   itemBuilder: (ctx, index) => MessageBubble(
            //     chatsDocs[index]['text'],
            //     chatsDocs[index]['userId'] == futureSnapshot.data.uid,
            //     chatsDocs[index]['userId'],
            //     chatsDocs[index]['createdAt'],
            //     key: ValueKey(chatsDocs[index].documentID),
            //   ),
            // );
          },
        );
      },
    );
  }
}

// PageTransitionSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 reverse: !_isLoggedIn,
//                 transitionBuilder: (
//                   Widget child,
//                   Animation<double> animation,
//                   Animation<double> secondaryAnimation,
//                 ) {
//                   return SharedAxisTransition(
//                     child: child,
//                     animation: animation,
//                     secondaryAnimation: secondaryAnimation,
//                     transitionType: _transitionType,
//                   );
//                 },
//                 child: _isLoggedIn ? _CoursePage() : _SignInPage(),
//               ),
