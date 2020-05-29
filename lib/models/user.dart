import 'package:flutter/material.dart';

class User {
  User({
    @required this.fullname,
    @required this.username,
    @required this.uid,
    @required this.email,
    this.imageUrl,
  });

  String fullname;
  String username;
  final String uid;
  String email;
  String imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'fullname': this.fullname,
      'username': this.username,
      'email': this.email,
      'imageUrl': this.imageUrl,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      uid: json['uid'],
      fullname: json['fullname'],
      email: json['email'],
      username: json['username'],
      imageUrl: json['imageUrl'],
    );
  }
}
