class UserChallenge {
  final int userId;
  final int challengeId;
  final String content;
  final int progress;
  final bool completed;

  UserChallenge({
    required this.userId,
    required this.challengeId,
    required this.content,
    required this.progress,
    required this.completed,
  });

  UserChallenge.fromJson(Map<String, dynamic> json)
      : userId = json['user']['id'],
        challengeId = json['id'],
        content = json['content'],
        progress = json['progress'],
        completed = json['completed'];
}
