class Feed {
  final int routineId;
  final String profileImage;
  final String nickname;
  final String verifiedImgUrl;
  final String date;

  Feed({
    required this.routineId,
    required this.profileImage,
    required this.nickname,
    required this.verifiedImgUrl,
    required this.date,
  });

  Feed.fromJson(Map<String, dynamic> json)
      : routineId = json['routineId'],
        profileImage = json['profileImage'],
        nickname = json['nickname'],
        verifiedImgUrl = json['verifiedImgUrl'],
        date = json['date'];
}
