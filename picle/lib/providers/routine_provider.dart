import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picle/models/routine_model.dart';

class RoutineProvider extends ChangeNotifier {
  List<Routine> routineList = [];

  void fetchRoutineList() async {
    final response =
        await rootBundle.loadString('lib/data/routine_list.json');
    final data = json.decode(response);

    if (data['code'] == 200) {
      routineList = [
        for (var routine in data['data']) Routine.fromJson(routine)
      ];
    } else {
      routineList = [];
      throw Exception('Fail to load date');
    }
    notifyListeners();
  }
}
