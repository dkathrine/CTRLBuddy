/* 
99% of the following code doesn't make sense and will not be implemented like this in any ways. 
After learning about databases in dart all of this will be revisited and updated to make sense and use correct syntax


Aufgabe 1:
Tabelle der Daten und Datentypen meiner App-Idee
Daten                               |           Datentyp
------------------------------------|------------------------------------------
Liste aller beliebten Beiträge      | List<PopularThread>
Liste aller Games                   | List<String Game>
Liste aller Kommentare              | List<Comment>
Liste aller Chats                   | List<Chat>
Liste aller Nachrichten eines Chats | List<Message>
Liste aller Benachrichtigungen      | List<Notification>
Liste der Suchergebnisse            | List<SearchResult>
Nachricht                           | String message, String userId, String time
Kommentar                           | String comment, String userId, String time
Benachrichtigung                    | String notification, String userId || String threadId, String time
Profil                              | File ProfilePicture, String Username, String Status, String Bio, List<Interest>, List<OwnThread>, String userId
Chat                                | String userId, String lastMessage, String time
Thread                              | String title, String threadDesc, String gameId, String userId
*/
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/domain/chat.dart';
import 'package:ctrl_buddy/src/domain/comment.dart';
import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:ctrl_buddy/src/domain/appnotification.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

class MockDatabase implements DatabaseRepository {
  /* Users */
  List<User> _users = [User(name: "John Doe"), User(name: "Max Mustermann")];

  /* Threads */
  List<Thread> _threads = [];

  /* Chats */
  List<Chat> _chats = [];

  /* Comments */
  List<Comment> _comments = [];

  /* Notifications */
  List<AppNotification> _notifications = [];

  /* Messages */
  List<Message> _messages = [];

  /* User */
  /* Read */
  List<User> get users => List.unmodifiable(_users);

  User? getUser(String id) => _users
      .where((p) => p.id == id)
      .cast<User?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  User createUser(User draft) {
    _users.add(draft);
    return draft;
  }

  /* Update */
  void updateUser(User updated) {
    final index = _users.indexWhere((p) => p.id == updated.id);
    if (index != -1) _users[index] = updated;
  }

  /* Delete */
  void deleteUser(String id) {
    _users.removeWhere((p) => p.id == id);
  }

  /* Chats */
  /* Read */
  List<Chat> get chats => List.unmodifiable(_chats);

  Chat? getChat(String id) => _chats
      .where((p) => p.id == id)
      .cast<Chat?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  Chat createChat(Chat draft) {
    _chats.add(draft);
    return draft;
  }

  /* Update */
  void updateChat(Chat updated) {
    final index = _chats.indexWhere((p) => p.id == updated.id);
    if (index != -1) _chats[index] = updated;
  }

  /* Delete */
  void deleteChat(String id) {
    _chats.removeWhere((p) => p.id == id);
  }

  /* Comments */
  /* Read */
  List<Comment> get comments => List.unmodifiable(_comments);

  Comment? getComment(String id) => _comments
      .where((p) => p.id == id)
      .cast<Comment?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  Comment createComment(Comment draft) {
    _comments.add(draft);

    final thread = _threads.firstWhere(
      (p) => p.id == draft.threadId,
      orElse: () => throw Exception("Thread not found for comment"),
    );
    thread.comments.add(draft);

    return draft;
  }

  /* Update */
  void updateComment(Comment updated) {
    final index = _comments.indexWhere((p) => p.id == updated.id);
    if (index != -1) _comments[index] = updated;

    final thread = _threads
        .where((p) => p.id == updated.threadId)
        .cast<Thread?>()
        .firstWhere((p) => p != null, orElse: () => null);
    if (thread != null) {
      final idComment = thread.comments.indexWhere((c) => c.id == updated.id);
      if (idComment != -1) thread.comments[idComment] = updated;
    }
  }

  /* Delete */
  void deleteComment(String id) {
    _comments.removeWhere((p) => p.id == id);

    final comment = _comments
        .where((p) => p.id == id)
        .cast<Comment?>()
        .firstWhere((p) => p != null, orElse: () => null);
    if (comment == null) return;

    final thread = _threads
        .where((p) => p.id == comment.threadId)
        .cast<Thread?>()
        .firstWhere((p) => p != null, orElse: () => null);
    thread?.comments.removeWhere((c) => c.id == id);
  }

  /* Messages */
  /* Read */
  List<Message> get messages => List.unmodifiable(_messages);

  Message? getMessage(String id) => _messages
      .where((p) => p.id == id)
      .cast<Message?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  Message createMessage(Message draft) {
    _messages.add(draft);
    return draft;
  }

  /* Update */
  void updateMessage(Message updated) {
    final index = _messages.indexWhere((p) => p.id == updated.id);
    if (index != -1) _messages[index] = updated;
  }

  /* Delete */
  void deleteMessage(String id) {
    _messages.removeWhere((p) => p.id == id);
  }

  /* Notifications */
  /* Read */
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  AppNotification? getNotification(String id) => _notifications
      .where((p) => p.id == id)
      .cast<AppNotification?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  AppNotification createNotification(AppNotification draft) {
    _notifications.add(draft);
    return draft;
  }

  /* Update */
  void updateNotification(AppNotification updated) {
    final index = _notifications.indexWhere((p) => p.id == updated.id);
    if (index != -1) _notifications[index] = updated;
  }

  /* Delete */
  void deleteNotification(String id) {
    _notifications.removeWhere((p) => p.id == id);
  }

  /* Threads */
  /* Read */
  List<Thread> get threads => List.unmodifiable(_threads);

  List<Thread> get popularThreads {
    final sorted = [...threads];
    sorted.sort((a, b) => b.likes.compareTo(a.likes));
    return List.unmodifiable(sorted.take(10));
  }

  Thread? getThread(String id) => _threads
      .where((p) => p.id == id)
      .cast<Thread?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  Thread createThread(Thread draft) {
    _threads.add(draft);
    return draft;
  }

  /* Update */
  void updateThread(Thread updated) {
    final index = _threads.indexWhere((p) => p.id == updated.id);
    if (index != -1) _threads[index] = updated;
  }

  /* Delete */
  void deleteThread(String id) {
    _threads.removeWhere((p) => p.id == id);
  }
}
