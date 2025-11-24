import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/common/widgets/content_card.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.gameName});

  final String gameName;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late DatabaseRepository db;

  late Future<List<Thread>> _categoryThreads;

  @override
  void initState() {
    super.initState();
    db = context.read<DatabaseRepository>();
    _categoryThreads = db.getCategoryThread(widget.gameName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 28, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(LucideIcons.arrowLeft, size: 42),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    '${widget.gameName}',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.96,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: FutureBuilder(
                future: _categoryThreads,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (asyncSnapshot.hasError) {
                    return Center(child: Text('Error: ${asyncSnapshot.error}'));
                  } else if (!asyncSnapshot.hasData ||
                      asyncSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No threads found.'));
                  }

                  final threads = asyncSnapshot.data!;

                  return SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 22,
                      runSpacing: 22,
                      children: threads.map((thread) {
                        return FutureBuilder(
                          future: Future.wait([
                            db.getUser(thread.userId),
                            db.getGameById(thread.gameId),
                          ]),
                          builder:
                              (context, AsyncSnapshot<List<dynamic>> snapshot) {
                                final user = snapshot.data?[0];
                                final game = snapshot.data?[1];

                                return ContentCard(
                                  threadId: thread.id,
                                  coverImage:
                                      game?.coverUrl ??
                                      'https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png',
                                  image:
                                      user?.profilePicture ??
                                      'assets/default_profile.png',
                                  title: thread.title,
                                  author: user?.name ?? "Deleted User",
                                  desc: thread.message,
                                );
                              },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
