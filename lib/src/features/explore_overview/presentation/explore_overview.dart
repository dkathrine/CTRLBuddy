import 'package:ctrl_buddy/src/common/widgets/message_bar.dart';
import 'package:flutter/material.dart';

class ExploreOverview extends StatefulWidget {
  const ExploreOverview({super.key});

  @override
  State<ExploreOverview> createState() => _ExploreOverviewState();
}

class _ExploreOverviewState extends State<ExploreOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        MessageBar(hintText: "Search"),
        SingleChildScrollView(child: Wrap(children: [])),
      ],
    );
  }
}
