import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:picle/constants/index.dart';
import 'package:picle/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> uncheckTodoList = [];
  List<Todo> checkTodoList = [];

  TodoProvider(userId) {
    fetchTodoList(
      userId: userId,
      date: DateTime.now() //
          .toString()
          .split(' ')[0],
    );
  }

  Future<void> fetchTodoList({
    required userId,
    required date,
  }) async {
    try {
      final queryParams = {
        'date': date,
      };
      final uri =
          Uri.http(serverEndpoint, apiPath['getTodos']!(userId), queryParams);
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8',
      });
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      uncheckTodoList = [
        for (Map<String, dynamic> todo in responseBody['data'])
          if (todo['isCompleted'] == false) Todo.fromJson(todo),
      ];
      checkTodoList = [
        for (Map<String, dynamic> todo in responseBody['data'])
          if (todo['isCompleted'] == true) Todo.fromJson(todo),
      ];
    } catch (error) {
      print('[ERROR] fetchTodoList: $error');
    }

    notifyListeners();
  }

  Future<void> addTodo({
    required userId,
    required content,
    required date,
  }) async {
    try {
      final jsonData = {
        'content': content,
        'date': date,
      };
      final requestBody = json.encode(jsonData);
      final uri = Uri.http(serverEndpoint, apiPath['createTodo']!(userId));
      final response = await http.post(uri, body: requestBody, headers: {
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8',
      });
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      print(responseBody);

      uncheckTodoList = [
        ...uncheckTodoList,
        Todo.fromJson(responseBody['data'])
      ];
    } catch (error) {
      print('[ERROR] addTodo: $error');
    }

    notifyListeners();
  }

  Future<void> deleteTodo({
    required userId,
    required todoId,
  }) async {
    try {
      final uri =
          Uri.http(serverEndpoint, apiPath['deleteTodo']!(userId, todoId));
      await http.delete(uri, headers: {
        'Content-Type': 'application/json',
      });
      uncheckTodoList.removeWhere((todo) => todo.id == todoId);
      checkTodoList.removeWhere((todo) => todo.id == todoId);
    } catch (error) {
      print('[ERROR] deleteTodo: $error');
    }

    notifyListeners();
  }

  Future<void> completeTodo({
    required userId,
    required todoId,
    required isCompleted,
  }) async {
    try {
      final uri =
          Uri.http(serverEndpoint, apiPath['updateTodo']!(userId, todoId));
      final jsonData = {'isCompleted': isCompleted};
      final requestBody = json.encode(jsonData);
      final response = await http.patch(uri, body: requestBody, headers: {
        'Content-Type': 'application/json',
      });

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> data = responseBody['data'];

      if (isCompleted) {
        uncheckTodoList.removeWhere((todo) => todo.id == todoId);
        checkTodoList = [...checkTodoList, Todo.fromJson(data)];
      } else {
        checkTodoList.removeWhere((todo) => todo.id == todoId);
        uncheckTodoList = [...checkTodoList, Todo.fromJson(data)];
      }
    } catch (error) {
      print('[ERROR] completeTodo: $error');
    }

    notifyListeners();
  }

  Future<void> updateTodo({
    required userId,
    required todoId,
    content,
    date,
  }) async {
    try {
      final uri =
          Uri.http(serverEndpoint, apiPath['updateTodo']!(userId, todoId));
      final jsonData = {
        if (content != null) 'content': content,
        if (date != null) 'date': date,
      };
      final requestBody = json.encode(jsonData);
      final response = await http.patch(uri, body: requestBody, headers: {
        'Content-Type': 'application/json',
      });

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> data = responseBody['data'];
      uncheckTodoList = uncheckTodoList
          .map((todo) => todo.id == todoId ? Todo.fromJson(data) : todo)
          .toList();
      checkTodoList = checkTodoList
          .map((todo) => todo.id == todoId ? Todo.fromJson(data) : todo)
          .toList();
    } catch (error) {
      print('[ERROR] updateTodo: $error');
    }

    notifyListeners();
  }
}
