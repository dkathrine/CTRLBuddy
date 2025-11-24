import 'package:ctrl_buddy/src/data/auth_repository.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/domain/thread.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:ctrl_buddy/src/domain/game.dart';
import 'package:ctrl_buddy/src/common/widgets/game_picker.dart';

class ThreadCreationScreen extends StatefulWidget {
  const ThreadCreationScreen({super.key});

  @override
  State<ThreadCreationScreen> createState() => _ThreadCreationScreenState();
}

class _ThreadCreationScreenState extends State<ThreadCreationScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  bool _loading = false;
  Game? _selectedGame;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _onPost() async {
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Title is required")));
      return;
    }

    setState(() => _loading = true);

    final db = context.read<DatabaseRepository>();
    final auth = context.read<AuthRepository>();

    final curUser = auth.getCurrentUserId();

    if (curUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No logged-in User found!")));
      return;
    }

    final user = await db.getUser(curUser);
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not found!")));
      return;
    }

    try {
      final newThread = Thread(
        id: "",
        userId: user.id,
        username: user.name,
        userProfilePicture: user.profilePicture,
        title: title,
        message: desc,
        gameId: _selectedGame!.id,
        gameName: _selectedGame!.gameName,
      );

      await db.createThread(newThread);

      await db.incrementGameThreadCount(_selectedGame!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thread created successfully!")),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<DatabaseRepository>();
    final auth = context.read<AuthRepository>();
    final currentUserId = auth.getCurrentUserId() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post a Thread",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _loading ? null : _onPost,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      "Post",
                      style: TextStyle(color: Theme.of(context).textColor),
                    ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GamePicker(
                databaseRepository: db,
                currentUserId: currentUserId,
                onGameSelected: (game) {
                  setState(() {
                    _selectedGame = game;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleCtrl,
                cursorColor: Theme.of(context).textColor.withAlpha(70),
                decoration: InputDecoration(
                  labelText: "Title",
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).textColor,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).textColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                cursorColor: Theme.of(context).textColor.withAlpha(70),
                decoration: InputDecoration(
                  labelText: "What do you want to talk about?",
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).textColor,
                  ),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
