import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picle/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todoList = [];

  void fetchTodoList() async {
    final response =
        await rootBundle.loadString('lib/data/todo_list.json');
    final data = json.decode(response);

    if (data['code'] == 200) {
      todoList = [for (var todo in data['data']) Todo.fromJson(todo)];
    } else {
      todoList = [];
      throw Exception('Fail to load date');
    }
    notifyListeners();
  }
}
