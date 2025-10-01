import 'package:uuid/uuid.dart';

class AppNotification {
  final String id;
  final String threadId;
  final String mentionId;
  final String notificationMsg;

  AppNotification({
    required this.id,
    this.threadId = "",
    this.mentionId = "",
    required this.notificationMsg,
  });

  Map<String, dynamic> toMap() => {
    'threadId': threadId,
    'mentionId': mentionId,
    'notificationMsg': notificationMsg,
  };

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    return AppNotification(
      id: id,
      threadId: map['threadId'],
      mentionId: map['mentionId'],
      notificationMsg: map['notificationMsg'] ?? "",
    );
  }
}
