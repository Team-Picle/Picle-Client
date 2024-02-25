import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/routine_model.dart';

var userId = 1;

class RoutineProvider extends ChangeNotifier {
  List<Routine> previewList = [];
  List<Routine> routineList = [];

  String date = DateTime.now() //
      .toString()
      .split(' ')[0];

  RoutineProvider() {
    fetchPreviewList();
    fetchRoutineList();
  }

  void updateDate(selectedDate) {
    date = selectedDate.toString().split(' ')[0];
    notifyListeners();
  }

  Future<void> fetchPreviewList() async {
    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.https(
          serverEndpoint, apiPath['getPreviews']!(userId), queryParams);
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = json.decode(response.body);

      previewList = [
        for (Map<String, dynamic> routine in responseBody['data'])
          Routine.fromJson(routine)
      ];
    } catch (error) {
      // Toast message 보여주기 '미리보기를 불로오지 못 했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> fetchRoutineList() async {
    // final response = await rootBundle.loadString('lib/data/routine_list.json');
    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.https(
          serverEndpoint, apiPath['getRoutines']!(userId), queryParams);
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = json.decode(response.body);

      routineList = [
        for (Map<String, dynamic> routine in responseBody['data'])
          Routine.fromJson(routine)
      ];
    } catch (error) {
      // Toast message 보여주기 '루틴을 불러오지 못 했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> registerRoutine(content, imgUrl, time, startRepeatDate,
      repeatDays, destinationLongitude, destinationLatitude) async {
    try {
      final url = Uri.https(serverEndpoint, apiPath['createPreview']!(userId));
      final jsonData = {
        'content': content,
        'registrationImgUrl': imgUrl,
        'time': time,
        'startRepeatDate': startRepeatDate,
        'repeatDays': repeatDays,
        'destinationLongitude': destinationLongitude,
        'destinationLatitude': destinationLatitude
      };
      final requestBody = json.encode(jsonData);
      final response = await http.post(url,
          body: requestBody, headers: {'Content-Type': 'application/json'});

      final responseData = json.decode(response.body);
      Map<String, dynamic> data = responseData['data'];
      previewList = [...previewList, Routine.fromJson(data)];
    } catch (error) {
      // Toast message 보여주기 '루틴을 등록에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> addRoutine(userId, routineId) async {
    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.https(serverEndpoint,
          apiPath['createRoutine']!(userId, routineId), queryParams);
      final response =
          await http.post(uri, headers: {'Content-Type': 'application/json'});

      final responseData = json.decode(response.body);
      Map<String, dynamic> data = responseData['data'];
      routineList = [...routineList, Routine.fromJson(data)];
      previewList.removeWhere((preview) => preview.routineId == routineId);
    } catch (error) {
      // Toast message 보여주기 '루틴 추가에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }
}
