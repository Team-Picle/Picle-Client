import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/api_path.dart';
import 'package:picle/models/feed_model.dart';

class FeedProvider extends ChangeNotifier {
  List<Feed> myFeeds = [];
  List<Feed> allFeeds = [];
  bool isDisposed = false;

  FeedProvider(userId) {
    fetchMyFeeds(
      userId: userId,
    );
    fetchAllFeeds(
      userId: userId,
    );
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

  Future<void> fetchMyFeeds({
    required userId,
  }) async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['getMyFeeds']!(userId));
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      final List<dynamic> responseData = responseBody['data'];

      if (response.statusCode == 200) {
        myFeeds = responseData.map((data) => Feed.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load my feeds');
      }
    } catch (error) {
      print('[ERROR] MY FEED fetch: $error');
    }
  }

  Future<void> fetchAllFeeds({
    required userId,
  }) async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['getAllFeeds']!(userId));
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      final List<dynamic> responseData = responseBody['data'];

      if (response.statusCode == 200) {
        allFeeds = responseData.map((data) => Feed.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load all feeds');
      }
    } catch (error) {
      print('[ERROR] ALL FEED fetch: $error');
    }
  }

  Future<void> like({required userId, required routineId}) async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['like']!(userId, routineId));
      final response =
          await http.post(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final idx = allFeeds.indexWhere((f) => f.routineId == routineId);
        allFeeds[idx].isLike = true;

        notifyListeners();
      } else {
        print(response);
        throw Exception('Failed to feed like');
      }
    } catch (error) {
      print('좋아요 실패: $error');
    }
  }

  Future<void> unlike({required userId, required routineId}) async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['like']!(userId, routineId));
      final response =
          await http.delete(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final idx = allFeeds.indexWhere((f) => f.routineId == routineId);
        allFeeds[idx].isLike = false;

        notifyListeners();
      } else {
        print(response);
        throw Exception('Failed to feed unlike');
      }
    } catch (error) {
      print('좋아요 취소 실패: $error');
    }
  }
}
