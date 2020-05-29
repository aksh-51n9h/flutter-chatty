import 'package:shared_preferences/shared_preferences.dart';

///This class is used to manage account deatils of the user.
///Follows lazy singleton pattern.
class AccountManager {
  ///Holds an instance of [AccountManager].
  static AccountManager _instance;

  ///Holds an instance of [SharedPreferences].
  Future<SharedPreferences> _sharedPreferences;

  ///Internal constructor for initializing the class.
  AccountManager._internal() {
    _sharedPreferences = SharedPreferences.getInstance();
  }

  ///Returns an instance of this class i.e. [AccountManager].
  AccountManager getInstance() {
    ///Creates an instance if object is instantiated for the first time and also prevent from creating new object if the object is already being created.
    if (_instance == null) {
      return AccountManager._internal();
    }

    return _instance;
  }


  ///Checks whether user is using the app for first time.
  ///If the value is [true] then it is first time usage and
  ///if the value is [false] then it is not first time usage.
  bool _isFirstTime() {
    if (_sharedPreferences != null) {
      _sharedPreferences.then(
        (sharedPreferences) {
          return sharedPreferences.getBool('IS_FIRST_TIME') ?? true;
        },
        onError: (error) {
          return true;
        },
      );
    }
    return true;
  }
}
