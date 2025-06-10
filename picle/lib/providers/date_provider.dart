import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  String date = DateTime.now().toString().split(' ')[0];

  DateProvider() {}

  String getDate() {
    return date;
  }

  void updateDate(selectedDate) {
    date = selectedDate.toString().split(' ')[0];
    notifyListeners();
  }
}
