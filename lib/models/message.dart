import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String userId;
  final String text;
  final Timestamp createdAt;

  const Message({this.id, this.userId, this.text, this.createdAt});

  factory Message.fromJson(String id, Map<String, dynamic> json) {
    return Message(
      id: id,
      userId: json['userId'],
      text: json['text'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'userId': this.userId,
      'text': this.text,
      'createdAt': this.createdAt,
    };
  }
}
