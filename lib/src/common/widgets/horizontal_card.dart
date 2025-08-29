import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:ctrl_buddy/src/features/thread/presentation/thread.dart';

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    required this.authorId,
    required this.threadId,
  });

  final dynamic image;
  final String title;
  final String threadId;
  final String authorId;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Thread()),
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
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(10),
                ),
                child: Image(
                  image: AssetImage(image),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
