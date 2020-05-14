import 'package:chatty/screens/chat_screen.dart';
import 'package:chatty/screens/new_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('All Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, userData) {
          if (userData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final String userId = userData.data.uid;
          final Firestore db = Firestore.instance;
          final CollectionReference chatsListCollectionRef =
              db.collection('users/$userId/chats_list');

          return StreamBuilder<QuerySnapshot>(
            stream: chatsListCollectionRef.snapshots(),
            builder: (ctx, chatsListSnapshot) {
              if (chatsListSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<DocumentSnapshot> userDocs =
                  chatsListSnapshot.data.documents;

              return ListView.builder(
                itemCount: userDocs.length,
                itemBuilder: (ctx, index) {
                  final chatDocRef = chatsListCollectionRef
                      .document(userDocs[index].documentID);

                  return Container(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey[900],
                        child: Image.network(
                          userDocs[index]['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(userDocs[index]['username']),
                      subtitle: Text('last message'),
                      trailing: IconButton(
                        icon: Icon(userDocs[index]['mute']
                            ? Icons.volume_off
                            : Icons.volume_down),
                        color: userDocs[index]['mute']
                            ? Colors.white
                            : Colors.grey,
                        onPressed: () {
                          bool mute = userDocs[index]['mute'];

                          try {
                            chatDocRef.updateData({
                              'mute': !mute,
                            });
                          } catch (error) {
                            print(error);
                          }
                        },
                      ),
                      onTap: () {
                        return Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ChatScreen(
                                userDocs[index]['receiverID'],
                                userDocs[index]['username']),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => NewChat(),
            ),
          );
        },
        child: Icon(Icons.create),
      ),
    );
  }
}
