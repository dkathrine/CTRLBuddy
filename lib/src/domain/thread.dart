import 'package:ctrl_buddy/src/domain/comment.dart';
import 'package:uuid/uuid.dart';

class Thread {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String gameName;
  final int likes;
  List<Comment> comments;

  Thread({
    required this.userId,
    required this.gameName,
    required this.title,
    required this.message,
    this.likes = 0,
    List<Comment>? comments,
  }) : comments = comments ?? [],
       id = Uuid().v4();
}
