import 'dart:io';

import 'package:chatty/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../provider/authentication/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///This is authentication screen.
class AuthScreen extends StatefulWidget {
  AuthScreen({this.auth, this.loginCallback});

  final Auth auth;
  final Function loginCallback;
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ///Holds laoding state of the authentication process. Default value is [false].
  bool _isLoading = false;

  void _submitAuthForm(String fullname, String email, String username,
      String password, bool isLogin, BuildContext ctx) async {
    final _auth = widget.auth;
    FirebaseUser user;
    try {
      ///As authentication process starts [_isLoading] is set to 'true'.
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        user = await _auth.signIn(email, password);

        

        final String userID = user.uid;
        final DocumentReference userDocs =
            Firestore.instance.collection('users').document(userID);

        userDocs.get().then((user) {
          final userData = user.data;

          final User sender = User(
            fullname: userData['fullname'],
            username: userData['username'],
            uid: userID,
            email: userData['email'],
            imageUrl: userData['imageUrl'],
          );

          _saveUserLocal(sender);
          widget.loginCallback(sender.username);
        });
      } else {
        user = await _auth.signUp(email, password);

//        final StorageReference ref = FirebaseStorage.instance
//            .ref()
//            .child('users_images')
//            .child(user.uid + '.jpg');
//
//        await ref.putFile(userImage).onComplete;
//
//        final imageUrl = await ref.getDownloadURL();

//        final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
//        userUpdateInfo.displayName = fullName;
//        userUpdateInfo.photoUrl = imageUrl;
//
//        try {
//          user.updateProfile(userUpdateInfo);
//        } catch (error) {
//          print(error);
//        }

        await Firestore.instance.collection('users').document(user.uid).setData(
          {
            'fullname': fullname,
            'username': username,
            'email': email,
//            'imageUrl': imageUrl,
          },
        );

        final User sender = User(
          fullname: fullname,
          username: username,
          email: email,
          uid: user.uid,
//          imageUrl: imageUrl,
        );

        _saveUserLocal(sender);
      }

      if (user.uid.length > 0 && user.uid != null) {
        widget.loginCallback(username);
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

  void _saveUserLocal(User sender) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    sender.toJson().forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
