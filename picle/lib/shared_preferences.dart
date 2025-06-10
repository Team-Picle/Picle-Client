import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginPlatform(String platform) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('login_platform', platform);
}
