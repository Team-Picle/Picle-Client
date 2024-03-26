import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/api_path.dart';
import 'package:picle/models/feed_model.dart';

var userId = 1;

class FeedProvider extends ChangeNotifier {
  List<Feed> myFeeds = [];
  bool isDisposed = false;

  Future<void> fetchMyList(userId) async {
    await fetchMyFeeds();

    notifyListeners();
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
      if (response.statusCode == 200) {
        final List<dynamic> responseData = responseBody['data'];
        myFeeds = responseData.map((data) => Feed.fromJson(data)).toList();
        notifyListeners();
        print("리스트: $myFeeds");
      } else {
        throw Exception('Failed to load feeds');
      }
    } catch (error) {
      print('Error fetching feeds: $error');
    }
  }

  Future<void> fetchAllFeeds() async {
    try {
      final uri = Uri.http(serverEndpoint, apiPath['getAllFeeds']!());
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        myFeeds = responseData.map((data) => Feed.fromJson(data)).toList();
        notifyListeners();
        print("리스트: $myFeeds");
      } else {
        throw Exception('Failed to load feeds');
      }
    } catch (error) {
      print('Error fetching feeds: $error');
    }
  }
}
