import 'package:chatty/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactsBloc {
  final Firestore _firestore = Firestore.instance;
  final String uid;

  ContactsBloc(this.uid);

  Stream<QuerySnapshot> get contactsStream =>
      _firestore.collection('users').document(uid).collection('chats_list').snapshots();
}
