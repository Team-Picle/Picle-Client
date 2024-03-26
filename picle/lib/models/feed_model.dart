class Feed {
  final int routineId;
  final String profileImage;
  final String nickname;
  final String verifiedImageUrl;
  final String date;

  Feed({
    required this.routineId,
    required this.profileImage,
    required this.nickname,
    required this.verifiedImageUrl,
    required this.date,
  });

  Feed.fromJson(Map<String, dynamic> json)
      : routineId = json['routineId'],
        profileImage = json['profileImage'],
        nickname = json['nickname'],
        verifiedImageUrl = json['verifiedImageUrl'],
        date = json['date'];
}
