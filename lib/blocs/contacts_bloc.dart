import 'dart:async';

import 'package:chatty/models/user.dart';

import '../models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsBloc {
  final Firestore _firestore = Firestore.instance;
  final User user;
  final StreamController<List<Contact>> _contactsStreamController =
      StreamController<List<Contact>>();
  // final List<Contact> allContacts;

  ContactsBloc(this.user);

  Stream<QuerySnapshot> get contactsStream =>
      _firestore.collection('users').document('${user.uid}').collection('chats_list').snapshots();
}
