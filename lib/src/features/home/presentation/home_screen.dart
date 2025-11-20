import 'package:ctrl_buddy/src/data/auth_repository.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/data/interests_provider.dart';
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
    final auth = context.watch<AuthRepository>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, authSnapshot) {
            final fbUser = authSnapshot.data;

            if (fbUser == null) {
              return Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Please log in to see your interests',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                ],
              );
            }

            return FutureBuilder<User?>(
              future: db.getUser(fbUser.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 8,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 0),
                    ],
                  );
                }

                final user = userSnapshot.data;

                if (user == null) {
                  return Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 8,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'No interests found',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 0),
                    ],
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final interestsProvider = context.read<InterestsProvider>();
                  if (interestsProvider.interests.isEmpty &&
                      user.interests.isNotEmpty) {
                    interestsProvider.loadInterests(user.interests);
                  }
                });

                return Consumer<InterestsProvider>(
                  builder: (context, interestsProvider, child) {
                    if (interestsProvider.isLoading) {
                      return Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 0),
                        ],
                      );
                    }

                    final interests = interestsProvider.interests;

                    if (interests.isEmpty) {
                      return Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'No interests added yet',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 0),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 8,
                              children: interests
                                  .map(
                                    (interest) =>
                                        InterestChip(interest: interest),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        SizedBox(width: 0),
                      ],
                    );
                  },
                );
              },
            );
          },
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
                      future: Future.wait([
                        db.getUser(thread.userId),
                        db.getGameById(thread.gameId),
                      ]),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
    );
  }
}
