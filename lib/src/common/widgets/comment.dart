import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.userId,
    required this.threadId,
    this.username = "Name",
    this.likes = 0,
    this.imgPath = "assets/noodlecat.jpeg",
    this.comment =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris non pellentesque odio. Sed porttitor vestibulum magna. Vivamus finibus quis lorem ac dictum. Maecenas nec elit pharetra odio consequat bibendum sollicitudin vel dolor.",
    this.time = "2s ago",
  });

  final String userId;
  final String threadId;
  final String username;
  final int likes;
  final String imgPath;
  final String comment;
  final String time;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 16),
      child: Column(
        children: [
          Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(widget.imgPath),
                  ),
                  Text(
                    widget.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 4),
                    child: Text(
                      widget.time,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              Text(
                widget.comment,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 5),
                  Row(
                    spacing: 4,
                    children: [
                      GestureDetector(child: Icon(LucideIcons.heart, size: 20)),
                      Text(
                        widget.likes.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: Color(0xFF666666), thickness: 1, height: 1),
        ],
      ),
    );
  }
}
