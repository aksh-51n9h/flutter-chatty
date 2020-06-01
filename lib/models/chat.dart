import 'package:chatty/models/contact.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class Chat {
  const Chat({
    @required this.sender,
    @required this.receiver,
  });

  final User sender;
  final Contact receiver;

  String get chatID => sender.uid.compareTo(receiver.receiverID) > 0
      ? sender.uid + receiver.receiverID
      : receiver.receiverID + sender.uid;
}
