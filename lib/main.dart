import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<MockDatabase>(
      create: (_) => MockDatabase(),
      child: const MainApp(),
    ),
  );
}
