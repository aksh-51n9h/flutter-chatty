import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';
import 'package:flutter/material.dart';

class ChatsBloc {
  ChatsBloc(Chat chat) {
    db.collection('chats/${chat.chatID}/messages').snapshots().listen((event) {
      if (event.documents.isNotEmpty) {
        this._messages = event.documents;
        print(this._messages);
      }
    });

    _messageListStreamController.add(this._messages);

    _sendMessageStreamController.stream.listen(_sendMessage);
  }

  List<DocumentSnapshot> _messages;
  final Firestore db = Firestore.instance;

  final _messageListStreamController =
      StreamController<List<DocumentSnapshot>>();

  final _sendMessageStreamController = StreamController<Chat>();

  //getter
  Stream<List<DocumentSnapshot>> get messageListStream =>
      _messageListStreamController.stream;

  StreamSink<List<DocumentSnapshot>> get messageListSink =>
      _messageListStreamController.sink;

  StreamSink<Chat> get sendMessageSink => _sendMessageStreamController.sink;

  _sendMessage(Chat message) {}
}
