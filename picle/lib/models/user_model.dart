class UserModel {
  final String id, platform;
  final String? nickname, imageUrl;

  UserModel({
    required this.id,
    required this.nickname,
    required this.imageUrl,
    required this.platform,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
      platform: json['platform'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'imageUrl': imageUrl,
        'platform': platform,
      };
}
