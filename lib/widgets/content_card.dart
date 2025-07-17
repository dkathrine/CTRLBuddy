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
      padding: EdgeInsets.all(2),
      width: 360,
      height: 332,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFFC800FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: Column(
          children: [
            Expanded(child: Image(image: AssetImage(image))),
            Container(
              decoration: BoxDecoration(color: Color(0xFF311447)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: Image(image: AssetImage(image)),
                      ),
                      Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(color: Color(0xFFF1F1F1)),
                          ),
                          Text(
                            author,
                            style: TextStyle(color: Color(0xFFF1F1F1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(desc, style: TextStyle(color: Color(0xFFF1F1F1))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
