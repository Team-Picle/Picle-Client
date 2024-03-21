import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/todo_model.dart';

var userId = 1;

class TodoProvider extends ChangeNotifier {
  List<Todo> uncheckTodoList = [];
  List<Todo> checkTodoList = [];
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
      uncheckTodoList = [
        for (Map<String, dynamic> todo in data['data'])
          if (!todo['isCompleted']) Todo.fromJson(todo),
      ];
      checkTodoList = [
        for (Map<String, dynamic> todo in data['data'])
          if (todo['isCompleted']) Todo.fromJson(todo),
      ];
    } else {
      throw Exception('Fail to load date');
    }

    // try {
    //   final queryParams = {
    //     'date': date,
    //   };
    //   final uri =
    //       Uri.https(serverEndpoint, apiPath['getTodos']!(userId), queryParams);
    //   final response =
    //       await http.get(uri, headers: {'Content-Type': 'application/json'});
    //   final responseBody = json.decode(response.body);

    //   uncheckTodoList = [
    //     for (Map<String, dynamic> todo in data['data'])
    //       if (todo['isComplete'] == false) Todo.fromJson(todo),
    //   ];
    //   checkTodoList = [
    //     for (Map<String, dynamic> todo in data['data'])
    //       if (todo['isComplete'] == true) Todo.fromJson(todo),
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
      uncheckTodoList = [
        ...uncheckTodoList,
        Todo.fromJson(responseBody['data'])
      ];
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
      uncheckTodoList.removeWhere((todo) => todo.id == todoId);
      checkTodoList.removeWhere((todo) => todo.id == todoId);
    } catch (error) {
      // Toast message 보여주기 '투두 삭제에 실패했습니다'
      // print('${response['code']}: ${response['message']}');
    }

    notifyListeners();
  }

  Future<void> completeTodo(userId, todoId, isCompleted) async {
    if (isCompleted) {
      var todo = uncheckTodoList.firstWhere((todo) => todo.id == todoId);
      Map<String, dynamic> data = {
        'id': todoId,
        'userId': userId,
        'content': todo.content,
        'date': todo.date,
        'isCompleted': isCompleted
      };
      uncheckTodoList.removeWhere((todo) => todo.id == todoId);
      checkTodoList = [...checkTodoList, Todo.fromJson(data)];
    } else {
      var todo = checkTodoList.firstWhere((todo) => todo.id == todoId);
      Map<String, dynamic> data = {
        'id': todoId,
        'userId': userId,
        'content': todo.content,
        'date': todo.date,
        'isCompleted': isCompleted
      };
      checkTodoList.removeWhere((todo) => todo.id == todoId);
      uncheckTodoList = [...uncheckTodoList, Todo.fromJson(data)];
    }

    // try {
    //   final uri =
    //       Uri.https(serverEndpoint, apiPath['updateTodo']!(userId, todoId));
    //   final jsonData = {'isCompleted': isCompleted};
    //   final requestBody = json.encode(jsonData);
    //   final response = await http.patch(uri, body: requestBody, headers: {
    //     'Content-Type': 'application/json',
    //   });

    //   final responseBody = json.decode(response.body);
    //   Map<String, dynamic> data = responseBody['data'];

    //   if (isCompleted) {
    //     uncheckTodoList.removeWhere((todo) => todo.id == todoId);
    //     checkTodoList = [...checkTodoList, Todo.fromJson(data)];
    //   } else {
    //     checkTodoList.removeWhere((todo) => todo.id == todoId);
    //     uncheckTodoList = [...checkTodoList, Todo.fromJson(data)];
    //   }
    // } catch (error) {
    //   // Toast message 보여주기 '투두를 수정할 수 없습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> updateTodo(userId, todoId, {content, todoDate}) async {
    uncheckTodoList = uncheckTodoList
        .map((todo) => todo.id == todoId
            ? Todo(
                id: todoId,
                userId: userId,
                content: content!,
                date: todo.date,
                isCompleted: todo.isCompleted)
            : todo)
        .toList();
    checkTodoList = checkTodoList
        .map((todo) => todo.id == todoId
            ? Todo(
                id: todoId,
                userId: userId,
                content: content!,
                date: todo.date,
                isCompleted: todo.isCompleted)
            : todo)
        .toList();
    // try {
    //   final uri =
    //       Uri.https(serverEndpoint, apiPath['updateTodo']!(userId, todoId));
    //   final jsonData = {
    //     if (content != null) 'content': content,
    //     if (todoDate != null) 'date': todoDate,
    //   };
    //   final requestBody = json.encode(jsonData);
    //   final response = await http.patch(uri, body: requestBody, headers: {
    //     'Content-Type': 'application/json',
    //   });

    //   final responseBody = json.decode(response.body);
    //   Map<String, dynamic> data = responseBody['data'];
    //   uncheckTodoList = uncheckTodoList
    //       .map((todo) => todo.id == todoId ? Todo.fromJson(data) : todo)
    //       .toList();
    //   checkTodoList = checkTodoList
    //       .map((todo) => todo.id == todoId ? Todo.fromJson(data) : todo)
    //       .toList();
    // } catch (error) {
    //   // Toast message 보여주기 '투두를 수정할 수 없습니다'
    //   // print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }
}
