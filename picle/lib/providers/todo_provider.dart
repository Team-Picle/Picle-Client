import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/todo_model.dart';

var userId = 1;

class TodoProvider extends ChangeNotifier {
  List<Todo> todoList = [];
  String date = DateTime.now() //
      .toString()
      .split(' ')[0];

  TodoProvider() {
    fetchTodoList();
  }

  void updateDate(selectedDate) {
    date = selectedDate.toString().split(' ')[0];
    notifyListeners();
  }

  Future<void> fetchTodoList() async {
    final response = await rootBundle.loadString('lib/data/todo_list.json');
    final data = json.decode(response);

    if (data['code'] == 200) {
      todoList = [
        for (Map<String, dynamic> todo in data['data']) Todo.fromJson(todo),
      ];
    } else {
      todoList = [];
      throw Exception('Fail to load date');
    }
    print(data);

    // try {
    //   final queryParams = {
    //     'date': date,
    //   };
    //   final uri =
    //       Uri.https(serverEndpoint, apiPath['getTodos']!(userId), queryParams);
    //   final response =
    //       await http.get(uri, headers: {'Content-Type': 'application/json'});
    //   final responseBody = json.decode(response.body);
    //   todoList = [
    //     for (Map<String, dynamic> todo in responseBody['data'])
    //       Todo.fromJson(todo)
    //   ];
    // } catch (error) {
    //   // Toast message 보여주기 '투두 불러오기에 실패했습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> addTodo(userId, content) async {
    try {
      final jsonData = {
        'content': content,
        'date': date,
      };
      final requestBody = json.encode(jsonData);
      final uri = Uri.https(serverEndpoint, apiPath['createTodo']!(userId));
      final response = await http.post(uri,
          body: requestBody, headers: {'Content-Type': 'application/json'});
      final responseBody = json.decode(response.body);
      todoList = [...todoList, Todo.fromJson(responseBody['data'])];
    } catch (error) {
      // Toast message 보여주기 '투두를 추가할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> deleteTodo(userId, todoId) async {
    try {
      final uri =
          Uri.https(serverEndpoint, apiPath['deleteTodo']!(userId, todoId));
      await http.delete(uri, headers: {
        'Content-Type': 'application/json',
      });
      todoList.removeWhere((todo) => todo.id == todoId);
    } catch (error) {
      // Toast message 보여주기 '투두 삭제에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> updateTodo(userId, todoId,
      {content, todoDate, isCompleted}) async {
    try {
      final uri =
          Uri.https(serverEndpoint, apiPath['updateTodo']!(userId, todoId));
      final jsonData = {
        if (content != null) 'content': content,
        if (todoDate != null) 'date': todoDate,
        if (isCompleted != null) 'isCompleted': isCompleted,
      };
      final requestBody = json.encode(jsonData);
      final response = await http.patch(uri, body: requestBody, headers: {
        'Content-Type': 'application/json',
      });

      final responseBody = json.decode(response.body);
      Map<String, dynamic> data = responseBody['data'];
      todoList = todoList
          .map((todo) => todo.id == data['id'] ? Todo.fromJson(data) : todo)
          .toList();
    } catch (error) {
      // Toast message 보여주기 '투두를 수정할 수 없습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }
}
