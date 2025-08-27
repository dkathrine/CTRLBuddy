import 'package:uuid/uuid.dart';

class Comment {
  final String id;
  final String userId;
  final String threadId;
  final String comment;
  final int likes;
  final String dateTime;

  Comment({
    required this.userId,
    required this.threadId,
    required this.comment,
    this.likes = 0,
    this.dateTime = "",
  }) : id = Uuid().v4();
}
