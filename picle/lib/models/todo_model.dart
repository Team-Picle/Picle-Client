class Todo {
  final int id;
  String content;
  String date;
  bool isCompleted;

  Todo({
    required this.id,
    required this.content,
    required this.date,
    required this.isCompleted,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        date = json['date'],
        isCompleted = json['isCompleted'];
}
