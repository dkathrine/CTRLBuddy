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
import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/domain/chat.dart';
import 'package:ctrl_buddy/src/domain/comment.dart';
import 'package:ctrl_buddy/src/domain/message.dart';
import 'package:ctrl_buddy/src/domain/appnotification.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

class MockDatabase implements DatabaseRepository {
  final _uuid = Uuid();

  /* Dummy Data Initialization */
  late final List<User> _users;
  late final List<Thread> _threads;
  late final List<Chat> _chats;
  late final List<Comment> _comments;
  late final List<AppNotification> _notifications;
  late final List<Message> _messages;

  MockDatabase() {
    // Create Users
    final user1 = User(
      id: _uuid.v4(),
      name: "John Doe",
      bio: "Gamer and developer",
      profilePicture: "assets/noodlecat.jpeg",
      interests: ["RPG", "FPS"],
    );
    final user2 = User(
      id: _uuid.v4(),
      name: "Max Mustermann",
      bio: "Casual player",
      profilePicture: "assets/noodlecat.jpeg",
      interests: ["MMORPG", "Puzzle"],
    );
    final user3 = User(
      id: _uuid.v4(),
      name: "Alice Wonder",
      bio: "Pro eSports player",
      profilePicture: "assets/noodlecat.jpeg",
      interests: ["MOBA", "Strategy"],
    );

    _users = [user1, user2, user3];

    // Create Threads
    final thread1 = Thread(
      id: _uuid.v4(),
      userId: user1.id,
      username: user1.name,
      userProfilePicture: user1.profilePicture,
      gameId: "game_skyrim",
      gameName: "Elder Scrolls V: Skyrim",
      title: "Best mods for immersion?",
      message: "Looking for mods that make Skyrim more immersive!",
      likes: 15,
    );

    final thread2 = Thread(
      id: _uuid.v4(),
      userId: user2.id,
      username: user2.name,
      userProfilePicture: user2.profilePicture,
      gameId: "game_wow",
      gameName: "World of Warcraft",
      title: "Best class for solo play?",
      message: "Returning player here, what class is best for solo leveling?",
      likes: 8,
    );

    final thread3 = Thread(
      id: _uuid.v4(),
      userId: user3.id,
      username: user3.name,
      userProfilePicture: user3.profilePicture,
      gameId: "game_lol",
      gameName: "League of Legends",
      title: "Best champs for mid lane?",
      message: "I'm trying to climb mid lane this season, any tips?",
      likes: 20,
    );

    _threads = [thread1, thread2, thread3];

    // Link Threads to Users
    user1.threads.add(thread1.id);
    user2.threads.add(thread2.id);
    user3.threads.add(thread3.id);

    // Create Comments
    final comment1 = Comment(
      id: _uuid.v4(),
      userId: user2.id,
      username: user2.name,
      userProfilePicture: user2.profilePicture,
      threadId: thread1.id,
      comment: "Check out 'Immersive Citizens' and 'Frostfall'!",
      likes: 5,
    );

    final comment2 = Comment(
      id: _uuid.v4(),
      userId: user3.id,
      username: user3.name,
      userProfilePicture: user3.profilePicture,
      threadId: thread1.id,
      comment: "Don't forget 'SkyUI', it's a must-have!",
      likes: 3,
    );

    final comment3 = Comment(
      id: _uuid.v4(),
      userId: user1.id,
      username: user1.name,
      userProfilePicture: user1.profilePicture,
      threadId: thread2.id,
      comment: "Hunter is great for solo play!",
      likes: 2,
    );

    _comments = [comment1, comment2, comment3];

    // Create Messages
    final message1 = Message(
      userId: user1.id,
      name: user1.name,
      message: "Hey Max, are you online?",
      dateTime: "2025-09-03 10:00",
    );

    final message2 = Message(
      userId: user2.id,
      name: user2.name,
      message: "Yeah, let's play later!",
      dateTime: "2025-09-03 10:05",
    );

    final message3 = Message(
      userId: user3.id,
      name: user3.name,
      message: "Good luck with your ranked games!",
      dateTime: "2025-09-03 11:00",
    );

    _messages = [message1, message2, message3];

    // Create Chats
    final chat1 = Chat(
      participantId1: user1.id,
      participantId2: user2.id,
      messages: [message1, message2],
    );

    final chat2 = Chat(
      participantId1: user2.id,
      participantId2: user3.id,
      messages: [message3],
    );

    _chats = [chat1, chat2];

    // Create Notifications
    final notification1 = AppNotification(
      threadId: thread1.id,
      mentionId: user3.id,
      notificationMsg: "${user3.name} replied to your thread",
    );

    final notification2 = AppNotification(
      threadId: thread2.id,
      mentionId: user1.id,
      notificationMsg: "${user1.name} commented on your thread",
    );

    _notifications = [notification1, notification2];
  }

  /* Simulated delay */
  Future<void> _simulatedDelay([int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms));

  /* -----------------------User----------------------- */
  /* Read */
  @override
  Future<List<User>> get users async {
    await _simulatedDelay();
    return List.unmodifiable(_users);
  }

  @override
  Future<User?> getUser(String id) async {
    await _simulatedDelay();
    return _users
        .where((p) => p.id == id)
        .cast<User?>()
        .firstWhere((p) => p != null, orElse: () => null);
  }

  /* Create */
  @override
  Future<User> createUser(User draft) async {
    await _simulatedDelay();
    _users.add(draft);

    _userCntrls[draft.id]?.add(draft);

    return draft;
  }

  /* Watch */
  final Map<String, StreamController<User?>> _userCntrls = {};

  @override
  Stream<User?> watchUser(String uid) {
    if (!_userCntrls.containsKey(uid)) {
      late final StreamController<User?> controller;
      controller = StreamController<User?>.broadcast(
        onListen: () async {
          await _simulatedDelay();
          final user = _users
              .where((p) => p.id == uid)
              .cast<User?>()
              .firstWhere((p) => p != null, orElse: () => null);
          controller.add(user);
        },
      );
      _userCntrls[uid] = controller;
    }

    return _userCntrls[uid]!.stream;
  }

  /* Update */
  @override
  Future<void> updateUser(User updated) async {
    await _simulatedDelay();
    final index = _users.indexWhere((p) => p.id == updated.id);
    if (index != -1) _users[index] = updated;
  }

  /* Delete */
  @override
  Future<void> deleteUser(String id) async {
    await _simulatedDelay();
    _users.removeWhere((p) => p.id == id);
  }

  /* -----------------------Chats----------------------- */
  /* Read */
  @override
  Future<List<Chat>> get chats async {
    await _simulatedDelay();
    return List.unmodifiable(_chats);
  }

  @override
  Future<Chat?> getChat(String id) async {
    await _simulatedDelay();
    return _chats
        .where((p) => p.id == id)
        .cast<Chat?>()
        .firstWhere((p) => p != null, orElse: () => null);
  }

  /* Create */
  @override
  Future<Chat> createChat(Chat draft) async {
    await _simulatedDelay();
    _chats.add(draft);
    return draft;
  }

  /* Update */
  @override
  Future<void> updateChat(Chat updated) async {
    await _simulatedDelay();
    final index = _chats.indexWhere((p) => p.id == updated.id);
    if (index != -1) _chats[index] = updated;
  }

  /* Delete */
  @override
  Future<void> deleteChat(String id) async {
    await _simulatedDelay();
    _chats.removeWhere((p) => p.id == id);
  }

  /* -----------------------Comments----------------------- */
  /* Read */
  @override
  Future<List<Comment>> get comments async {
    await _simulatedDelay();
    return List.unmodifiable(_comments);
  }

  @override
  Future<List<Comment>> getThreadComments(String threadId) async {
    await _simulatedDelay();
    return _comments.where((c) => c.threadId == threadId).toList();
  }

  @override
  Future<Comment?> getComment(String id) async {
    await _simulatedDelay();
    return _comments
        .where((p) => p.id == id)
        .cast<Comment?>()
        .firstWhere((p) => p != null, orElse: () => null);
  }

  /* Create */
  @override
  Future<Comment> createComment(Comment draft) async {
    await _simulatedDelay();
    _comments.add(draft);
    return draft;
  }

  /* Update */
  @override
  Future<void> updateComment(Comment updated) async {
    await _simulatedDelay();
    final index = _comments.indexWhere((p) => p.id == updated.id);
    if (index != -1) _comments[index] = updated;
  }

  /* Delete */
  @override
  Future<void> deleteComment(String id) async {
    await _simulatedDelay();
    _comments.removeWhere((p) => p.id == id);
  }

  /* -----------------------Messages----------------------- */
  /* Read */
  @override
  Future<List<Message>> get messages async {
    await _simulatedDelay();
    return List.unmodifiable(_messages);
  }

  @override
  Future<Message?> getMessage(String id) async {
    await _simulatedDelay();
    return _messages
        .where((p) => p.id == id)
        .cast<Message?>()
        .firstWhere((p) => p != null, orElse: () => null);
  }

  /* Create */
  @override
  Future<Message> createMessage(Message draft) async {
    await _simulatedDelay();
    _messages.add(draft);
    return draft;
  }

  /* Update */
  @override
  Future<void> updateMessage(Message updated) async {
    await _simulatedDelay();
    final index = _messages.indexWhere((p) => p.id == updated.id);
    if (index != -1) _messages[index] = updated;
  }

  /* Delete */
  @override
  Future<void> deleteMessage(String id) async {
    await _simulatedDelay();
    _messages.removeWhere((p) => p.id == id);
  }

  /* -----------------------Notifications----------------------- */
  /* Read */
  @override
  Future<List<AppNotification>> get notifications async {
    await _simulatedDelay();
    return List.unmodifiable(_notifications);
  }

  @override
  Future<AppNotification?> getNotification(String id) async {
    await _simulatedDelay();
    return _notifications
        .where((p) => p.id == id)
        .cast<AppNotification?>()
        .firstWhere((p) => p != null, orElse: () => null);
  }

  /* Create */
  @override
  Future<AppNotification> createNotification(AppNotification draft) async {
    await _simulatedDelay();
    _notifications.add(draft);
    return draft;
  }

  /* Update */
  @override
  Future<void> updateNotification(AppNotification updated) async {
    await _simulatedDelay();
    final index = _notifications.indexWhere((p) => p.id == updated.id);
    if (index != -1) _notifications[index] = updated;
  }

  /* Delete */
  @override
  Future<void> deleteNotification(String id) async {
    await _simulatedDelay();
    _notifications.removeWhere((p) => p.id == id);
  }

  /* -----------------------Threads----------------------- */
  /* Read */
  @override
  Future<List<Thread>> get threads async {
    await _simulatedDelay();
    return List.unmodifiable(_threads);
  }

  @override
  Future<List<Thread>> get popularThreads async {
    await _simulatedDelay();
    final sorted = [..._threads];
    sorted.sort((a, b) => b.likes.compareTo(a.likes));
    return List.unmodifiable(sorted.take(10));
  }

  @override
  Future<Thread?> getThread(String id) async {
    await _simulatedDelay();
    return _threads
        .where((p) => p.id == id)
        .cast<Thread?>()
        .firstWhere((p) => p != null, orElse: () => null);
  }

  /* Create */
  @override
  Future<Thread> createThread(Thread draft) async {
    await _simulatedDelay();
    _threads.add(draft);
    return draft;
  }

  /* Update */
  @override
  Future<void> updateThread(Thread updated) async {
    await _simulatedDelay();
    final index = _threads.indexWhere((p) => p.id == updated.id);
    if (index != -1) _threads[index] = updated;
  }

  /* Delete */
  @override
  Future<void> deleteThread(String id) async {
    await _simulatedDelay();
    _threads.removeWhere((p) => p.id == id);
  }
}
