class Routine {
  final int userId;
  final int routineId;
  final int? routineIdentifier;
  final String content;
  final String registrationImgUrl;
  final String date;
  final String? time;
  final String startRepeatDate;
  double destinationLongitude;
  double destinationLatitude;
  final bool isCompleted;

  Routine({
    required this.userId,
    required this.routineId,
    this.routineIdentifier,
    required this.content,
    required this.registrationImgUrl,
    required this.date,
    this.time,
    required this.startRepeatDate,
    required this.destinationLongitude,
    required this.destinationLatitude,
    required this.isCompleted,
  });

  Routine.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        routineId = json['routineId'],
        routineIdentifier = json['routineIdentifier'],
        content = json['content'],
        registrationImgUrl = json['registrationImgUrl'],
        date = json['date'],
        time = json['time'],
        startRepeatDate = json['startRepeatDate'],
        destinationLongitude = json['destinationLongitude'],
        destinationLatitude = json['destinationLatitude'],
        isCompleted = json['isCompleted'];
}
