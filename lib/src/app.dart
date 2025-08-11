import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/features/home/presentation/home_screen.dart';
import 'package:ctrl_buddy/src/common/widgets/bottom_nav.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
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
      theme: AppTheme.themeData,
      home: Scaffold(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
