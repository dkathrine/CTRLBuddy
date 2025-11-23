// lib/src/screens/complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/data/interests_provider.dart';
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

  String _selectedProfilePicture = "assets/profile_pictures/0.png";

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
        _selectedProfilePicture = user.profilePicture.isNotEmpty
            ? user.profilePicture
            : "assets/profile_pictures/0.png";
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

  Future<void> _showProfilePicturePicker() async {
    final selectedPicture = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Profile Picture',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  height: 400,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: 33,
                    itemBuilder: (context, index) {
                      final picturePath = "assets/profile_pictures/$index.png";
                      final isSelected = picturePath == _selectedProfilePicture;

                      return GestureDetector(
                        onTap: () => Navigator.of(context).pop(picturePath),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(context).textColor,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(picturePath),
                            radius: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedPicture != null) {
      setState(() {
        _selectedProfilePicture = selectedPicture;
      });
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
        profilePicture: _selectedProfilePicture,
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

      if (mounted) {
        final interestsProvider = context.read<InterestsProvider>();
        await interestsProvider.refreshInterests(
          List<String>.from(_interestIds),
        );
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
      if (_existingUser != null) {
        Navigator.of(context).pop(true);
      }
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(_selectedProfilePicture),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).textColor,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 20,
                            color: Theme.of(context).textColor,
                          ),
                          onPressed: _showProfilePicturePicker,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _existingUser == null
                  ? TextField(
                      controller: _usernameCtrl,
                      cursorColor: Theme.of(context).textColor.withAlpha(70),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: Theme.of(context).textColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).textColor,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              const SizedBox(height: 12),
              TextField(
                controller: _bioCtrl,
                cursorColor: Theme.of(context).textColor.withAlpha(70),
                decoration: InputDecoration(
                  labelText: "Bio (optional)",
                  labelStyle: TextStyle(color: Theme.of(context).textColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).textColor),
                  ),
                ),
                minLines: 1,
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
                        _existingUser == null ? "Complete" : "Update",
                        style: TextStyle(color: Theme.of(context).textColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
