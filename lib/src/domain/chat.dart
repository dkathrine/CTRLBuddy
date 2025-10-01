import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:uuid/uuid.dart';

class Chat {
  final String id;
  final String participantId1;
  final String participantId2;
  List<Message> messages;

  Chat({
    required this.id,
    required this.participantId1,
    required this.participantId2,
    List<Message>? messages,
  }) : messages = messages ?? [];

  Map<String, dynamic> toMap() => {
    'participantId1': participantId1,
    'participantId2': participantId2,
    'messages': messages,
  };

  factory Chat.fromMap(String id, Map<String, dynamic> map) {
    return Chat(
      id: id,
      participantId1: map['participantId1'],
      participantId2: map['participantId2'],
      messages: List<Message>.from(map['messages'] ?? []),
    );
  }
}
