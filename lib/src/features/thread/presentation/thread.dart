import 'package:ctrl_buddy/src/data/auth_repository.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ctrl_buddy/src/common/widgets/comment.dart';
import 'package:ctrl_buddy/src/common/widgets/message_bar.dart';
import 'package:ctrl_buddy/src/domain/comment.dart' as model;
import 'package:ctrl_buddy/src/domain/thread.dart' as model;
import 'package:ctrl_buddy/src/domain/user.dart';
//import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:provider/provider.dart';

class Thread extends StatefulWidget {
  const Thread({super.key, required this.id});

  final String id;

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  late DatabaseRepository db;

  late Future<ThreadData> _threadData;

  @override
  void initState() {
    super.initState();
    //db = Provider.of<MockDatabase>(context, listen: false);
    db = context.read<DatabaseRepository>();
    _loadThread();
  }

  void _loadThread() {
    _threadData = db.getThread(widget.id).then((thread) async {
      if (thread == null) throw Exception("Thread not found");
      final author = await db.getUser(thread.userId);
      //final comments = await db.getThreadComments(widget.id);
      return ThreadData(
        thread: thread,
        author: author /* comments: comments */,
      );
    });
    setState(() {});
  }

  Future<void> _addComment(String commentText) async {
    if (commentText.trim().isEmpty) return;

    debugPrint("comment posted");
    final threadData = await _threadData;

    final auth = context.read<AuthRepository>();

    final curUser = auth.getCurrentUserId();

    if (curUser == null) {
      debugPrint("No logged-in User found!");
      return;
    }

    final user = await db.getUser(curUser);
    if (user == null) {
      debugPrint("User not found");
      return;
    }

    final comment = model.Comment(
      id: "",
      userId: user.id,
      username: user.name,
      userProfilePicture: user.profilePicture,
      threadId: threadData.thread.id,
      comment: commentText,
    );
    await db.createComment(comment);
    //_loadThread();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _threadData,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }

        final data = asyncSnapshot.data!;
        final thread = data.thread;
        final author = data.author;
        final authorName = author?.name ?? "Deleted User";
        final authorProfilePicture =
            author?.profilePicture ?? "assets/default_profile.png";
        //final comments = data.comments;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(16, 28, 16, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(LucideIcons.arrowLeft, size: 42),
                            ),
                            Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        authorProfilePicture,
                                      ),
                                      radius: 16,
                                    ),
                                    Text(
                                      authorName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    thread.title,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        /* GestureDetector(
                          child: Icon(LucideIcons.moreVertical, size: 35),
                        ), */
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 120),
                        child: Wrap(
                          children: [
                            Column(
                              children: [
                                Column(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      thread.message,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          spacing: 4,
                                          children: [
                                            GestureDetector(
                                              child: Icon(
                                                LucideIcons.heart,
                                                size: 24,
                                              ),
                                            ),
                                            Text(
                                              thread.likes.toString(),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelLarge,
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          child: Icon(
                                            LucideIcons.bookmark,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(
                                  color: Color(0xFF666666),
                                  thickness: 1,
                                  height: 1,
                                ),
                              ],
                            ),

                            StreamBuilder<List<model.Comment>>(
                              stream: db.watchThreadComments(widget.id),
                              builder: (context, commentSnapshot) {
                                if (commentSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (commentSnapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error loading comments ${commentSnapshot.error}',
                                    ),
                                  );
                                }

                                final comments = commentSnapshot.data ?? [];

                                return Column(
                                  children: comments.map((c) {
                                    return Comment(
                                      userId: c.userId,
                                      username: c.username,
                                      threadId: c.threadId,
                                      comment: c.comment,
                                      likes: c.likes,
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 48,
                left: 26,
                right: 26,
                child: SafeArea(
                  child: MessageBar(
                    hintText: "Write a comment...",
                    onSend: _addComment,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThreadData {
  final model.Thread thread;
  final User? author;
  //final List<model.Comment> comments;

  ThreadData({
    required this.thread,
    required this.author,
    //required this.comments,
  });
}
