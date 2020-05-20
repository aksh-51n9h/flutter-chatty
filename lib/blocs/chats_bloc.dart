import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat.dart';

class ChatsBloc {
  final Chat chat;
  ChatsBloc(this.chat) {
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
  Stream<QuerySnapshot> get messageListStream =>
      db.collection('chats/${chat.chatID}/messages').snapshots();

  StreamSink<List<DocumentSnapshot>> get messageListSink =>
      _messageListStreamController.sink;

  StreamSink<Chat> get sendMessageSink => _sendMessageStreamController.sink;

  _sendMessage(Chat message) {}

  void dispose() {
    _messageListStreamController.close();
    _sendMessageStreamController.close();
  }
}
