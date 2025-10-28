import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/common/widgets/notifications_item.dart';
//import 'package:ctrl_buddy/src/data/mock_db.dart';
import 'package:ctrl_buddy/src/domain/appnotification.dart';
import 'package:provider/provider.dart';

class NotificationOverview extends StatefulWidget {
  const NotificationOverview({super.key});

  @override
  State<NotificationOverview> createState() => _NotificationOverviewState();
}

class _NotificationOverviewState extends State<NotificationOverview> {
  late DatabaseRepository db;

  late Future<List<AppNotification>> _notifications;

  @override
  void initState() {
    super.initState();
    //db = Provider.of<MockDatabase>(context, listen: false);
    db = context.read<DatabaseRepository>();
    _notifications = db.notifications;
  }

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
          child: FutureBuilder(
            future: _notifications,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                return Center(child: Text('Error: ${asyncSnapshot.error}'));
              } else if (!asyncSnapshot.hasData ||
                  asyncSnapshot.data!.isEmpty) {
                return const Center(child: Text('No notifications found.'));
              }

              final notifications = asyncSnapshot.data!;

              return SingleChildScrollView(
                child: Wrap(
                  children: notifications.map((notification) {
                    return NotificationsItem(
                      notification: notification.notificationMsg,
                      threadId: notification.threadId,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
