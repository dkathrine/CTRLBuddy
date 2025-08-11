import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    super.key,
    this.username = "Name",
    this.imgPath = "assets/noodlecat.jpeg",
    this.lastMsg = "Message",
    this.time = "2s ago",
  });

  final String username;
  final String imgPath;
  final String lastMsg;
  final String time;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            spacing: 16,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(widget.imgPath),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    widget.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.lastMsg,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          Text(widget.time, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
