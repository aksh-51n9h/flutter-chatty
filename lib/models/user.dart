import 'package:flutter/material.dart';

class User {
  User({
    @required this.fullname,
    @required this.username,
    @required this.uid,
    @required this.email,
    @required this.imageUrl,
  });

  final String fullname;
  final String username;
  final String uid;
  final String email;
  final String imageUrl;

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
