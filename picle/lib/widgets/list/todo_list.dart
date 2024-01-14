import 'package:flutter/material.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:provider/provider.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/models/todo_model.dart';
import 'package:picle/widgets/list/list_item.dart';
import 'package:picle/widgets/button.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TodoProvider>().fetchTodoList();
    List<Todo> todoList = context.watch<TodoProvider>().todoList;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            primary: false,
            itemCount: todoList.length,
            itemBuilder: (_, index) {
              Todo todo = todoList[index];
              return ListItem(
                text: todo.content,
                isChecked: todo.completed,
              );
            },
          ),
        ),
        DefaultButton(
          buttonText: '투두 등록하기',
          onPressed: () {},
        ),
      ],
    );
  }
}
