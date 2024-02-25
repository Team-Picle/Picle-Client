class Routine {
  final int userId;
  final int routineId;
  final String content;
  final String registrationImgUrl;
  final String date;
  final String time;
  final String startRepeatDate;
  final List<dynamic> repeatDays;
  final double destinationLongitude;
  final double destinationLatitude;
  final bool isCompleted;
  final bool isPreview;

  Routine({
    required this.userId,
    required this.routineId,
    required this.content,
    required this.registrationImgUrl,
    required this.date,
    required this.time,
    required this.startRepeatDate,
    required this.repeatDays,
    required this.destinationLongitude,
    required this.destinationLatitude,
    required this.isCompleted,
    required this.isPreview,
  });

  Routine.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        routineId = json['routineId'],
        content = json['content'],
        registrationImgUrl = json['registrationImgUrl'],
        date = json['date'],
        time = json['time'],
        startRepeatDate = json['startRepeatDate'],
        repeatDays = json['repeatDays'],
        destinationLongitude = json['destinationLongitude'],
        destinationLatitude = json['destinationLatitude'],
        isCompleted = json['isCompleted'],
        isPreview = json['isPreview'];
}
