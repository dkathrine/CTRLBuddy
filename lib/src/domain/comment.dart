class Comment {
  final String id;
  final String userId;
  final String username;
  final String userProfilePicture;
  final String threadId;
  final String comment;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePicture,
    required this.threadId,
    required this.comment,
    this.likes = 0,
    List<String>? likedBy,
    DateTime? createdAt,
  }) : likedBy = likedBy ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'username': username,
    'userProfilePicture': userProfilePicture,
    'threadId': threadId,
    'comment': comment,
    'likes': likes,
    'likedBy': likedBy,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Comment.fromMap(String id, Map<String, dynamic> map) {
    return Comment(
      id: id,
      userId: map['userId'],
      username: map['username'],
      userProfilePicture: map['userProfilePicture'],
      threadId: map['threadId'],
      comment: map['comment'],
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
