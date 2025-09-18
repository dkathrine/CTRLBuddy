import 'package:ctrl_buddy/src/common/widgets/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/common/widgets/search_card.dart';
import 'package:ctrl_buddy/src/domain/thread.dart' as model;
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/data/mock_db.dart';

class ExploreOverview extends StatefulWidget {
  const ExploreOverview({super.key});

  @override
  State<ExploreOverview> createState() => _ExploreOverviewState();
}

class _ExploreOverviewState extends State<ExploreOverview> {
  late Future<List<model.Thread>> _threads;

  @override
  void initState() {
    super.initState();
    //final db = Provider.of<MockDatabase>(context, listen: false);
    final db = context.read<MockDatabase>();
    _threads = db.threads;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        MessageBar(hintText: "Search"),
        SizedBox(height: 16),
        Expanded(
          child: FutureBuilder(
            future: _threads,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                return Center(child: Text('Error: ${asyncSnapshot.error}'));
              } else if (!asyncSnapshot.hasData ||
                  asyncSnapshot.data!.isEmpty) {
                return const Center(child: Text('No threads found.'));
              }

              final threads = asyncSnapshot.data!;

              /* Grouping threads by game */
              final Map<String, List<model.Thread>> grouped = {};
              for (var thread in threads) {
                grouped.putIfAbsent(thread.gameName, () => []).add(thread);
              }

              /* creating list of games with stats for further sorting */
              final List<GameStats> games = grouped.entries.map((entry) {
                final gameName = entry.key;
                final gameThreads = entry.value;
                final totalLikes = gameThreads.fold<int>(
                  0,
                  (sum, t) => sum + t.likes,
                );

                return GameStats(
                  gameName: gameName,
                  threadCount: gameThreads.length,
                  totalLikes: totalLikes,
                );
              }).toList();

              /* sort by threadCount and then by totalLikes to determine the most active category of games */
              games.sort((a, b) {
                if (b.threadCount != a.threadCount) {
                  return b.threadCount.compareTo(a.threadCount);
                }
                return b.totalLikes.compareTo(a.totalLikes);
              });

              return SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: games.map((game) {
                    return SearchCard(gameName: game.gameName);
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GameStats {
  final String gameName;
  final int threadCount;
  final int totalLikes;

  GameStats({
    required this.gameName,
    required this.threadCount,
    required this.totalLikes,
  });
}
