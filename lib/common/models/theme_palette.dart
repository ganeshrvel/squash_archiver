import 'dart:ui';

import 'package:auto_route/auto_route.dart';

/// Theme palette model
class ThemePalette {
  final Color accentColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color textContrastColor;
  final Color rowTextContrastColor;
  final Color backgroundColor;
  final Color disabledColor;
  final Color splashColor;
  final Color hoverColor;
  final Color captionColor;
  final Color sidebarColor;
  final Color rowSelectionColor;
  final Color alternativeRowColor;
  final Color sidebarSelectionColor;
  final Color sidebarTileIconColor;
  final Color sidebarTileIconContrastColor;
  final Color sidebarTileTextColor;
  final Color sidebarTileTextContrastColor;

  ThemePalette({
    @required this.accentColor,
    @required this.primaryColor,
    @required this.secondaryColor,
    @required this.textColor,
    @required this.textContrastColor,
    @required this.rowTextContrastColor,
    @required this.backgroundColor,
    @required this.disabledColor,
    @required this.splashColor,
    @required this.hoverColor,
    @required this.captionColor,
    @required this.sidebarColor,
    @required this.rowSelectionColor,
    @required this.alternativeRowColor,
    @required this.sidebarSelectionColor,
    @required this.sidebarTileIconColor,
    @required this.sidebarTileIconContrastColor,
    @required this.sidebarTileTextColor,
    @required this.sidebarTileTextContrastColor,
  });
}
