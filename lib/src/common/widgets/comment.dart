import 'package:ctrl_buddy/src/data/auth_repository.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ctrl_buddy/src/common/widgets/time_display.dart';
import 'package:provider/provider.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.userId,
    required this.threadId,
    required this.createdAt,
    required this.commentId,
    required this.likedBy,
    this.username = "Name",
    this.likes = 0,
    this.userProfilePicture = "assets/default_profile.png",
    this.comment =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris non pellentesque odio. Sed porttitor vestibulum magna. Vivamus finibus quis lorem ac dictum. Maecenas nec elit pharetra odio consequat bibendum sollicitudin vel dolor.",
  });

  final String userId;
  final String threadId;
  final String username;
  final int likes;
  final String userProfilePicture;
  final String comment;
  final DateTime createdAt;
  final String commentId;
  final List<String> likedBy;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  Future<void> _toggleLike() async {
    final auth = context.read<AuthRepository>();
    final db = context.read<DatabaseRepository>();
    final currentUserId = auth.getCurrentUserId();

    if (currentUserId == null) return;

    final isLiked = widget.likedBy.contains(currentUserId);

    if (isLiked) {
      await db.unlikeComment(widget.commentId, currentUserId);
    } else {
      await db.likeComment(widget.commentId, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthRepository>();
    final currentUserId = auth.getCurrentUserId();
    final isLiked =
        currentUserId != null && widget.likedBy.contains(currentUserId);

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
                    backgroundImage: AssetImage(widget.userProfilePicture),
                  ),
                  Text(
                    widget.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 4),
                    child: TimeDisplay(
                      dateTime: widget.createdAt,
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
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Icon(
                          isLiked ? Icons.favorite : LucideIcons.heart,
                          size: 20,
                        ),
                      ),
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
