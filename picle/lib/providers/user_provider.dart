import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel user = UserModel(
    id: 0,
    nickname: '',
    profileImage: '',
  );

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

      print(responseBody);

      Map<String, dynamic> data = responseBody['data'];
      user = UserModel.fromJson(data);
    } catch (error) {
      print('[ERROR] registerUser: $error');
    }
    notifyListeners();
  }
}
