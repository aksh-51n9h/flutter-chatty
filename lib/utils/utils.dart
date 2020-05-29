import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> getCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();

  return User(
    fullname: prefs.getString('fullname'),
    username: prefs.getString('username'),
    uid: prefs.getString('uid'),
    email: prefs.getString('email'),
    imageUrl: prefs.getString('imageUrl'),
  );
}
