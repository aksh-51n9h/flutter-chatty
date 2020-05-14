import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String fullName, String email, String username,
      String password, File userImage, bool isLogin, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final StorageReference ref = FirebaseStorage.instance
            .ref()
            .child('users_images')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(userImage).onComplete;

        final imageUrl = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData(
          {
            'fullname': fullName,
            'username': username,
            'email': email,
            'imageUrl': imageUrl,
          },
        );
      }
    } on PlatformException catch (error) {
      var message = "An error occured, please check your credentials!";

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
