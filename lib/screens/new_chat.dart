import 'package:chatty/models/user.dart';
import 'package:chatty/screens/chat_screen.dart';
import 'package:chatty/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  NewChat(this.allChats);

  final List<DocumentSnapshot> allChats;

  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isChatExist(User user) {
    for (int index = 0; index < widget.allChats.length; index++) {
      if (widget.allChats[index]['receiverID'].compareTo(user.uid) == 0) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
      ),
      body: FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (ctx, userData) {
          if (userData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final User sender = userData.data;

          return StreamBuilder<QuerySnapshot>(
            stream: _db.collection('users').snapshots(),
            builder: (ctx, availableUsersSnapshot) {
              if (availableUsersSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final List<DocumentSnapshot> availableUser =
                  availableUsersSnapshot.data.documents;

              return ListView.builder(itemBuilder: (ctx, index) {
                final user = availableUser[index];
                final User receiver = User(
                  fullname: user['fullname'],
                  username: user['username'],
                  uid: user['uid'],
                  email: user['email'],
                  imageUrl: user['imageUrl'],
                );

                if ((user.documentID.compareTo(sender.uid) != 0) &&
                    _isChatExist(receiver)) {
                  return ListTile(
                    title: Text(receiver.username),
                    subtitle: Text(receiver.fullname),
                    onTap: () {
                      return Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return ChatScreen(
                              sender: sender,
                              receiver: receiver,
                              isNewChat: true,
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return SizedBox();
              });
            },
          );
        },
      ),
    );
  }
}
