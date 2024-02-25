import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picle/models/user_challenge_model.dart';

class UserChallengeProvider extends ChangeNotifier {
  List<UserChallenge> userChallengeList = [];

  void fetchUserChallengeList() async {
    final response =
        await rootBundle.loadString('lib/data/user_challenge_list.json');
    final data = json.decode(response);

    if (data['code'] == 200) {
      userChallengeList = [
        for (var userChallenge in data['data'])
          UserChallenge.fromJson(userChallenge)
      ];
    } else {
      userChallengeList = [];
      throw Exception('Fail to load date');
    }
    notifyListeners();
  }
}
