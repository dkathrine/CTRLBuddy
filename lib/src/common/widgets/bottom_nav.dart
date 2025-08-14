import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({
    super.key,
    List<NavItem>? navItems,
    required this.currentIndex,
    required this.onTap,
    this.height = 95 /* was 80 before */,
  }) : _navItems = navItems ?? const [];

  final List<NavItem> _navItems;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pillPositionAnimation;

  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pillPositionAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _previousIndex = widget.currentIndex;
  }

  void _animateToIndex(int newIndex) {
    _pillPositionAnimation =
        Tween<double>(
          begin: _previousIndex.toDouble(),
          end: newIndex.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubic,
          ),
        );

    _animationController.reset();
    _animationController.forward();

    _previousIndex = newIndex;
  }

  @override
  void didUpdateWidget(CustomBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _animateToIndex(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Color(0xFF3A2F3F), width: 0.5)),
      ),
      child: Stack(children: [_pillIndicator(), _navigationItems()]),
    );
  }

  Widget _pillIndicator() {
    return AnimatedBuilder(
      animation: _pillPositionAnimation,
      builder: (context, child) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double horizontalPadding = 8.0;
        final double availableWidth = screenWidth - (horizontalPadding * 2);
        final double itemWidth = availableWidth / widget._navItems.length;

        final double animatedIndex = _pillPositionAnimation.value;
        final double pillLeft =
            horizontalPadding +
            (itemWidth * animatedIndex) +
            (itemWidth * 0.16); /* *0.15 if pillWidth is *0.7 */
        final double pillWidth = itemWidth * 0.68; /* before *0.7 */
        final double pillHeight = 32;

        return Positioned(
          left: pillLeft,
          top: (widget.height - pillHeight) / 2 - 15,
          /* - 12 by height of 80 */
          child: Container(
            width: pillWidth,
            height: pillHeight,
            decoration: BoxDecoration(
              gradient: Theme.of(context).accentGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navigationItems() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget._navItems.length, (index) {
            final item = widget._navItems[index];

            return Expanded(
              child: GestureDetector(
                onTap: () => widget.onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: widget.height,
                  child: Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Icon(item.icon, size: 24 /* color: Color(0xFFF1F1F1) */),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          //color: Color(0xFFF1F1F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String title;

  const NavItem({required this.icon, required this.title});
}
