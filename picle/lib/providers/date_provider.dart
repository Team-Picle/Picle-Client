import 'package:flutter/material.dart';

var userId = 1;

class DateProvider extends ChangeNotifier {
  String date = DateTime.now() //
      .toString()
      .split(' ')[0];

  DateProvider() {
    // updateDate();
  }

  String getDate() {
    return date;
  }

  void updateDate(selectedDate) {
    date = selectedDate.toString().split(' ')[0];
    notifyListeners();
  }
}
