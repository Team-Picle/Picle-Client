class UserModel {
  int id;
  String? nickname;
  String? profileImage;
  String? platform;

  UserModel({
    required this.id,
    required this.nickname,
    required this.profileImage,
    this.platform,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'],
        profileImage = json['profileImage'],
        platform = json['platform'];
}
