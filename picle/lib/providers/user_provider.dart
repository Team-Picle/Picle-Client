import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/api_path.dart';
import 'package:picle/constants/index.dart';
import 'package:picle/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  int userId = -1;
  String nickname = '';
  String profileImage = '';
  String socialPlatform = '';
  bool isDisposed = false;

  UserProvider() {
    // registerUser();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  Future<void> registerUser({
    clientKey,
    nickname,
    profileImage,
    socialPlatform,
  }) async {
    try {
      final jsonData = {
        'clientKey': clientKey,
        'nickname': nickname,
        'profileImage': profileImage,
        'socialPlatform': socialPlatform,
      };
      final uri = Uri.http(serverEndpoint, apiPath['registerUser']!());

      final requestBody = json.encode(jsonData);
      final response = await http.post(
        uri,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      print(responseBody);

      if (responseBody['data'] != null) {
        Map<String, dynamic> data = responseBody['data'];
        userId = UserModel.fromJson(data).id;
        nickname = UserModel.fromJson(data).nickname;
        profileImage = UserModel.fromJson(data).profileImage;

        notifyListeners();
      }
    } catch (error) {
      print('[ERROR] registerUser: $error');
    }
  }
}
