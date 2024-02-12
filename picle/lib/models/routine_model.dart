class Routine {
  int userId;
  int routineId;
  String content;
  String date;
  String? time;
  bool completed;

  Routine({
    required this.userId,
    required this.routineId,
    required this.content,
    required this.date,
    this.time,
    required this.completed,
  });

  Routine.fromJson(Map<String, dynamic> json)
      : userId = json['user']['id'],
        routineId = json['id'],
        content = json['content'],
        date = json['date'],
        time = json['time'],
        completed = json['completed'];
}
