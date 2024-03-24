import 'package:flutter/material.dart';
import 'package:picle/models/todo_model.dart';
import 'package:picle/providers/date_provider.dart';
import 'package:picle/providers/todo_provider.dart';
import 'package:picle/widgets/default_button.dart';
import 'package:picle/widgets/list/todo_item.dart';
import 'package:provider/provider.dart';

int userId = 1;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _controller = TextEditingController();
  late bool isCreating;

  @override
  void initState() {
    super.initState();
    isCreating = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date = context.read<DateProvider>().getDate();

    return Column(
      children: [
        if (isCreating)
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '수정할 내용을 입력해주세요.',
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF54C29B), width: 2),
              ),
            ),
            onTapOutside: (event) {
              _controller.text = '';
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                isCreating = false;
              });
            },
            onEditingComplete: () {
              setState(() {
                isCreating = false;
              });
              context.read<TodoProvider>().addTodo(
                    userId: userId,
                    content: _controller.text,
                    date: date,
                  );
            },
          ),
        Expanded(
          child: Consumer<TodoProvider>(
            builder: (context, provider, child) {
              List<Todo> todoList = [
                ...provider.uncheckTodoList,
                ...provider.checkTodoList
              ];

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                primary: false,
                itemCount: todoList.length,
                itemBuilder: (_, index) {
                  Todo todo = todoList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: TodoItem(
                      userId: todo.userId,
                      id: todo.id,
                      text: todo.content,
                      isChecked: todo.isCompleted,
                    ),
                  );
                },
              );
            },
          ),
        ),
        DefaultButton(
          buttonText: '투두 등록하기',
          onPressed: () {
            setState(() {
              isCreating = true;
            });
          },
        ),
      ],
    );
  }
}
