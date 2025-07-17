import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MsgMenuBtn extends StatefulWidget {
  const MsgMenuBtn({super.key});

  @override
  State<MsgMenuBtn> createState() => _MsgMenuBtnState();
}

class _MsgMenuBtnState extends State<MsgMenuBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF281E2E),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Icon(LucideIcons.mail, size: 35, color: Color(0xFFF1F1F1)),
    );
  }
}
