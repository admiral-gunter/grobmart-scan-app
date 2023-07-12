import 'package:shared_preferences/shared_preferences.dart';

class SharedToken {
  static Future<String?> tokenGetter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future tokenSetter(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}
