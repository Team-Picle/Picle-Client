import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/preview_model.dart' as model;
import 'package:picle/models/routine_model.dart';
import 'package:picle/notification.dart';
import 'package:picle/widgets/toast.dart';

class RoutineProvider extends ChangeNotifier {
  List<model.Preview> previewList = [];
  List<Routine> uncheckRoutineList = [];
  List<Routine> checkRoutineList = [];
  bool isDisposed = false;

  RoutineProvider(userId) {
    String today = DateTime.now().toString().split(' ')[0];
    fetchList(
      userId: userId,
      date: today,
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

  Future<void> fetchList({
    required userId,
    required date,
  }) async {
    await fetchRoutineList(
      userId: userId,
      date: date,
    );
    await fetchPreviewList(
      userId: userId,
      date: date,
    );

    notifyListeners();
  }

  Future<void> fetchRoutineList({
    required userId,
    required date,
  }) async {
    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.http(
          serverEndpoint, apiPath['getRoutines']!(userId), queryParams);
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      uncheckRoutineList = [
        for (Map<String, dynamic> routine in responseBody['data'])
          if (routine['isCompleted'] == false) Routine.fromJson(routine),
      ];
      checkRoutineList = [
        for (Map<String, dynamic> routine in responseBody['data'])
          if (routine['isCompleted'] == true) Routine.fromJson(routine),
      ];
    } catch (error) {
      print('[ERROR] fetchRoutineList: $error');
    }
  }

  Future<void> fetchPreviewList({
    required userId,
    required date,
  }) async {
    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.http(
          serverEndpoint, apiPath['getPreviews']!(userId), queryParams);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      List<int?> routineIdList = [...uncheckRoutineList, ...checkRoutineList]
          .map((routine) => routine.routineIdentifier)
          .toList();
      previewList = [
        for (Map<String, dynamic> preview in responseBody['data'])
          if (!routineIdList.contains(preview['routineId']))
            model.Preview.fromJson(preview)
      ];
    } catch (error) {
      print('[ERROR] fetchPreviewList: $error');
    }
  }

  Future<void> registerRoutine({
    required userId,
    required content,
    required imgUrl,
    time,
    required startRepeatDate,
    required repeatDays,
    required destinationLongitude,
    required destinationLatitude,
    required date,
  }) async {
    if (content == '' ||
        imgUrl == '' ||
        startRepeatDate == '' ||
        repeatDays.isEmpty ||
        destinationLongitude == '' ||
        destinationLatitude == '') {
      showToast(text: '필수 입력를 모두 완성해주세요');
      return;
    }
    try {
      final url = Uri.http(serverEndpoint, apiPath['createPreview']!(userId));
      final jsonData = {
        'content': content,
        'registrationImgUrl': imgUrl,
        if (time != null) 'time': time,
        'startRepeatDate': startRepeatDate,
        'repeatDays': repeatDays,
        'destinationLongitude': destinationLongitude,
        'destinationLatitude': destinationLatitude
      };
      final requestBody = json.encode(jsonData);
      final response = await http.post(
        url,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseBody['data'] != null) {
        await fetchPreviewList(
          userId: userId,
          date: date,
        );
      } else {
        showToast(text: responseBody['message']);
      }
    } catch (error) {
      print('[ERROR] registerRoutine: $error');
    }

    notifyListeners();
  }

  Future<void> addRoutine({
    required userId,
    required routineId,
    required date,
    required time,
  }) async {
    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.http(serverEndpoint,
          apiPath['createRoutine']!(userId, routineId), queryParams);
      final response =
          await http.post(uri, headers: {'Content-Type': 'application/json'});
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      Map<String, dynamic> data = responseBody['data'];
      uncheckRoutineList = [...uncheckRoutineList, Routine.fromJson(data)];
      previewList.removeWhere((preview) => preview.routineId == routineId);

      notifyListeners();

      if (data['time'] == null) {
        return;
      }

      DateTime routineTime = DateTime.parse('$date $time');
      DateTime now = DateTime.now();
      if (routineTime.compareTo(now) < 0) {
        return;
      }

      showNotification(
        id: data['routineId'],
        content: data['content'],
        date: '$date ${data['time']}',
      );
    } catch (error) {
      print('[ERROR] addRoutine: $error');
    }
  }

  Future<void> finishRoutine({
    required userId,
    required routineId,
  }) async {
    try {
      final uri = Uri.http(
          serverEndpoint, apiPath['finishRoutine']!(userId, routineId));
      await http.delete(uri, headers: {'Content-Type': 'application/json'});
      previewList.removeWhere((preview) => preview.routineId == routineId);
    } catch (error) {
      print('[ERROR] finishRoutine: $error');
    }

    notifyListeners();
  }

  Future<void> deleteRoutine({
    required userId,
    required routineId,
    required date,
  }) async {
    try {
      final uri = Uri.http(
          serverEndpoint, apiPath['deleteRoutine']!(userId, routineId));
      await http.delete(uri, headers: {'Content-Type': 'application/json'});
      uncheckRoutineList
          .removeWhere((routine) => routine.routineId == routineId);
      checkRoutineList.removeWhere((routine) => routine.routineId == routineId);

      await notifications.cancel(routineId);
      await fetchPreviewList(
        userId: userId,
        date: date,
      );
    } catch (error) {
      print('[ERROR] deleteRoutine: $error');
    }

    notifyListeners();
  }

  Future<void> updatePreview({
    required userId,
    required routineId,
    required date,
    time,
    repeatDays,
  }) async {
    try {
      final uri = Uri.http(
          serverEndpoint, apiPath['updatePreview']!(userId, routineId));
      final jsonData = {
        if (time != null) 'time': time,
        if (repeatDays != null) 'repeatDays': repeatDays
      };
      final requestBody = json.encode(jsonData);
      await http.patch(
        uri,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      await fetchPreviewList(
        userId: userId,
        date: date,
      );
    } catch (error) {
      print('[ERROR] updateRoutine: $error');
    }

    notifyListeners();
  }

  Future<void> verifyRoutine({
    required userId,
    required routineId,
    required imgUrl,
    required longitude,
    required latitude,
    required date,
  }) async {
    if (imgUrl == '') {
      showToast(text: '이미지를 등록해주세요');
      return;
    }

    if (longitude == '' || latitude == '') {
      showToast(text: '현재 위치를 받아올 수 없습니다');
      return;
    }

    try {
      final queryParams = {
        'date': date,
      };
      final uri = Uri.http(serverEndpoint,
          apiPath['verifyRoutine']!(userId, routineId), queryParams);
      final jsonData = {
        'verifiedImgUrl': imgUrl,
        'currentLongitude': longitude,
        'currentLatitude': latitude
      };
      final requestBody = json.encode(jsonData);
      final response = await http.patch(
        uri,
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseBody['data'] != null) {
        Map<String, dynamic> data = responseBody['data'];

        uncheckRoutineList
            .removeWhere((routine) => routine.routineId == routineId);
        checkRoutineList = [...checkRoutineList, Routine.fromJson(data)];
        await notifications.cancel(routineId);
        showToast(text: '인증에 성공했습니다!');
      } else {
        showToast(text: responseBody['message']);
      }
    } catch (error) {
      print('[ERROR] verifyRoutine: $error');
    }

    notifyListeners();
  }
}
