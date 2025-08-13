import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationsItem extends StatefulWidget {
  const NotificationsItem({
    super.key,
    this.isMention = false,
    this.notification =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris non pellentesque odio.",
    this.time = "2s ago",
    this.imgPath = "assets/noodlecat.jpeg",
  });

  final bool isMention;
  final String notification;
  final String time;
  final String imgPath;

  @override
  State<NotificationsItem> createState() => _NotificationsItemState();
}

class _NotificationsItemState extends State<NotificationsItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            widget.isMention
                ? Container(
                    width: 51,
                    height: 51,
                    decoration: BoxDecoration(
                      gradient: Theme.of(context).accentGradient,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(1),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(widget.imgPath),
                      ),
                    ),
                  )
                : Container(
                    width: 51,
                    height: 51,
                    decoration: BoxDecoration(
                      gradient: Theme.of(context).accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(1),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.imgPath),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Text(
                widget.notification,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 35),
                Text(
                  widget.time,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
