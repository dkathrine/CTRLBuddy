import 'package:flutter/material.dart';
import 'dart:async';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key, required this.dateTime, this.style});

  final DateTime dateTime;
  final TextStyle? style;

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  late Timer _timer;
  String _timeText = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.dateTime);

    String newTimeText;

    if (difference.inDays >= 1) {
      // After 24 hours, show the formatted date and time
      newTimeText = _formatDateTime(widget.dateTime);
    } else if (difference.inHours >= 1) {
      // Show hours
      newTimeText = '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      // Show minutes
      newTimeText = '${difference.inMinutes}m ago';
    } else {
      // Show seconds
      final seconds = difference.inSeconds < 1 ? 1 : difference.inSeconds;
      newTimeText = '${seconds}s ago';
    }

    if (_timeText != newTimeText) {
      setState(() {
        _timeText = newTimeText;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Format: "Jan 15, 2024 3:45 PM"
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$month $day, $year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeText,
      style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
