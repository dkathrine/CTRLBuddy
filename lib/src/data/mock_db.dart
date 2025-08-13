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
import 'package:ctrl_buddy/src/domain/notification.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

class MockDatabase implements DatabaseRepository {
  /* Threads */
  List<Thread> allThreads = [];
  List<Thread> popularThreads = [];

  /* Chats */
  List<Chat> allChats = [];

  /* Comments */
  List<Comment> allComments = [];

  /* Notifications */
  List<Notification> getNotifications = [];

  /* Messages */
  List<Message> getMessages = [];

  /* Users */
  List<User> allUsers = [User(name: "John Doe"), User(name: "Max Mustermann")];

  /* User */
  /* Read */
  List<User> get users => List.unmodifiable(allUsers);

  User? getUser(String id) => allUsers
      .where((p) => p.id == id)
      .cast<User?>()
      .firstWhere((p) => p != null, orElse: () => null);

  /* Create */
  User createUser(User draft);

  /* Update */
  void updateUser(User updated);

  /* Delete */
  void deleteUser(String id);

  /* Chats */
  /* Read */
  List<Chat> get chats => List.unmodifiable(allChats);

  Chat? getChat(String id);

  /* Create */
  Chat createChat(Chat draft);

  /* Update */
  void updateChat(Chat updated);

  /* Delete */
  void deleteChat(String id);

  /* Comments */
  /* Read */
  List<Comment> get comments => List.unmodifiable(allComments);

  Comment? getComment(String id);

  /* Create */
  Comment createComment(Comment draft);

  /* Update */
  void updateComment(Comment updated);

  /* Delete */
  void deleteComment(String id);

  /* Messages */
  /* Read */
  List<Message> get messages => List.unmodifiable(getMessages);

  Message? getMessage(String id);

  /* Create */
  Message createMessage(Message draft);

  /* Update */
  void updateMessage(Message updated);

  /* Delete */
  void deleteMessage(String id);

  /* Notifications */
  /* Read */
  List<Notification> get notifications => List.unmodifiable(getNotifications);

  Notification? getNotification(String id);

  /* Create */
  Notification createNotification(Notification draft);

  /* Update */
  void updateNotification(Notification updated);

  /* Delete */
  void deleteNotification(String id);

  /* Threads */
  /* Read */
  List<Thread> get threads => List.unmodifiable(allThreads);

  Thread? getThread(String id);

  /* Create */
  Thread createThread(Thread draft);

  /* Update */
  void updateThread(Thread updated);

  /* Delete */
  void deleteThread(String id);
}
