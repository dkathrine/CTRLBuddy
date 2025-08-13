import 'package:uuid/uuid.dart';

class Message {
  final String id;
  final String userId;
  final String name;
  final String message;
  final String dateTime;

  Message({
    required this.userId,
    required this.name,
    required this.message,
    this.dateTime = "",
  }) : id = Uuid().v4();
}
