import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/domain/chat.dart';
import 'package:ctrl_buddy/src/domain/comment.dart';
import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:ctrl_buddy/src/domain/appnotification.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

class FirestoreDatabaseRepository implements DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  /* -----------------------User----------------------- */
  /* Read */
  @override
  Future<List<User>> get users async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => User.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<User?> getUser(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return User.fromMap(doc.id, doc.data()!);
  }

  /* Create */
  @override
  Future<User> createUser(User draft) async {
    await _firestore.collection('users').doc(draft.id).set(draft.toMap());
    return draft;
  }

  /* Update */
  @override
  Future<void> updateUser(User updated) async {
    await _firestore
        .collection('users')
        .doc(updated.id)
        .update(updated.toMap());
  }

  /* Delete */
  @override
  Future<void> deleteUser(String id) async {
    await _firestore.collection('users').doc(id).delete();
  }

  /* Watch */
  @override
  Stream<User?> watchUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return User.fromMap(doc.id, doc.data()!);
    });
  }

  /* -----------------------Threads----------------------- */
  /* Read */
  @override
  Future<List<Thread>> get threads async {
    final snapshot = await _firestore.collection('threads').get();
    return snapshot.docs
        .map((doc) => Thread.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<Thread>> get popularThreads async {
    final snapshot = await _firestore.collection('threads').get();
    final threads = snapshot.docs
        .map((doc) => Thread.fromMap(doc.id, doc.data()))
        .toList();

    threads.sort((a, b) => b.likes.compareTo(a.likes));
    return threads.take(10).toList();
  }

  @override
  Future<Thread?> getThread(String id) async {
    final doc = await _firestore.collection('threads').doc(id).get();
    if (!doc.exists) return null;
    return Thread.fromMap(doc.id, doc.data()!);
  }

  /* Create */
  @override
  Future<Thread> createThread(Thread draft) async {
    await _firestore
        .collection('threads') /* .doc(draft.id) */
        .add(draft.toMap());
    return draft;
  }

  /* Update */
  @override
  Future<void> updateThread(Thread updated) async {
    await _firestore
        .collection('threads')
        .doc(updated.id)
        .update(updated.toMap());
  }

  /* Delete */
  @override
  Future<void> deleteThread(String id) async {}

  /* -----------------------Comments----------------------- */
  /* Read */
  @override
  Future<List<Comment>> get comments async {
    final snapshot = await _firestore.collection('comments').get();
    return snapshot.docs
        .map((doc) => Comment.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<Comment>> getThreadComments(String threadId) async {
    final snapshot = await _firestore
        .collection('comments')
        .where(threadId, isEqualTo: threadId)
        .get();
    return snapshot.docs
        .map((doc) => Comment.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<Comment?> getComment(String id) async {
    final doc = await _firestore.collection('comments').doc(id).get();
    if (!doc.exists) return null;
    return Comment.fromMap(doc.id, doc.data()!);
  }

  /* Create */
  @override
  Future<Comment> createComment(Comment draft) async {
    await _firestore
        .collection('comments') /* .doc(draft.id) */
        .add(draft.toMap());
    return draft;
  }

  /* Update */
  @override
  Future<void> updateComment(Comment updated) async {
    await _firestore
        .collection('comments')
        .doc(updated.id)
        .update(updated.toMap());
  }

  /* Delete */
  @override
  Future<void> deleteComment(String id) async {
    await _firestore.collection('comments').doc(id).delete();
  }

  /* -----------------------Notifications----------------------- */
  /* Read */
  @override
  Future<List<AppNotification>> get notifications async {
    final snapshot = await _firestore.collection('notifications').get();
    return snapshot.docs
        .map((doc) => AppNotification.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<AppNotification?> getNotification(String id) async {
    final doc = await _firestore.collection('notifications').doc(id).get();
    if (!doc.exists) return null;
    return AppNotification.fromMap(doc.id, doc.data()!);
  }

  /* Create */
  @override
  Future<AppNotification> createNotification(AppNotification draft) async {
    await _firestore
        .collection('notifications')
        /*.doc(draft.id)
         */
        .add(draft.toMap());
    return draft;
  }

  /* Update */
  @override
  Future<void> updateNotification(AppNotification updated) async {
    await _firestore
        .collection('notifications')
        .doc(updated.id)
        .update(updated.toMap());
  }

  /* Delete */
  @override
  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }

  /* -----------------------Chats----------------------- */
  /* Read */
  @override
  Future<List<Chat>> get chats async {
    final snapshot = await _firestore.collection('chats').get();
    return snapshot.docs
        .map((doc) => Chat.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<Chat?> getChat(String id) async {
    final doc = await _firestore.collection('chats').doc(id).get();
    if (!doc.exists) return null;
    return Chat.fromMap(doc.id, doc.data()!);
  }

  /* Create */
  @override
  Future<Chat> createChat(Chat draft) async {
    await _firestore
        .collection('chats') /* .doc(draft.id) */
        .add(draft.toMap());
    return draft;
  }

  /* Update */
  @override
  Future<void> updateChat(Chat updated) async {
    await _firestore
        .collection('chats')
        .doc(updated.id)
        .update(updated.toMap());
  }

  /* Delete */
  @override
  Future<void> deleteChat(String id) async {
    await _firestore.collection('chats').doc(id).delete();
  }

  /* -----------------------Messages----------------------- */
  /* Read */
  @override
  Future<List<Message>> get messages async {
    final snapshot = await _firestore.collection('messages').get();
    return snapshot.docs
        .map((doc) => Message.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<Message?> getMessage(String id) async {
    final doc = await _firestore.collection('messages').doc(id).get();
    if (!doc.exists) return null;
    return Message.fromMap(doc.id, doc.data()!);
  }

  /* Create */
  @override
  Future<Message> createMessage(Message draft) async {
    await _firestore
        .collection('messages') /* .doc(draft.id) */
        .add(draft.toMap());
    return draft;
  }

  /* Update */
  @override
  Future<void> updateMessage(Message updated) async {
    await _firestore
        .collection('messages')
        .doc(updated.id)
        .update(updated.toMap());
  }

  /* Delete */
  @override
  Future<void> deleteMessage(String id) async {
    await _firestore.collection('messages').doc(id).delete();
  }
}
