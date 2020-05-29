import '../screens/contacts_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../provider/authentication/auth.dart';
import 'auth_screen.dart';

///This widget is the root page of the app.
///It decides whether navigate to [contact_list.dart] or [auth_form.dart].
class RootPage extends StatefulWidget {
  RootPage(this.auth);

  final Auth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isFirstTime = true;

  ///Authentication status of the user. Default value is [AAuthStatus.NOT_DETERMINED].
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  ///This is used to store an instance of logged in user.
  FirebaseUser _user;

  String _userId = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _user = user;
        }
        _authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    }).catchError((error) {
      print(error);
    }).whenComplete(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchOutCurve: Curves.easeInBack,
      switchInCurve: Curves.easeIn,
      child: _authStatus == AuthStatus.LOGGED_IN
          ? ContactList(_userId, widget.auth, logoutCallback)
          : AuthScreen(
              auth: widget.auth,
              loginCallback: loginCallback,
            ),
    );
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      _authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _username = '';
    });
  }

  Widget buildWaitingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
