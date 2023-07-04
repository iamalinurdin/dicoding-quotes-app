import 'package:quotes_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = 'state';
  final String userKey = 'user';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    
    return prefs.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));

    return prefs.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));

    return prefs.setBool(stateKey, false);
  }

  Future<dynamic> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));

    return prefs.setString(userKey, user.toJson());
  }
  
  Future<dynamic> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));

    return prefs.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = prefs.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }
}