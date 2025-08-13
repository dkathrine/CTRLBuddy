import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:uuid/uuid.dart';

class Chat {
  final String id;
  final String participantId1;
  final String participantId2;
  List<Message> messages;

  Chat({
    required this.participantId1,
    required this.participantId2,
    List<Message>? messages,
  }) : messages = messages ?? [],
       id = Uuid().v4();
}
