import 'package:ctrl_buddy/src/features/category_screen/presentation/category_screen.dart';
import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:ctrl_buddy/src/domain/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    this.gameName = "",
    required this.gameId, // Added gameId parameter
  });

  final String gameName;
  final String gameId; // Added gameId field

  @override
  Widget build(BuildContext context) {
    final db = context.read<DatabaseRepository>();

    return FutureBuilder<Game?>(
      future: db.getGameById(gameId),
      builder: (context, snapshot) {
        final coverUrl = snapshot.data?.coverUrl;

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  CategoryScreen(gameName: gameName),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            width: MediaQuery.of(context).size.width * 0.4,
            child: AspectRatio(
              aspectRatio: 1.4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: coverUrl != null
                        ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(
                              context,
                            ).size.width /* * 0.4 */,
                            height: MediaQuery.of(context).size.height,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                "https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.4,
                              );
                            },
                          )
                        : Image.network(
                            "https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withAlpha(35),
                    ),
                    child: Center(
                      child: Text(
                        gameName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
