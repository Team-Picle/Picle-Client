class Todo {
  final int id;
  final int userId;
  String content;
  String date;
  bool isCompleted;

  Todo({
    required this.id,
    required this.userId,
    required this.content,
    required this.date,
    required this.isCompleted,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        content = json['content'],
        date = json['date'],
        isCompleted = json['isCompleted'];
}
