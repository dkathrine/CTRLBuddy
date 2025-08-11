import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/common/widgets/chat_item.dart';
import 'package:ctrl_buddy/src/common/widgets/message_menu_btn.dart';

class ChatOverview extends StatelessWidget {
  const ChatOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Messages', style: Theme.of(context).textTheme.headlineLarge),
            MsgMenuBtn(),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
                ChatItem(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
