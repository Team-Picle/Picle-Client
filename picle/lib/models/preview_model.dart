class Preview {
  final int userId;
  final int routineId;
  final String content;
  final String? time;
  final String startRepeatDate;
  final List<dynamic> repeatDays;

  Preview({
    required this.userId,
    required this.routineId,
    required this.content,
    this.time,
    required this.startRepeatDate,
    required this.repeatDays,
  });

  Preview.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        routineId = json['routineId'],
        content = json['content'],
        time = json['time'],
        startRepeatDate = json['startRepeatDate'],
        repeatDays = json['repeatDays'];
}
