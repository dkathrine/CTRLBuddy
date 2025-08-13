import 'package:uuid/uuid.dart';

class Notification {
  final String id;
  final String threadId;
  final String mentionId;
  final String notificationMsg;

  Notification({
    this.threadId = "",
    this.mentionId = "",
    required this.notificationMsg,
  }) : id = Uuid().v4();
}
