import 'package:chatty/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isChatExist(String userID, List<DocumentSnapshot> docRef) {
    for (int index = 0; index < docRef.length; index++) {
      print(userID);
      print(docRef[index]['receiverID']);

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
        future: _auth.currentUser(),
        builder: (ctx, userData) {
          if (userData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final senderID = userData.data.uid;

          return _buildChatsListStreamBuilder(senderID);
        },
      ),
    );
  }

  StreamBuilder<QuerySnapshot> _buildChatsListStreamBuilder(String senderID) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('users/$senderID/chats_list').snapshots(),
      builder: (ctx, chatsListSnapshot) {
        if (chatsListSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> chatsDocs =
            chatsListSnapshot.data.documents;

        return _buildUsersListStreamBuilder(senderID, chatsDocs);
      },
    );
  }

  StreamBuilder<QuerySnapshot> _buildUsersListStreamBuilder(
      String senderID, List<DocumentSnapshot> chatsDocs) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('users').snapshots(),
      builder: (ctx, chatsListSnapshot) {
        if (chatsListSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> usersList =
            chatsListSnapshot.data.documents;

        return _buildListView(usersList, senderID, chatsDocs);
      },
    );
  }

  ListView _buildListView(List<DocumentSnapshot> usersList, String senderID,
      List<DocumentSnapshot> chatsDocs) {
    return ListView.builder(
      itemCount: usersList.length,
      itemBuilder: (ctx, index) {
        if (usersList[index].documentID.compareTo(senderID) != 0 &&
            !_isChatExist(usersList[index].documentID, chatsDocs)) {
          return _buildListTile(usersList, index, senderID);
        }
        return SizedBox();
      },
    );
  }

  ListTile _buildListTile(
      List<DocumentSnapshot> usersList, int index, String senderID) {
    return ListTile(
      title: Text(usersList[index]['username']),
      onTap: () {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return ChatScreen(
                senderID: senderID,
                receiverID: usersList[index].documentID,
                receiverUserName: usersList[index]['username'],
                isNewChat: true,
              );
            },
          ),
        );
      },
    );
  }
}
