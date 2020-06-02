import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String userId;
  final String text;
  final Timestamp createdAt;

  const Message({this.userId, this.text, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        userId: json['userId'],
        text: json['text'],
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': this.userId,
      'text': this.text,
      'createdAt': this.createdAt,
    };
  }
}
