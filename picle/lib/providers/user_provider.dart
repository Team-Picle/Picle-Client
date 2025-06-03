import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:picle/constants/index.dart';
import 'package:picle/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel user = UserModel(
    id: 0,
    nickname: 'PICLE',
    profileImage: '',
  );

  int get userId => user.id;

  Future<void> registerUser({
    required clientKey,
    nickname,
    profileImage,
    socialPlatform,
  }) async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['registerUser']!());

      final jsonData = {
        'clientKey': clientKey,
        'nickname': nickname,
        'profileImage': profileImage,
        'socialPlatform': socialPlatform,
      };
      final requestBody = json.encode(jsonData);
      final response = await http.post(
        uri,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      Map<String, dynamic> data = responseBody['data'];
      user = UserModel.fromJson(data);
    } catch (error) {
      throw Exception('registerUser 중 에러 발생: $error');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final platform = prefs.getString('login_platform');

    if (platform == 'KAKAO') {
      await logoutKakao();
    } else if (platform == 'GOOGLE') {
      await logoutGoogle();
    }

    await prefs.remove('login_platform');
  }

  Future<void> logoutGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (error) {
      print('구글 로그아웃 실패: $error');
    }
  }

  Future<void> logoutKakao() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('카카오 로그아웃 실패: $error');
    }
  }
}
