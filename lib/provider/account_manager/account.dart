import 'package:chatty/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///This class is used to manage account details of the user.
///Follows lazy singleton pattern.
class AccountManager {
  final String _IS_FIRST_TIME_TAG =  'IS_FIRST_TIME';

  ///Holds an instance of [AccountManager].
  static AccountManager _instance;

  ///Holds an instance of [SharedPreferences].
  SharedPreferences _sharedPreferences;

  ///Returns an instance of this class i.e. [AccountManager].
  static AccountManager getInstance() {
    ///Creates an instance if object is instantiated for the first time
    ///and also prevent from creating new object if the object is already being created.
    if (_instance == null) {
      return AccountManager();
    }

    return _instance;
  }

  ///Checks whether user is using the app for first time.
  ///If the value is [true] then it is first time usage and
  ///if the value is [false] then it is not first time usage.
  ///Default value is [true].
  Future<bool> isFirstTime() async{
    this._sharedPreferences = await SharedPreferences.getInstance();

    if (_sharedPreferences != null) {
      return _sharedPreferences.getBool(_IS_FIRST_TIME_TAG) ?? true;
    }
    return true;
  }

  void initializeApp() async{
    this._sharedPreferences = await SharedPreferences.getInstance();

    _sharedPreferences.setBool(_IS_FIRST_TIME_TAG, false);
  }

  void saveUser(User user) async{
    this._sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences != null) {
      user.toJson().forEach((key, value) {
        _sharedPreferences.setString(key, value);
      });
    }
  }

  Future<User> getUser() async {
    this._sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences != null) {
      return User(
        uid: _sharedPreferences.getString('uid') ?? '',
        fullname: _sharedPreferences.getString('fullname') ?? '',
        username: _sharedPreferences.getString('username') ?? '',
        email: _sharedPreferences.getString('email') ?? '',
        imageUrl: _sharedPreferences.getString('imageUrl') ?? '',
      );
    }

    return null;
  }
}

class LocalUserSaveException implements Exception {
  final String errorMessage;

  LocalUserSaveException({@required this.errorMessage});
}
