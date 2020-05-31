import 'package:chatty/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user.dart';
import '../provider/authentication/auth.dart';

///This is authentication screen.
class AuthScreen extends StatefulWidget {
  AuthScreen({this.auth, this.loginCallback});

  final Auth auth;
  final Function(User user) loginCallback;

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
    User appUser;

    try {
      ///As authentication process starts [_isLoading] is set to 'true'.
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        user = await _auth.signIn(email, password);
        appUser = await _auth.saveUser(user.uid);
      } else {
        user = await _auth.signUp(email, password);

        final User newUser = User(
          fullname: fullname,
          username: username,
          email: email,
          uid: user.uid,
          imageUrl: null,
        );

        _auth.createUser(newUser);
        appUser = newUser;
      }

      if (user.uid.length > 0 && user.uid != null) {
        widget.loginCallback(appUser);
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
