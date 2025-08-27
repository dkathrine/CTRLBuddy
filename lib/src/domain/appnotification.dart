import 'package:uuid/uuid.dart';

class AppNotification {
  final String id;
  final String threadId;
  final String mentionId;
  final String notificationMsg;

  AppNotification({
    this.threadId = "",
    this.mentionId = "",
    required this.notificationMsg,
  }) : id = Uuid().v4();
}
