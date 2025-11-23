import 'package:ctrl_buddy/src/data/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:ctrl_buddy/src/features/thread/presentation/thread.dart';
import 'package:provider/provider.dart';

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({
    super.key,
    required this.title,
    required this.desc,
    required this.authorId,
    required this.threadId,
    required this.gameId,
  });

  final String gameId;
  final String title;
  final String threadId;
  final String authorId;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final db = context.read<DatabaseRepository>();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Thread(id: threadId),
        ),
      ),
      child: Container(
        width: 360,
        height: 80,
        decoration: BoxDecoration(
          gradient: Theme.of(context).accentGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 119),
              blurRadius: 33,
              color: Colors.black.withValues(alpha: 0.00),
            ),
            BoxShadow(
              offset: Offset(0, 76),
              blurRadius: 31,
              color: Colors.black.withValues(alpha: 0.01),
            ),
            BoxShadow(
              offset: Offset(0, 43),
              blurRadius: 26,
              color: Colors.black.withValues(alpha: 0.05),
            ),
            BoxShadow(
              offset: Offset(0, 19),
              blurRadius: 19,
              color: Colors.black.withValues(alpha: 0.09),
            ),
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 11,
              color: Colors.black.withValues(alpha: 0.10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        desc,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: db.getGameById(gameId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  final game = snapshot.data;
                  final imageUrl =
                      game?.coverUrl ??
                      'https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png';

                  return ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(10),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[800],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
