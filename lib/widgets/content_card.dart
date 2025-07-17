import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.image,
    required this.title,
    required this.author,
    required this.desc,
  });

  final dynamic image;
  final String title;
  final String author;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      /* padding: EdgeInsets.all(1), */
      width: 360 /* ((MediaQuery.of(context).size.width / 2) - 19) */,
      height: 332,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFFC800FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
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
                image: AssetImage(image),
                width: double.infinity,
                height: 188,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF311447),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              child: Column(
                spacing: 21,
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
                              style: TextStyle(
                                color: Color(0xFFF1F1F1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              author,
                              style: TextStyle(
                                color: Color(0xFFF1F1F1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
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
                    style: TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
