import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/domain/chat.dart';
import 'package:ctrl_buddy/src/domain/comment.dart';
import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:ctrl_buddy/src/domain/appnotification.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

abstract class DatabaseRepository {
  /* User */
  /* Read */
  List<User> get users;

  User? getUser(String id);

  /* Create */
  User createUser(User draft);

  /* Update */
  void updateUser(User updated);

  /* Delete */
  void deleteUser(String id);

  /* Chats */
  /* Read */
  List<Chat> get chats;

  Chat? getChat(String id);

  /* Create */
  Chat createChat(Chat draft);

  /* Update */
  void updateChat(Chat updated);

  /* Delete */
  void deleteChat(String id);

  /* Comments */
  /* Read */
  List<Comment> get comments;

  Comment? getComment(String id);

  /* Create */
  Comment createComment(Comment draft);

  /* Update */
  void updateComment(Comment updated);

  /* Delete */
  void deleteComment(String id);

  /* Messages */
  /* Read */
  List<Message> get messages;

  Message? getMessage(String id);

  /* Create */
  Message createMessage(Message draft);

  /* Update */
  void updateMessage(Message updated);

  /* Delete */
  void deleteMessage(String id);

  /* Notifications */
  /* Read */
  List<AppNotification> get notifications;

  AppNotification? getNotification(String id);

  /* Create */
  AppNotification createNotification(AppNotification draft);

  /* Update */
  void updateNotification(AppNotification updated);

  /* Delete */
  void deleteNotification(String id);

  /* Threads */
  /* Read */
  List<Thread> get threads;

  Thread? getThread(String id);

  /* Create */
  Thread createThread(Thread draft);

  /* Update */
  void updateThread(Thread updated);

  /* Delete */
  void deleteThread(String id);
}
