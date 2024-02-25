import 'package:flutter/material.dart';
import 'package:picle/models/todo_model.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/list/todo_item.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<TodoProvider>(
            builder: (context, provider, child) {
              List<Todo> todoList = provider.todoList;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                primary: false,
                itemCount: todoList.length,
                itemBuilder: (_, index) {
                  Todo todo = todoList[index];
                  return TodoItem(
                    userId: todo.userId,
                    id: todo.id,
                    text: todo.content,
                    isChecked: todo.isCompleted,
                  );
                },
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
