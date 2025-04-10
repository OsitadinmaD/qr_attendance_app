import 'package:flutter/material.dart';

class PColors {
  const PColors._();

  static Color black = Colors.black;
  static Color white = Colors.white;

  static LinearGradient authBackgroundGradient() {
    return LinearGradient(
          colors: [
            Colors.black,
            Colors.black,
            Colors.black.withValues(alpha: 0.9),
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.7),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        );
  }
}