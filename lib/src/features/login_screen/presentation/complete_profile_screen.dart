import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/domain/user.dart';
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

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final username = _usernameCtrl.text.trim();
    final bio = _bioCtrl.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Username is required")));
      return;
    }

    setState(() => _loading = true);

    try {
      final db = context.read<DatabaseRepository>();

      final newUser = User(
        id: widget.uid,
        name: username,
        bio: bio,
        profilePicture: "assets/noodlecat.jepg",
      );

      await db.createUser(newUser);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioCtrl,
              decoration: const InputDecoration(labelText: "Bio (optional)"),
            ),
            const SizedBox(height: 20),
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
