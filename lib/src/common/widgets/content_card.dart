import 'package:ctrl_buddy/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:ctrl_buddy/src/features/thread/presentation/thread.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.threadId,
    this.coverImage =
        'https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png',
    required this.image,
    required this.title,
    required this.author,
    required this.desc,
  });

  final String threadId;
  final dynamic coverImage;
  final dynamic image;
  final String title;
  final String author;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Thread(id: threadId),
        ),
      ),
      child: Container(
        /* padding: EdgeInsets.all(1), */
        width: 360 /* ((MediaQuery.of(context).size.width / 2) - 19) */,
        height: 332,
        decoration: BoxDecoration(
          gradient: Theme.of(context).accentGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            /* 
              box-shadow: 
                0px 119px 33px 0px rgba(0, 0, 0, 0.00), 
                0px 76px 31px 0px rgba(0, 0, 0, 0.01), 
                0px 43px 26px 0px rgba(0, 0, 0, 0.05), 
                0px 19px 19px 0px rgba(0, 0, 0, 0.09), 
                0px 5px 11px 0px rgba(0, 0, 0, 0.10);
            */
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
        child: Card(
          child: Column(
            children: [
              /* Clips the image using a rounded rectangle */
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image(
                  image: NetworkImage(coverImage),
                  width: double.infinity,
                  height: 188,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Color(0xFF642992).withAlpha(30),
                  child: Ink(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 16,
                          children: [
                            CircleAvatar(
                              radius: 20.00,
                              backgroundImage: AssetImage(image),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    author,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          desc,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
