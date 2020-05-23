import 'package:flutter/material.dart';

import '../models/user.dart';

class Chat {
  const Chat({
    @required this.sender,
    @required this.receiver,
  });

  final String sender;
  final String receiver;

  String get chatID => sender.compareTo(receiver) > 0
      ? sender + receiver
      : receiver + sender;
}
