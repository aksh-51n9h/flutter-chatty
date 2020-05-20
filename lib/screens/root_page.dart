import 'package:chatty/utils/utils.dart';
import 'package:flutter/material.dart';

import '../provider/authentication/auth.dart';
import 'all_chats.dart';
import 'auth_screen.dart';

class RootPage extends StatefulWidget {
  RootPage(this.auth);

  final Auth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      getUsername().then((username) {
        setState(() {
          if (user != null) {
            _userId = user?.uid;
            _username = username;
          }
          _authStatus = user?.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchOutCurve: Curves.easeInBack,
      switchInCurve: Curves.easeIn,
      child: _authStatus == AuthStatus.LOGGED_IN
          ? AllChats(
              auth: widget.auth,
              username: "ak__",
              logoutCallback: logoutCallback,
            )
          : AuthScreen(
              auth: widget.auth,
              loginCallback: loginCallback,
            ),
    );

    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return AuthScreen(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return AllChats(
            username: _username,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }

  void loginCallback(String username) {
    print('logincallback called');
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _username = username;
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
