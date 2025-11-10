// lib/src/screens/complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
import 'package:ctrl_buddy/src/domain/game.dart';
import 'package:ctrl_buddy/src/common/widgets/game_picker.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _bioCtrl = TextEditingController();

  bool _loading = false;
  bool _loadingUser = true;
  User? _existingUser;

  // interest ids (game doc ids)
  final List<String> _interestIds = <String>[];
  // cache for game metadata to show labels/covers
  final Map<String, Game> _interestGames = {};

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() => _loadingUser = true);
    try {
      final db = Provider.of<DatabaseRepository>(context, listen: false);
      final user = await db.getUser(widget.uid);
      if (user != null) {
        _existingUser = user;
        _usernameCtrl.text = user.name;
        _bioCtrl.text = user.bio;
        _interestIds.clear();
        _interestIds.addAll(user.interests);

        // Try to fetch Game metadata for each interest id.
        // We call getGameById dynamically because DatabaseRepository might be an interface
        // and concrete Firestore repo provides getGameById. If absent, we silently skip.
        for (final gid in List<String>.from(_interestIds)) {
          try {
            final maybeGame = await (db as dynamic).getGameById(gid);
            if (maybeGame != null && maybeGame is Game) {
              _interestGames[gid] = maybeGame;
            }
          } catch (_) {
            // ignore - repository may not implement getGameById or the fetch failed
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      if (mounted) setState(() => _loadingUser = false);
    }
  }

  Future<void> _onSave() async {
    final username = _usernameCtrl.text.trim();
    final bio = _bioCtrl.text.trim();

    if (username.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Username is required")));
      return;
    }

    setState(() => _loading = true);

    try {
      final db = Provider.of<DatabaseRepository>(context, listen: false);

      final newUser = User(
        id: widget.uid,
        name: username,
        bio: bio,
        profilePicture:
            _existingUser?.profilePicture ?? "assets/noodlecat.jpeg",
        threads: _existingUser?.threads ?? [],
        interests: List<String>.from(_interestIds),
        createdAt: _existingUser?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_existingUser == null) {
        await db.createUser(newUser);
      } else {
        await db.updateUser(newUser);
      }

      // After await, widget might have been unmounted. Check before using context.
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile saved.")));
    } catch (e) {
      debugPrint('Error saving profile: $e');
      // make sure widget still mounted before showing snackbar
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  // Called when user picks a game from the GamePicker
  void _onGameSelected(Game game) {
    if (_interestIds.contains(game.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This game is already in your interests.'),
        ),
      );
      return;
    }

    setState(() {
      _interestIds.add(game.id);
      _interestGames[game.id] = game;
    });
  }

  void _removeInterest(String gameId) {
    setState(() {
      _interestIds.remove(gameId);
      _interestGames.remove(gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final db = Provider.of<DatabaseRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complete Your Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioCtrl,
              decoration: const InputDecoration(labelText: "Bio (optional)"),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add favorite games",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),

            // Use GamePicker exactly as implemented by you (no changes)
            GamePicker(
              databaseRepository: db,
              currentUserId: widget.uid,
              onGameSelected: _onGameSelected,
              initialGame: null,
              label: 'Search games to add',
            ),

            const SizedBox(height: 12),

            // Display selected interests as horizontal chips
            SizedBox(
              height: 72,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _interestIds.map((gid) {
                    final g = _interestGames[gid];
                    final label = g?.gameName ?? gid;
                    final avatar =
                        (g?.coverUrl != null && g!.coverUrl!.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(g.coverUrl!),
                            radius: 16,
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.videogame_asset),
                            radius: 16,
                          );

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        avatar: avatar,
                        label: Text(label, overflow: TextOverflow.ellipsis),
                        onDeleted: () => _removeInterest(gid),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _loading ? null : _onSave,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(
                      "Complete",
                      style: TextStyle(color: Theme.of(context).textColor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
