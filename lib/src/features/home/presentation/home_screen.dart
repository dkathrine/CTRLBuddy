import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/features/thread/presentation/thread_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:ctrl_buddy/src/common/widgets/interest_chip.dart';
import 'package:ctrl_buddy/src/common/widgets/content_card.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseRepository db;

  late Future<List<Thread>> _popularThreads;

  @override
  void initState() {
    super.initState();
    //db = Provider.of<MockDatabase>(context, listen: false);
    db = context.read<DatabaseRepository>();
    _popularThreads = db.popularThreads;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    InterestChip(interest: 'League of Legends'),
                    InterestChip(interest: 'Warframe'),
                    InterestChip(interest: 'World of Warcraft'),
                    InterestChip(interest: 'Elden Ring'),
                    InterestChip(interest: 'Baldurs Gate 3'),
                    InterestChip(interest: 'Black Desert'),
                    InterestChip(interest: 'Zennless Zone Zero'),
                    InterestChip(interest: 'Monster Hunter Wilds'),
                    InterestChip(interest: 'Overwatch'),
                  ],
                ),
              ),
            ),
            /* msg_button */
            SizedBox(width: /* 5 */ 0),
          ],
        ),
        Text('Popular', style: Theme.of(context).textTheme.headlineLarge),
        Expanded(
          child: FutureBuilder(
            future: _popularThreads,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                return Center(child: Text('Error: ${asyncSnapshot.error}'));
              } else if (!asyncSnapshot.hasData ||
                  asyncSnapshot.data!.isEmpty) {
                return const Center(child: Text('No popular threads found.'));
              }

              final threads = asyncSnapshot.data!;

              return SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 22,
                  runSpacing: 22,
                  children: threads.map((thread) {
                    return FutureBuilder(
                      future: db.getUser(thread.userId),
                      builder: (context, snapshot) {
                        return ContentCard(
                          threadId: thread.id,
                          image: 'assets/noodlecat.jpeg',
                          title: thread.title,
                          author: snapshot.data?.name ?? "Unknown",
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
    );
  }
}
