import 'dart:async';

import 'package:chatty/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';
import 'base_bloc.dart';

class ChatsBloc implements BaseBloc {
  ChatsBloc(this.chat) {
    _firestore
        .collection('chats/${chat.chatID}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      _messagesSink
          .add(event.documents.map((e) => Message.fromJson(e.data)).toList());
    });
  }

  final Chat chat;
  final Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _messages = [];

  final _messagesStreamController = StreamController<List<Message>>();

  StreamSink<List<Message>> get _messagesSink => _messagesStreamController.sink;

  Stream<List<Message>> get messagesStream => _messagesStreamController.stream;

  @override
  void dispose() {
    _messagesStreamController.close();
  }
}

