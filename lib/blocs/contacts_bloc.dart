import 'dart:async';

import '../blocs/base_bloc.dart';
import '../models/user.dart';

import '../models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsBloc implements BaseBloc {
  final Firestore _firestore = Firestore.instance;
  final User user;
  final StreamController<List<Contact>> _contactsStreamController =
      StreamController<List<Contact>>();
  List<Contact> _allContacts = [];

  ContactsBloc(this.user) {
    _firestore
        .collection('users')
        .document('${user.uid}')
        .collection('chats_list')
        .snapshots()
        .map<List<Contact>>(
      (event) {
        List<Contact> tempContacts = [];
        event.documents.forEach(
          (element) => tempContacts.add(
            Contact.fromJson(element.data),
          ),
        );

        return tempContacts;
      },
    ).listen(
      (event) {
        _contactsSink.add(event);
      },
    );
  }

  StreamSink<List<Contact>> get _contactsSink => _contactsStreamController.sink;
  Stream<List<Contact>> get contactsStream => _contactsStreamController.stream;

  @override
  void dispose() {
    _contactsStreamController.close();
  }
}
