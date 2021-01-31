import 'dart:ui';

import 'package:auto_route/auto_route.dart';

/// Theme palette model
class ThemePalette {
  final Color accentColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color textContrastColor;
  final Color backgroundColor;

  ThemePalette({
    @required this.accentColor,
    @required this.primaryColor,
    @required this.secondaryColor,
    @required this.textColor,
    @required this.textContrastColor,
    @required this.backgroundColor,
  });
}
