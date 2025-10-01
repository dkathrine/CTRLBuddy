import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/domain/chat.dart';
import 'package:ctrl_buddy/src/domain/comment.dart';
import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:ctrl_buddy/src/domain/appnotification.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

abstract class DatabaseRepository {
  /* User */
  /* Read */
  Future<List<User>> get users;

  Future<User?> getUser(String id);

  /* Create */
  Future<User> createUser(User draft);

  /* Watch */
  Stream<User?> watchUser(String uid);

  /* Update */
  Future<void> updateUser(User updated);

  /* Delete */
  Future<void> deleteUser(String id);

  /* Chats */
  /* Read */
  Future<List<Chat>> get chats;

  Future<Chat?> getChat(String id);

  /* Create */
  Future<Chat> createChat(Chat draft);

  /* Update */
  Future<void> updateChat(Chat updated);

  /* Delete */
  Future<void> deleteChat(String id);

  /* Comments */
  /* Read */
  Future<List<Comment>> get comments;

  Future<Comment?> getComment(String id);

  Future<List<Comment>> getThreadComments(String threadId);
  /* Create */
  Future<Comment> createComment(Comment draft);

  /* Update */
  Future<void> updateComment(Comment updated);

  /* Delete */
  Future<void> deleteComment(String id);

  /* Messages */
  /* Read */
  Future<List<Message>> get messages;

  Future<Message?> getMessage(String id);

  /* Create */
  Future<Message> createMessage(Message draft);

  /* Update */
  Future<void> updateMessage(Message updated);

  /* Delete */
  Future<void> deleteMessage(String id);

  /* Notifications */
  /* Read */
  Future<List<AppNotification>> get notifications;

  Future<AppNotification?> getNotification(String id);

  /* Create */
  Future<AppNotification> createNotification(AppNotification draft);

  /* Update */
  Future<void> updateNotification(AppNotification updated);

  /* Delete */
  Future<void> deleteNotification(String id);

  /* Threads */
  /* Read */
  Future<List<Thread>> get threads;

  Future<Thread?> getThread(String id);

  /* Create */
  Future<Thread> createThread(Thread draft);

  /* Update */
  Future<void> updateThread(Thread updated);

  /* Delete */
  Future<void> deleteThread(String id);

  /* Helper to get most liked/popular threads */
  Future<List<Thread>> get popularThreads;
}
