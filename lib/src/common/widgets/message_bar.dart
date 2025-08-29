import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';

class MessageBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onSend;

  const MessageBar({super.key, required this.hintText, this.onSend});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          //gradient: Theme.of(context).accentGradient,
          borderRadius: BorderRadius.circular(28),
          border: BoxBorder.all(
            color: Color.fromARGB(255, 196, 119, 255).withAlpha(90),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              color: Color(
                0xFF3F2F47,
              ).withAlpha(30), // semi-transparent overlay
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Color(0xFFF1F1F1),
                      style: const TextStyle(color: Color(0xFFF1F1F1)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: Color(0xFFF1F1F1)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFF1F1F1)),
                    onPressed: onSend,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
