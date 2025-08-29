import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ctrl_buddy/src/common/widgets/comment.dart';
import 'package:ctrl_buddy/src/common/widgets/message_bar.dart';

class Thread extends StatefulWidget {
  const Thread({
    super.key,
    this.username = "Username",
    this.title = "Thread Title",
    this.userImg = "assets/noodlecat.jpeg",
    this.content =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris non pellentesque odio. Sed porttitor vestibulum magna. Vivamus finibus quis lorem ac dictum. Maecenas nec elit pharetra odio consequat bibendum sollicitudin vel dolor.",
    this.likes = 0,
  });

  final String username;
  final String title;
  final String userImg;
  final String content;
  final int likes;

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(16, 28, 16, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(LucideIcons.arrowLeft, size: 42),
                        ),
                        Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(widget.userImg),
                                  radius: 16,
                                ),
                                Text(
                                  widget.username,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    /* GestureDetector(
                      child: Icon(LucideIcons.moreVertical, size: 35),
                    ), */
                  ],
                ),
                SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Column(
                              spacing: 12,
                              children: [
                                Text(
                                  widget.content,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 4,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            LucideIcons.heart,
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          widget.likes.toString(),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelLarge,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        LucideIcons.bookmark,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(
                              color: Color(0xFF666666),
                              thickness: 1,
                              height: 1,
                            ),
                          ],
                        ),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                        Comment(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 26,
            right: 26,
            child: SafeArea(
              child: MessageBar(
                hintText: "Write a comment...",
                onSend: () {
                  debugPrint("Comment posted!");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
