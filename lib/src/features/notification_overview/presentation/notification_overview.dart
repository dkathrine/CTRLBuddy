import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/common/widgets/notifications_item.dart';

class NotificationOverview extends StatelessWidget {
  const NotificationOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox.shrink(),
          ],
        ),
        SizedBox(height: 17),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: Container(
                child: Text(
                  'All',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Text(
                  'Mentions',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 11),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(),
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(isMention: true),
                NotificationsItem(isMention: true),
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(),
                NotificationsItem(),
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(),
                NotificationsItem(isMention: true),
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(),
                NotificationsItem(),
                NotificationsItem(isMention: true),
                NotificationsItem(isMention: true),
                NotificationsItem(isMention: true),
                NotificationsItem(),
                NotificationsItem(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
