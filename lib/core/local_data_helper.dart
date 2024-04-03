// local data helper with shared preferences

import 'package:shared_preferences/shared_preferences.dart';

class LocalDataHelper {
  // setuser token
  static Future<void> setUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // get user token
  static Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // set user mobile number
  static Future<void> setUserMobile(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', mobile);
  }

  // get user mobile number
  static Future<String> getUserMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobile') ?? '';
  }

  // set user password
  static Future<void> setUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  // get user password
  static Future<String> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password') ?? '';
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('mobile');
    await prefs.remove('password');
    // await DatabaseService.instance.deleteUserData();
  }
}
