class Thread {
  final String id;
  final String userId;
  final String username;
  final String userProfilePicture;
  final String title;
  final String message;
  final String gameId;
  final String gameName;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Thread({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePicture,
    required this.title,
    required this.message,
    required this.gameId,
    required this.gameName,
    this.likes = 0,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : likedBy = likedBy ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'username': username,
    'userProfilePicture': userProfilePicture,
    'title': title,
    'message': message,
    'gameId': gameId,
    'gameName': gameName,
    'likes': likes,
    'likedBy': likedBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Thread.fromMap(String id, Map<String, dynamic> map) {
    return Thread(
      id: id,
      userId: map['userId'],
      username: map['username'],
      userProfilePicture: map['userProfilePicture'],
      title: map['title'],
      message: map['message'],
      gameId: map['gameId'],
      gameName: map['gameName'],
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
