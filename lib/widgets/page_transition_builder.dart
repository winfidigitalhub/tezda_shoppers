import 'package:flutter/material.dart';

class PageTransition {
  static PageRouteBuilder createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.fastOutSlowIn;

        var fadeTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var fadeAnimation = animation.drive(fadeTween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }
}