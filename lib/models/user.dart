import 'package:flutter/material.dart';

class User {
  User({
    this.key,
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
  final Key key;

  Map<String, Object> map() {
    return {
      'name': this.fullname,
      'username': this.username,
      'uid': this.uid,
      'email': this.email,
      'imageUrl': this.imageUrl,
    };
  }
}

