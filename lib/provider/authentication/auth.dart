import 'dart:async';

import 'package:chatty/models/user.dart';
import 'package:chatty/provider/account_manager/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///This is an interface for [Auth] class.
abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  ///Holds an instance of [Auth].
  static Auth _instance;

  ///Holds an instance of [FirebaseAuth].
  Firestore _firestore;

  ///Holds an instance of [FirebaseAuth].
  FirebaseAuth _firebaseAuth;

  ///Holds an instance of [AccountManager].
  AccountManager _accountManager;

  ///This is an internal constructor used when [Auth] is instantiated.
  Auth._internal() {
    _firestore = Firestore.instance;
    _firebaseAuth = FirebaseAuth.instance;
    _accountManager = AccountManager.getInstance();
  }

  ///This function is used to provide an instance of a [Auth].
  static Auth getInstance() {
    if (_instance == null) {
      return Auth._internal();
    }

    return _instance;
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<bool> get isFirstTime async => _accountManager.isFirstTime();

  Future<User> saveUser(String uid) async {
    final DocumentSnapshot userDocs =
        await _firestore.collection('users').document(uid).get();

    final User user = User.fromJson(userDocs.data);
    _accountManager.saveUser(user);

    return user;
  }

  void createUser(User user) async {
    await _firestore.collection('users').document(user.uid).setData(
          user.toJson(),
        );

    _accountManager.saveUser(user);
  }

  Future<User> getUser() async {
    User user = await _accountManager.getUser();
    return user;
  }

  void initializeApp() => _accountManager.initializeApp();

  void clearUser() => _accountManager.clearUser();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
