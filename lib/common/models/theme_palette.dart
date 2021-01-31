import 'dart:ui';

import 'package:auto_route/auto_route.dart';

/// Theme palette model
class ThemePalette {
  final Color accentColor;
  final Color primaryColor;
  final Color scaffoldBackgroundColor;

  ThemePalette({
    @required this.accentColor,
    @required this.primaryColor,
    @required this.scaffoldBackgroundColor,
  });
}
