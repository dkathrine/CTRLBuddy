import 'package:ctrl_buddy/src/features/explore_overview/presentation/explore_overview.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/features/home/presentation/home_screen.dart';
import 'package:ctrl_buddy/src/features/chat_overview/presentation/chat_overview.dart';
import 'package:ctrl_buddy/src/features/notification_overview/presentation/notification_overview.dart';
import 'package:ctrl_buddy/src/common/widgets/bottom_nav.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ctrl_buddy/src/common/widgets/message_menu_btn.dart';
import 'package:ctrl_buddy/src/features/profile/presentation/profile_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ExploreOverview(),
    NotificationOverview(),
    ProfileScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(icon: LucideIcons.home, title: 'Home'),
    NavItem(icon: LucideIcons.search, title: 'Explore'),
    NavItem(icon: LucideIcons.bell, title: 'Notifications'),
    NavItem(icon: LucideIcons.user, title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: CustomBottomNav(
          navItems: _navItems,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(16, 28, 16, 0),
              child: Center(child: _pages[_currentIndex]),
            ),
            /* Positioned(
              top: _currentIndex == 0 ? 23 : 32,
              right: 16,
              child: MsgMenuBtn(),
            ), */
          ],
        ),
      ),
    );
  }
}
