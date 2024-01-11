import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picle/models/todo_model.dart';
// import 'package:http/http.dart' as http;

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

    // final response =
    //     await http.get(Uri.parse('/api/v1/todo/getByDate/:userId?date=$date'));

    // if (response.statusCode == 200) {
    //   // 성공적으로 데이터를 보냈을 경우
    //   Map<String, dynamic> responseBody = jsonDecode(response.body);
    //   List<Map<String, dynamic>> data = responseBody['data'];
    //   todoList = [for (Map<String, dynamic> todo in data) Todo.fromJson(todo)];
    // } else {
    //   // 요청이 실패한 경우
    //   // Toast message 보여주기 '투두를 가져올 수 없습니다'
    //   // 400번대와 500번대 오류 분기 처리하기
    //   print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> addTodo(content) async {
    todoList = [
      ...todoList,
      Todo(
        id: 1,
        content: content,
        date: date,
        isCompleted: false,
      ),
    ];

    // final url =
    // Uri.parse('/api/v1/todo/create/$userId');
    // final Map<String, dynamic> data = {
    //   'content': content,
    //   'date': date.toString().split(' ')[0],
    //   'isCompleted': false,
    // };

    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(data),
    // );

    // if (response.statusCode == 201) {
    //   // 성공적으로 데이터를 보냈을 경우
    //   Map<String, dynamic> responseBody = jsonDecode(response.body);
    //   Map<String, dynamic> data = responseBody['data'];
    //   todoList = [...todoList, Todo.fromJson(data)];
    // } else {
    //   // 요청이 실패한 경우
    //   print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }

  Future<void> deleteTodo(todoId) async {
    todoList.removeWhere((todo) => todo.id == todoId);

    // String apiUrl = '/api/v1/todo/delete?{userId}&$todoId';
    // final response = await http.delete(Uri.parse(apiUrl));

    // if (response.statusCode == 200) {
    //   // 성공적으로 데이터를 보냈을 경우
    //   todoList.removeWhere((todo) => todo.id == todoId);
    // } else {
    //   // 요청이 실패한 경우
    //   print('${response['code']}: ${response['message']}');
    // }

    notifyListeners();
  }
}
