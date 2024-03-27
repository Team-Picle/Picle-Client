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
        throw Exception('Failed to load feeds');
      }
    } catch (error) {
      print('Error fetching feeds: $error');
    }
  }

  Future<void> fetchAllFeeds({
    required userId,
  }) async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['getAllFeeds']!());
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> responseData = responseBody['data'];

      if (response.statusCode == 200) {
        allFeeds = responseData.map((data) => Feed.fromJson(data)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load feeds');
      }
    } catch (error) {
      print('Error fetching feeds: $error');
    }
  }
}
