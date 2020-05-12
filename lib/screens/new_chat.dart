import 'package:chatty/screens/all_chats.dart';
import 'package:chatty/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final Firestore db = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isChatExist(String userID, List<DocumentSnapshot> docRef) {
    for (int index = 0; index < docRef.length; index++) {
      if (docRef[index]['receiverID'].compareTo(userID) == 0) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('New Chat'),
      ),
      body: FutureBuilder<FirebaseUser>(
        future: auth.currentUser(),
        builder: (ctx, userData) {
          if (userData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userID = userData.data.uid;

          return _buildChatsListStreamBuilder(userID);
        },
      ),
    );
  }

  StreamBuilder<QuerySnapshot> _buildChatsListStreamBuilder(String userID) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('users/$userID/chats_list').snapshots(),
      builder: (ctx, chatsListSnapshot) {
        if (chatsListSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> chatsDocs =
            chatsListSnapshot.data.documents;

        return _buildUsersListStreamBuilder(userID, chatsDocs);
      },
    );
  }

  StreamBuilder<QuerySnapshot> _buildUsersListStreamBuilder(
      String userID, List<DocumentSnapshot> chatsDocs) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('users').snapshots(),
      builder: (ctx, chatsListSnapshot) {
        if (chatsListSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> usersList =
            chatsListSnapshot.data.documents;

        return _buildListView(usersList, userID, chatsDocs);
      },
    );
  }

  ListView _buildListView(List<DocumentSnapshot> usersList, String userID,
      List<DocumentSnapshot> chatsDocs) {
    return ListView.builder(
      itemCount: usersList.length,
      itemBuilder: (ctx, index) {
        if (usersList[index].documentID.compareTo(userID) != 0 &&
            !_isChatExist(userID, chatsDocs)) {
          return _buildListTile(usersList, index, userID);
        }
        return SizedBox();
      },
    );
  }

  ListTile _buildListTile(
      List<DocumentSnapshot> usersList, int index, String userID) {
    return ListTile(
      title: Text(usersList[index]['username']),
      onTap: () {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              final WriteBatch batch = db.batch();
              final String receiverID = usersList[index].documentID;
              final String newChatID = (userID.compareTo(receiverID) > 0)
                  ? userID + receiverID
                  : receiverID + userID;

              final DocumentReference userChats =
                  db.collection('chats').document(newChatID);
              batch.setData(
                userChats,
                {
                  'senderID': userID,
                  'receiverID': receiverID,
                  'messageAllowed': false,
                  'blocked': false,
                  'blockedBy': null,
                },
              );

              final CollectionReference chatsList =
                  db.collection('users/$userID/chats_list');
              chatsList.add(
                {
                  'username': usersList[index]['username'],
                  'receiverID': receiverID,
                  'blocked': false,
                  'blockedBy': null,
                  'mute': false,
                },
              );
              batch.commit();

              return ChatScreen(
                  usersList[index].documentID, usersList[index]['username']);
            },
          ),
        );
      },
    );
  }
}
