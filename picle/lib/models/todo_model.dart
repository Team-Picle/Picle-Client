class Todo {
  final int userId;
  final int todoId;
  final String content;
  final String date;
  final bool completed;

  Todo({
    required this.userId,
    required this.todoId,
    required this.content,
    required this.date,
    required this.completed,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : userId = json['user']['id'],
        todoId = json['id'],
        content = json['content'],
        date = json['date'],
        completed = json['completed'];
}
