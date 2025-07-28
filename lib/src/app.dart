import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/features/home/presentation/home_screen.dart';
import 'package:ctrl_buddy/src/common/widgets/bottom_nav.dart';
//import 'package:CTRLBuddy/widgets/bottom_nav_ai.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /* int _currentIndex = 0; */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF281E2E),
        bottomNavigationBar: CustomBottomNav(),
        /* bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ), */
        body: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 28, 16, 0),
          child: Center(child: HomeScreen()),
        ),
      ),
    );
  }
}
