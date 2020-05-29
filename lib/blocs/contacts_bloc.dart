import 'dart:async';

import '../models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsBloc {
  final Firestore _firestore = Firestore.instance;
  final String uid;
  final StreamController<List<Contact>> _contactsStreamController =
      StreamController<List<Contact>>();
  // final List<Contact> allContacts;

  ContactsBloc(this.uid);

  Stream<QuerySnapshot> get contactsStream => _firestore
      .collection('users')
      .document(uid)
      .collection('chats_list')
      .snapshots();
}
