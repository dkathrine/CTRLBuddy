import 'package:ctrl_buddy/src/features/category_screen/presentation/category_screen.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class InterestChip extends StatelessWidget {
  const InterestChip({super.key, required this.interest});

  final String interest;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CategoryScreen(gameName: interest),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(2), // Border thickness
        decoration: BoxDecoration(
          gradient: Theme.of(context).accentGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            /*
              box-shadow: 
                0px 4px 8px 3px rgba(0, 0, 0, 0.15), 
                0px 1px 3px 0px rgba(0, 0, 0, 0.30);
            */
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 3,
              color: Colors.black.withValues(alpha: 0.15),
            ),
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 3,
              color: Colors.black.withValues(alpha: 0.30),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(interest, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );
  }
}
