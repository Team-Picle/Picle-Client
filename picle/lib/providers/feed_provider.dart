import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/api_path.dart';
import 'package:picle/models/feed_model.dart';

var userId = 1;

class FeedProvider extends ChangeNotifier {
  List<Feed> myFeeds = [];
  List<Feed> allFeeds = [];
  bool isDisposed = false;

  FeedProvider() {
    fetchMyFeeds();
    fetchAllFeeds();
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

  Future<void> fetchMyFeeds() async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['getMyFeeds']!(userId));
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      myFeeds = [for (var feed in responseBody['data']) Feed.fromJson(feed)];
      print(responseBody);

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> fetchAllFeeds() async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['getAllFeeds']!());
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      allFeeds = [for (var feed in responseBody['data']) Feed.fromJson(feed)];
      print(responseBody);

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
