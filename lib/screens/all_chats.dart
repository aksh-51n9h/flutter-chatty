import '../screens/widgets/app_bar_title.dart';
import '../screens/widgets/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../screens/chat_screen.dart';
import '../screens/new_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {
  AllChats({this.username, this.auth, this.logoutCallback});

  final String username;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  List<DocumentSnapshot> _allChats;
  @override
  Widget build(BuildContext context) {
    return _buildSliver();
  }

  Widget _buildSliver() {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (ctx, userData) {
            if (userData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final user = userData.data;

            final User sender = User(
              fullname: user.displayName,
              email: user.email,
              imageUrl: user.photoUrl,
              uid: user.uid,
              username: widget.username,
            );

            final String senderID = sender.uid;
            final Firestore db = Firestore.instance;
            final CollectionReference chatsListCollectionRef =
                db.collection('users/$senderID/chats_list');

            return StreamBuilder<QuerySnapshot>(
              stream: chatsListCollectionRef.snapshots(),
              builder: (ctx, chatsListSnapshot) {
                if (chatsListSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var allChats = chatsListSnapshot.data.documents;
                _allChats = allChats;

                if (allChats.length == 0) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Hello ${sender.username} ,\nStart a new chat",
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                        _buildUserActions(),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.black,
                      pinned: true,
                      title: Text(widget.username),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: null,
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            dispose();
                            widget.auth.signOut();
                            widget.logoutCallback();
                          },
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext ctx, int index) {
                        final DocumentReference chatDocRef =
                            chatsListCollectionRef
                                .document(allChats[index].documentID);

                        var user = allChats[index];

                        final User receiver = User(
                          key: ValueKey(user['receiverID']),
                          fullname: user['fullname'],
                          username: user['username'],
                          uid: user['receiverID'],
                          email: user['email'],
                          imageUrl: user['imageUrl'],
                        );

                        return Container(
                          // margin: const EdgeInsets.symmetric(
                          //   horizontal: 16,
                          //   vertical: 4,
                          // ),
                          // color: Theme.of(context).primaryColor,
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3,
                                ),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: CircleAvatar(
                                backgroundColor: Colors.blueGrey[900],
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          new NetworkImage(receiver.imageUrl),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.panorama_fish_eye),
                            ),
                            title: Text(allChats[index]['username']),
                            subtitle: Text('last message'),
                            onTap: () {
                              return Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ChatScreen(
                                    sender: sender,
                                    receiver: receiver,
                                    isNewChat: false,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }, childCount: allChats.length),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => NewChat(_allChats),
            ),
          );
        },
        child: Icon(Icons.create),
      ),
    );
  }

  Widget _buildUserActions() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.settings),
            label: Text('Settings'),
            onPressed: () {},
          ),
          FlatButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text('Log out'),
            onPressed: () {
              dispose();
              widget.auth.signOut();
              widget.logoutCallback();
            },
          ),
        ],
      ),
    );
  }
}
