import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  final String userId;
  String text;
  Timestamp createdAt;
  bool isEdited;

  Message(
      {this.id, this.userId, this.text, this.createdAt, this.isEdited = false});

  factory Message.fromJson(String id, Map<String, dynamic> json) {
    return Message(
      id: id,
      userId: json['userId'],
      text: json['text'],
      createdAt: json['createdAt'],
      isEdited: json['isEdited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'userId': this.userId,
      'text': this.text,
      'createdAt': this.createdAt,
      'isEdited': this.isEdited,
    };
  }
}
