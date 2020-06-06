import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String userId;
  String text;
  Timestamp createdAt;
  bool isEdited;
  final String replyTo;

  Message({
    this.id,
    this.userId,
    this.text,
    this.createdAt,
    this.isEdited = false,
    this.replyTo,
  });

  factory Message.fromJson(String id, Map<String, dynamic> json) {
    return Message(
      id: id,
      userId: json['userId'],
      text: json['text'] ?? null,
      createdAt: json['createdAt'] ?? null,
      isEdited: json['isEdited'] ?? false,
      replyTo: json['replyTo'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'userId': this.userId,
      'text': this.text,
      'createdAt': this.createdAt,
      'isEdited': this.isEdited,
      'replyTo': this.replyTo,
    };
  }
}
