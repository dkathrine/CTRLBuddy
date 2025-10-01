import 'package:uuid/uuid.dart';

class Message {
  final String id;
  final String userId;
  final String name;
  final String message;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.userId,
    required this.name,
    required this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'name': name,
    'userId': userId,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Message.fromMap(String id, Map<String, dynamic> map) {
    return Message(
      id: id,
      userId: map['userId'],
      name: map['name'],
      message: map['message'] ?? "",
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
