class UserModel {
  final int id;
  final String? platform;
  final String? nickname, profileImage;

  UserModel({
    required this.id,
    required this.nickname,
    required this.profileImage,
    this.platform,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nickname: json['nickname'],
      profileImage: json['profileImage'],
      platform: json['platform'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'profileImage': profileImage,
        'platform': platform,
      };
}
