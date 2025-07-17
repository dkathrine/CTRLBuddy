import 'package:flutter/material.dart';

class InterestChip extends StatelessWidget {
  const InterestChip({super.key, required this.interest});

  final String interest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2), // Border thickness
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFFC800FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Color(0xFF311447),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(interest, style: TextStyle(color: Color(0xFFF1F1F1))),
      ),
    );
  }
}
