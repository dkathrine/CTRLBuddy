import 'package:ctrl_buddy/src/features/login_screen/presentation/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'package:ctrl_buddy/src/app.dart';
import 'package:ctrl_buddy/src/features/login_screen/presentation/login_screen.dart';
import 'package:ctrl_buddy/src/data/auth_repository.dart';
import 'package:ctrl_buddy/src/data/firebase_auth_repo.dart';
import 'package:ctrl_buddy/src/domain/user.dart' as model;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider<MockDatabase>(create: (_) => MockDatabase()),

        Provider<AuthRepository>(create: (_) => FirebaseAuthRepository()),

        StreamProvider<User?>(
          create: (context) =>
              context.read<AuthRepository>().authStateChanges(),
          initialData: null,
        ),
      ],
      child: const Root(),
    ),
  );
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthRepository>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: StreamBuilder<User?>(
        stream: authRepo.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final fbUser = snapshot.data;
          if (fbUser == null) {
            return const LoginScreen();
          }

          final db = context.read<MockDatabase>();

          return StreamBuilder<model.User?>(
            stream: db.watchUser(fbUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.data == null) {
                return CompleteProfileScreen(uid: fbUser.uid);
              }

              return const MainApp();
            },
          );
        },
      ),
    );
  }
}
