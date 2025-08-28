import 'package:ctrl_buddy/src/common/widgets/horizontal_card.dart';
import 'package:ctrl_buddy/src/common/widgets/interest_chip.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final interests = [
    'League of Legends',
    'Warframe',
    'World of Warcraft',
    'Elden Ring',
    'Baldurs Gate 3',
    'Black Desert',
    'Zennless Zone Zero',
    'Monster Hunter Wilds',
    'Overwatch',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 2),
          SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage("assets/noodlecat.jpeg"),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Username",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "Status",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  spacing: 4,
                  children: [
                    Text(
                      "Bio",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: Theme.of(context).accentGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris non pellentesque odio. Sed porttitor vestibulum magna. Vivamus finibus quis lorem ac dictum. Maecenas nec elit pharetra odio consequat bibendum sollicitudin vel dolor.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Your Threads",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "Show All",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                              HorizontalCard(
                                image: "assets/noodlecat.jpeg",
                                title: "title",
                                desc: "desc",
                                authorId: "authorId",
                                threadId: "threadId",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Your Interests",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "Show All",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              for (int i = 0; i < interests.length; i++)
                                if (i.isEven)
                                  InterestChip(interest: interests[i]),
                            ],
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              for (int i = 0; i < interests.length; i++)
                                if (i.isOdd)
                                  InterestChip(interest: interests[i]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
