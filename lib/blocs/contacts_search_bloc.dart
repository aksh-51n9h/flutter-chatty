import 'dart:async';

import 'package:chatty/blocs/base_bloc.dart';
import 'package:chatty/blocs/contacts_bloc.dart';
import 'package:chatty/models/user.dart';

class ContactsSearchBloc implements BaseBloc {
  final _contactsSearchStream = StreamController<String>();
  final _contactsBloc = ContactsBloc(User());

  
  @override
  void dispose() {
    // TODO: implement dispose
  }
}
