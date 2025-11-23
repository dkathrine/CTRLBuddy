import 'package:ctrl_buddy/src/common/widgets/horizontal_card.dart';
import 'package:ctrl_buddy/src/common/widgets/interest_chip.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/data/interests_provider.dart';
//import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/data/auth_repository.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/features/login_screen/presentation/complete_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    context.read<InterestsProvider>().clearInterests();
    await context.read<AuthRepository>().signOut();
  }

  Future<void> _deleteProfile(BuildContext context, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: const Text(
            'Are you sure you want to delete your profile? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).textColor,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final db = context.read<DatabaseRepository>();
        await context.read<AuthRepository>().deleteCurrentUser();
        await context.read<AuthRepository>().signOut();
        context.read<InterestsProvider>().clearInterests();
        await db.deleteUser(userId);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final fbUser = snapshot.data;
        if (fbUser == null) {
          return const Center(child: Text("Not logged in"));
        }

        final db = context.read<DatabaseRepository>();

        return StreamBuilder<User?>(
          stream: db.watchUser(fbUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data;
            if (user == null) {
              return const Center(child: Text("No profile found"));
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              final interestsProvider = context.read<InterestsProvider>();
              if (interestsProvider.interests.isEmpty &&
                  user.interests.isNotEmpty) {
                interestsProvider.loadInterests(user.interests);
              }
            });

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox.shrink(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                _deleteProfile(context, fbUser.uid),
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CompleteProfileScreen(uid: fbUser.uid),
                              ),
                            ),
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _signOut(context),
                            icon: Icon(Icons.logout),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  SingleChildScrollView(
                    child: Column(
                      spacing: 16,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(user.profilePicture),
                            ),
                            SizedBox(height: 4),
                            Text(
                              user.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              "Status",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Column(
                          spacing: 4,
                          children: [
                            Text(
                              "Bio",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: Theme.of(context).accentGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    user.bio.isEmpty ? "" : user.bio,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Your Threads",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                Text(
                                  "Show All",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            FutureBuilder(
                              future: db.getThreadsByIds(user.threads),
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final userThreads = asyncSnapshot.data ?? [];

                                if (userThreads.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "No threads posted yet",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  );
                                }

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: [
                                          for (
                                            int i = 0;
                                            i < userThreads.length;
                                            i++
                                          )
                                            if (i.isEven)
                                              HorizontalCard(
                                                gameId: userThreads[i].gameId,
                                                title: userThreads[i].title,
                                                desc: userThreads[i].message,
                                                authorId: userThreads[i].userId,
                                                threadId: userThreads[i].id,
                                              ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: [
                                          for (
                                            int i = 0;
                                            i < userThreads.length;
                                            i++
                                          )
                                            if (i.isOdd)
                                              HorizontalCard(
                                                gameId: userThreads[i].gameId,
                                                title: userThreads[i].title,
                                                desc: userThreads[i].message,
                                                authorId: userThreads[i].userId,
                                                threadId: userThreads[i].id,
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Your Interests",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                Text(
                                  "Show All",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Consumer<InterestsProvider>(
                              builder: (context, interestsProvider, child) {
                                if (interestsProvider.isLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (interestsProvider.error != null) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      interestsProvider.error!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  );
                                }

                                if (!interestsProvider.hasInterests) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "No interests added yet",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  );
                                }

                                final interests = interestsProvider.interests;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: [
                                          for (
                                            int i = 0;
                                            i < interests.length;
                                            i++
                                          )
                                            if (i.isEven)
                                              InterestChip(
                                                interest: interests[i],
                                              ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Wrap(
                                        spacing: 16,
                                        runSpacing: 16,
                                        children: [
                                          for (
                                            int i = 0;
                                            i < interests.length;
                                            i++
                                          )
                                            if (i.isOdd)
                                              InterestChip(
                                                interest: interests[i],
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
