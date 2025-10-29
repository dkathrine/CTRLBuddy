import 'package:ctrl_buddy/src/features/category_screen/presentation/category_screen.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key, required this.gameName});

  final String gameName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CategoryScreen(gameName: gameName),
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
                borderRadius: BorderRadiusGeometry.circular(16),
                child: Image.asset(
                  "assets/noodlecat.jpeg",
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
  }
}
