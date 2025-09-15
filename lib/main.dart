import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/app.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    Provider<MockDatabase>(
      create: (_) => MockDatabase(),
      child: const MainApp(),
    ),
  );
}
