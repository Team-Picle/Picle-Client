class Routine {
  final int userId;
  final int routineId;
  final String content;
  final String date;
  final bool completed;

  Routine({
    required this.userId,
    required this.routineId,
    required this.content,
    required this.date,
    required this.completed,
  });

  Routine.fromJson(Map<String, dynamic> json)
      : userId = json['user']['id'],
        routineId = json['id'],
        content = json['content'],
        date = json['date'],
        completed = json['completed'];
}
