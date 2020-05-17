import 'package:flutter/material.dart';

import '../models/user.dart';

class Chat {
  const Chat({
    @required this.sender,
    @required this.receiver,
  });

  final User sender;
  final User receiver;

  String get chatID => sender.uid.compareTo(receiver.uid) > 0
      ? sender.uid + receiver.uid
      : receiver.uid + sender.uid;
}
