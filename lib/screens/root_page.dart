import 'package:chatty/provider/account_manager/account.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../provider/authentication/auth.dart';
import '../screens/contacts_list.dart';
import 'auth_screen.dart';

///This widget is the root page of the app.
///It decides whether navigate to [contact_list.dart]
///or [auth_form.dart] based on authentication status.
class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final auth = Auth.getInstance();

  ///Authentication status of the user. Default value is [AuthStatus.NOT_DETERMINED].
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  ///This is used to store an instance of logged in user.
  User _user;

  @override
  void initState() {
    super.initState();

    ///If user has previously logged in then get the user information and
    ///set [_user] and [_authStatus].
    initializeApp();
  }

  void initializeApp() async {
    bool isFirstUsage = await auth.isFirstTime;

    if (await auth.isFirstTime) {
      auth.initializeApp();
    }

    if (isFirstUsage) {
      setState(() {
        _user = null;
        _authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    } else {
      auth.getUser().then(
        (user) {
          setState(() {
            _user = user;
            _authStatus = AuthStatus.LOGGED_IN;
          });
        },
      );
    }
  }

  ///Returns screen based on [_authStatus].
  ///If [_authStatus] is 'AuthStatus.LOGGED_IN' then it will switch to [ContactList].
  ///If [_authStatus] is 'AuthStatus.NOT_LOGGED_IN' then it will switch to [AuthScreen].
  ///[AnimatedSwitcher] is used to provide switch transition between two screens.
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchOutCurve: Curves.easeInBack,
      switchInCurve: Curves.easeIn,
      child: _authStatus == AuthStatus.LOGGED_IN
          ? ContactList(_user, auth, logoutCallback)
          : _authStatus == AuthStatus.NOT_LOGGED_IN
              ? AuthScreen(
                  auth: auth,
                  loginCallback: loginCallback,
                )
              : buildWaitingScreen(),
    );
  }

  ///This function is called when user logged in and
  ///set [_authStatus] value to 'AuthStatus.LOGGED_IN'.
  void loginCallback(User user) {
    if (user != null) {
      setState(() {
        _user = user;
        _authStatus = AuthStatus.LOGGED_IN;
      });
    }
  }

  ///This function is called when user log out and
  ///set [_authStatus] value to 'AuthStatus.NOT_LOGGED_IN'.
  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _user = null;
    });

    auth.clearUser();
  }

  Widget buildWaitingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
