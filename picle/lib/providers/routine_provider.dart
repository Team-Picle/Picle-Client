import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/preview_model.dart';
import 'package:picle/models/routine_model.dart';
import 'package:picle/notification.dart';
import 'package:picle/widgets/toast.dart';

class RoutineProvider extends ChangeNotifier {
  List<Preview> previewList = [];
  List<Routine> uncheckRoutineList = [];
  List<Routine> checkRoutineList = [];
  bool isDisposed = false;

  RoutineProvider(userId) {
    String today = DateTime.now() //
        .toString()
        .split(' ')[0];
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
      // Toast message 보여주기 '루틴을 불러오지 못 했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    // final response = await rootBundle.loadString('lib/data/routine_list.json');
    // final data = json.decode(response);

    // if (data['code'] == 200) {
    //   uncheckRoutineList = [
    //     for (Map<String, dynamic> routine in data['data'])
    //       if (routine['isCompleted'] == false) Routine.fromJson(routine),
    //   ];
    //   checkRoutineList = [
    //     for (Map<String, dynamic> routine in data['data'])
    //       if (routine['isCompleted'] == true) Routine.fromJson(routine),
    //   ];
    // } else {
    //   throw Exception('Fail to load date');
    // }
    //
    // notifyListeners();
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
            Preview.fromJson(preview)
      ];
    } catch (error) {
      print('[ERROR] fetchPreviewList: $error');
      // Toast message 보여주기 '미리보기를 불로오지 못 했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    // final response = await rootBundle.loadString('lib/data/preview_list.json');
    // final data = json.decode(response);

    // if (data['code'] == 200) {
    //   List<int> routineIdList = [...uncheckRoutineList, ...checkRoutineList]
    //       .map((routine) => routine.routineIdentifier)
    //       .toList();
    //   previewList = [
    //     for (Map<String, dynamic> preview in data['data'])
    //       if (!routineIdList.contains(preview['routineId']))
    //         Preview.fromJson(preview)
    //   ];
    // } else {
    //   previewList = [];
    //   throw Exception('Fail to load date');
    // }

    // notifyListeners();
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
    // print('content: $content');
    // print('repeatDays: $repeatDays');
    // print('imgUrl: $imgUrl');
    // print('destinationLongitude: $destinationLongitude');
    // print('destinationLatitude: $destinationLatitude');

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

      print(responseBody);

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
      // Toast message 보여주기 '루틴을 등록에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
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
      // Toast message 보여주기 '루틴 추가에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    // Map<String, dynamic> data = {
    //   'userId': userId,
    //   'routineId': id,
    //   'routineIdentifier': routineId,
    //   'content': content,
    //   'registrationImgUrl': '',
    //   'date': '',
    //   'startRepeatDate': '',
    //   'repeatDays': [],
    //   'destinationLongitude': 0.0,
    //   'destinationLatitude': 0.0,
    //   'isCompleted': false,
    //   'isPreview': false,
    //   if (time != null) 'time': time,
    // };
    // uncheckRoutineList = [...uncheckRoutineList, Routine.fromJson(data)];
    // previewList.removeWhere((preview) => preview.routineId == routineId);

    // final dateTime = '$date $time';
    // if (time != null) {
    //   showNotification(id: id, content: content, date: dateTime);
    // }
    // id = id + 1;
    //
    // notifyListeners();
  }

  Future<void> finishRoutine({
    required userId,
    required routineId,
  }) async {
//     previewList.removeWhere((preview) => preview.routineId == routineId);
//     print(previewList);
    // try {
    //   final uri = Uri.https(
    //       serverEndpoint, apiPath['finishRoutine']!(userId, routineId));
    //   await http.delete(uri, headers: {'Content-Type': 'application/json'});
    //   previewList.removeWhere((preview) => preview.routineId == routineId);
    // } catch (error) {
    //   // Toast message 보여주기 '루틴을 종료할 수 없습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }
    try {
      final uri = Uri.http(
          serverEndpoint, apiPath['finishRoutine']!(userId, routineId));
      await http.delete(uri, headers: {'Content-Type': 'application/json'});
      previewList.removeWhere((preview) => preview.routineId == routineId);
    } catch (error) {
      print('[ERROR] finishRoutine: $error');
      // Toast message 보여주기 '루틴을 종료할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();

    // previewList.removeWhere((preview) => preview.routineId == routineId);
    // notifyListeners();
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
      // Toast message 보여주기 '루틴을 삭제할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();

    // uncheckRoutineList.removeWhere((routine) => routine.routineId == routineId);
    // checkRoutineList.removeWhere((routine) => routine.routineId == routineId);
    // await fetchPreviewList(date);
    // await notifications.cancel(routineId);
  }

  Future<void> updatePreview({
    required userId,
    required routineId,
    required date,
    time,
    repeatDays,
  }) async {
    print('time: $time');
    print('repeatDays: $repeatDays');

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
//       final response = await http.patch(uri,
//           body: requestBody, headers: {'Content-Type': 'application/json'});
//       final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
//       Map<String, dynamic> data = responseBody['data'];
//       previewList = previewList
//           .map((preview) =>
//               preview.routineId == routineId ? Preview.fromJson(data) : preview)
//           .toList();
//       await http.patch(
//         uri,
//         body: requestBody,
//         headers: {'Content-Type': 'application/json'},
//       );

//       await fetchPreviewList(date);
    } catch (error) {
      print('[ERROR] updateRoutine: $error');
      // Toast message 보여주기 '루틴을 수정할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
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
    // print('imgUrl: $imgUrl');
    // print('longitude: $longitude');
    // print('latitude: $latitude');

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

      print(responseBody);

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
      // Toast message 보여주기 '루틴을 완료할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();

    // var target = uncheckRoutineList
    //     .firstWhere((routine) => routine.routineId == routineId);
    // uncheckRoutineList.removeWhere((routine) => routine.routineId == routineId);

    // Map<String, dynamic> data = {
    //   'userId': target.userId,
    //   'routineId': target.routineId,
    //   'routineIdentifier': target.routineIdentifier,
    //   'content': target.content,
    //   'registrationImgUrl': target.registrationImgUrl,
    //   'date': target.date,
    //   'time': target.time,
    //   'startRepeatDate': target.startRepeatDate,
    //   'destinationLongitude': target.destinationLongitude,
    //   'destinationLatitude': target.destinationLatitude,
    //   'isCompleted': true,
    //   'isPreview': target.isPreview
    // };
    // checkRoutineList = [...checkRoutineList, Routine.fromJson(data)];
    // await notifications.cancel(routineId);

    // notifyListeners();
  }
}
