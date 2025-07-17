import 'package:flutter/material.dart';
import 'package:CTRLBuddy/widgets/interest_chip.dart';
import 'package:CTRLBuddy/widgets/content_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    InterestChip(interest: 'League of Legends'),
                    InterestChip(interest: 'Warframe'),
                    InterestChip(interest: 'World of Warcraft'),
                    InterestChip(interest: 'Elden Ring'),
                    InterestChip(interest: 'Baldurs Gate 3'),
                    InterestChip(interest: 'Black Desert'),
                    InterestChip(interest: 'Zennless Zone Zero'),
                    InterestChip(interest: 'Monster Hunter Wilds'),
                    InterestChip(interest: 'Overwatch'),
                  ],
                ),
              ),
            ),
            /* msg_button */
          ],
        ),
        Text('Popular'),
        Column(
          children: [
            Row(
              children: [
                ContentCard(
                  image: 'assets/noodlecat.jpeg',
                  title: 'title',
                  author: 'author',
                  desc:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean interdum magna neque, vel malesuada turpis convallis a. In faucibus ante ac magna lobortis dapibus. In accumsan turpis in justo aliquam, commodo dignissim sapien lacinia. Nullam fringilla fringilla mattis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum eu faucibus neque. Nullam commodo pharetra ex vel facilisis. In aliquam sit amet massa quis sagittis.',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
