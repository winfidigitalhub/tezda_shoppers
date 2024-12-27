import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;

  const StarRatingWidget({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfFullStars = rating.floor();
    double fraction = rating - numberOfFullStars;

    List<Widget> starWidgets = List.generate(
      numberOfFullStars,
          (index) => const Icon(
        Icons.star,
        color: Colors.orange,
        size: 16,
      ),
    );

    // Add greyed out stars for the remaining
    starWidgets.addAll(List.generate(
      5 - numberOfFullStars,
          (index) => Icon(
        Icons.star,
        color: Colors.grey.shade400,
        size: 16,
      ),
    ));

    if (fraction > 0) {
      starWidgets[numberOfFullStars] = Container(
        width: 16,
        height: 16,
        child: const ClipOval(
          child: Icon(
            Icons.star_half,
            color: Colors.yellow,
            size: 16,
          ),
        ),
      );
    }

    return Row(
      children: starWidgets,
    );
  }
}
