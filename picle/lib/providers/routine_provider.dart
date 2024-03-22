import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/preview_model.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/notification.dart';

var userId = 1;

class RoutineProvider extends ChangeNotifier {
  List<Preview> previewList = [];
  List<Routine> uncheckRoutineList = [];
  List<Routine> checkRoutineList = [];

  RoutineProvider() {
    String today = DateTime.now() //
        .toString()
        .split(' ')[0];
    fetchRoutineList(today);
    fetchPreviewList(today);
  }

  Future<void> fetchPreviewList(date) async {
    final response = await rootBundle.loadString('lib/data/preview_list.json');
    final data = json.decode(response);

    if (data['code'] == 200) {
      List<int> routineIdList = [...uncheckRoutineList, ...checkRoutineList]
          .map((routine) => routine.routineIdentifier)
          .toList();
      previewList = [
        for (Map<String, dynamic> preview in data['data'])
          if (!routineIdList.contains(preview['routineId']))
            Preview.fromJson(preview)
      ];
    } else {
      previewList = [];
      throw Exception('Fail to load date');
    }

    // try {
    //   final queryParams = {
    //     'date': date,
    //   };
    //   final uri = Uri.https(
    //       serverEndpoint, apiPath['getPreviews']!(userId), queryParams);
    //   final response =
    //       await http.get(uri, headers: {'Content-Type': 'application/json'});
    //   final responseBody = json.decode(response.body);

    //   List<int> routineIdList =
    //       [...uncheckRoutineList, ...checkRoutineList].map((routine) => routine.routineIdentifier).toList();
    //   previewList = [
    //     for (Map<String, dynamic> preview in responseBody['data'])
    //       if (!routineIdList.contains(preview['routineId']))
    //         Preview.fromJson(preview)
    //   ];
    // } catch (error) {
    //   // Toast message 보여주기 '미리보기를 불로오지 못 했습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> fetchRoutineList(date) async {
    final response = await rootBundle.loadString('lib/data/routine_list.json');
    final data = json.decode(response);

    if (data['code'] == 200) {
      uncheckRoutineList = [
        for (Map<String, dynamic> routine in data['data'])
          if (routine['isCompleted'] == false) Routine.fromJson(routine),
      ];
      checkRoutineList = [
        for (Map<String, dynamic> routine in data['data'])
          if (routine['isCompleted'] == true) Routine.fromJson(routine),
      ];
    } else {
      throw Exception('Fail to load date');
    }

    // try {
    //   final queryParams = {
    //     'date': date,
    //   };
    //   final uri = Uri.https(
    //       serverEndpoint, apiPath['getRoutines']!(userId), queryParams);
    //   final response =
    //       await http.get(uri, headers: {'Content-Type': 'application/json'});
    //   final responseBody = json.decode(response.body);

    //   uncheckRoutineList = [
    //     for (Map<String, dynamic> routine in responseBody['data'])
    //       if (routine['isCompleted'] == false) Routine.fromJson(routine),
    //   ];
    //   checkRoutineList = [
    //     for (Map<String, dynamic> routine in responseBody['data'])
    //       if (routine['isCompleted'] == true) Routine.fromJson(routine),
    //   ];
    // } catch (error) {
    //   // Toast message 보여주기 '루틴을 불러오지 못 했습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> registerRoutine(
      {content,
      imgUrl,
      time,
      startRepeatDate,
      repeatDays,
      destinationLongitude,
      destinationLatitude}) async {
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
      previewList = [...previewList, Preview.fromJson(data)];
    } catch (error) {
      // Toast message 보여주기 '루틴을 등록에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  int id = 100;
  // api 연결 시에는 content param 삭제
  Future<void> addRoutine({userId, routineId, content, date, time}) async {
    Map<String, dynamic> data = {
      'userId': userId,
      'routineId': id,
      'routineIdentifier': routineId,
      'content': content,
      'registrationImgUrl': '',
      'date': date,
      'startRepeatDate': '',
      'repeatDays': [],
      'destinationLongitude': 0.0,
      'destinationLatitude': 0.0,
      'isCompleted': false,
      'isPreview': false,
      if (time != null) 'time': time,
    };
    uncheckRoutineList = [...uncheckRoutineList, Routine.fromJson(data)];
    previewList.removeWhere((preview) => preview.routineId == routineId);
    print(uncheckRoutineList);
    print(previewList);

    notifyListeners();

    if (time == null) {
      id = id + 1;
      return;
    }

    String dateTime = '$date $time';
    DateTime routineTime = DateTime.parse(dateTime);
    DateTime now = DateTime.now();

    if (routineTime.compareTo(now) < 0) {
      id = id + 1;
      return;
    }

    showNotification(id: id, content: content, date: dateTime);
    id = id + 1;

    // try {
    //   final queryParams = {
    //     'date': date,
    //   };
    //   final uri = Uri.https(serverEndpoint,
    //       apiPath['createRoutine']!(userId, routineId), queryParams);
    //   final response =
    //       await http.post(uri, headers: {'Content-Type': 'application/json'});

    //   final responseData = json.decode(response.body);
    //   Map<String, dynamic> data = responseData['data'];
    //   uncheckRoutineList = [...uncheckRoutineList, Routine.fromJson(data)];
    //   previewList.removeWhere((preview) => preview.routineId == routineId);

    // notifyListeners();

    //   if (data['time'] == null) {
    //     return;
    //   }

    //   final dateTime = '$date $time';
    //   DateTime routineTime = DateTime.parse(dateTime);
    //   DateTime now = DateTime.now();

    //   if (routineTime.compareTo(now) < 0) {
    //     return;
    //   }

    //   showNotification(
    //       id: data['routineId'],
    //       content: data['content'],
    //       date: '$date ${data['time']}');
    // } catch (error) {
    //   // Toast message 보여주기 '루틴 추가에 실패했습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }
  }

  Future<void> finishRoutine(userId, routineId) async {
    previewList.removeWhere((preview) => preview.routineId == routineId);

    // try {
    //   final uri = Uri.https(
    //       serverEndpoint, apiPath['finishRoutine']!(userId, routineId));
    //   await http.delete(uri, headers: {'Content-Type': 'application/json'});
    //   previewList.removeWhere((preview) => preview.routineId == routineId);
    // } catch (error) {
    //   // Toast message 보여주기 '루틴을 종료할 수 없습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> deleteRoutine({userId, routineId, date}) async {
    uncheckRoutineList.removeWhere((routine) => routine.routineId == routineId);
    checkRoutineList.removeWhere((routine) => routine.routineId == routineId);
    await fetchPreviewList(date);
    await notifications.cancel(routineId);

    // try {
    //   final uri = Uri.https(
    //       serverEndpoint, apiPath['deleteRoutine']!(userId, routineId));
    //   await http.delete(uri, headers: {'Content-Type': 'application/json'});
    //   uncheckRoutineList
    //       .removeWhere((routine) => routine.routineId == routineId);
    //   checkRoutineList.removeWhere((routine) => routine.routineId == routineId);
    //   await fetchPreviewList(date);
    //   await notifications.cancel(routineId);
    // } catch (error) {
    //   // Toast message 보여주기 '루틴을 삭제할 수 없습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> updatePreview({userId, routineId, time, repeatDays}) async {
    try {
      final uri = Uri.https(
          serverEndpoint, apiPath['updateRoutine']!(userId, routineId));
      final jsonData = {
        if (time != null) 'time': time,
        if (repeatDays != null) 'repeatDays': repeatDays
      };
      final requestBody = json.encode(jsonData);
      final response = await http.patch(uri,
          body: requestBody, headers: {'Content-Type': 'application/json'});
      final responseBody = json.decode(response.body);
      Map<String, dynamic> data = responseBody['data'];
      previewList = previewList
          .map((preview) =>
              preview.routineId == routineId ? Preview.fromJson(data) : preview)
          .toList();
    } catch (error) {
      // Toast message 보여주기 '루틴을 수정할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> verifyRoutine(
      {userId, routineId, imgUrl, longitude, latitude, date}) async {
    var target = uncheckRoutineList
        .firstWhere((routine) => routine.routineId == routineId);
    uncheckRoutineList.removeWhere((routine) => routine.routineId == routineId);

    Map<String, dynamic> data = {
      'userId': target.userId,
      'routineId': target.routineId,
      'routineIdentifier': target.routineIdentifier,
      'content': target.content,
      'registrationImgUrl': target.registrationImgUrl,
      'date': target.date,
      'time': target.time,
      'startRepeatDate': target.startRepeatDate,
      'repeatDays': target.repeatDays,
      'destinationLongitude': target.destinationLongitude,
      'destinationLatitude': target.destinationLatitude,
      'isCompleted': true,
      'isPreview': target.isPreview
    };
    checkRoutineList = [...checkRoutineList, Routine.fromJson(data)];
    await notifications.cancel(routineId);

    // try {
    //   final queryParams = {'date': date};
    //   final uri = Uri.https(serverEndpoint,
    //       apiPath['verifyRoutine']!(userId, routineId), queryParams);
    //   final jsonData = {
    //     'verifiedImgUrl': imgUrl,
    //     'currentLongitude': longitude,
    //     'currentLatitude': latitude
    //   };
    //   final requestBody = json.encode(jsonData);
    //   final response = await http.patch(uri,
    //       body: requestBody, headers: {'Content-Type': 'application/json'});
    //   final responseBody = json.decode(response.body);
    //   Map<String, dynamic> data = responseBody['data'];
    //   uncheckRoutineList
    //       .removeWhere((routine) => routine.routineId == routineId);
    //   checkRoutineList = [...checkRoutineList, Routine.fromJson(data)];
    //   await notifications.cancel(routineId);
    // } catch (error) {
    //   // Toast message 보여주기 '루틴을 완료할 수 없습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }
}
