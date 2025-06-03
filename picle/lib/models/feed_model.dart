class Feed {
  final int routineId;
  final String verifiedImgUrl;
  final String? profileImage;
  final String? nickname;
  final String? date;
  int? likeCount;
  bool? isLike;

  Feed({
    required this.routineId,
    required this.verifiedImgUrl,
    this.profileImage,
    this.nickname,
    this.date,
    this.likeCount,
    this.isLike,
  });

  Feed.fromJson(Map<String, dynamic> json)
      : routineId = json['routineId'],
        verifiedImgUrl = json['verifiedImgUrl'],
        profileImage = json['profileImage'],
        nickname = json['nickname'],
        date = json['date'],
        likeCount = json['likeCount'] as int?,
        isLike = json['isLike'] as bool?;
}
