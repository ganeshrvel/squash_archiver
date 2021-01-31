import 'package:flutter/material.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/models/theme_palette.dart';
import 'package:squash_archiver/common/themes/app_theme.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';

ThemeModel getDefaultAppTheme() {
  return const ThemeModel(mode: ThemeMode.light);
}

bool isDarkMode(BuildContext context) {
  final brightness = Theme.of(context).brightness;

  /// todo use the below line for auto platform theme
  ///final brightness = MediaQuery.of(context).brightness;

  return brightness == Brightness.dark;
}

/// Get app theme [AppTheme]
AppTheme getAppTheme(ThemeMode mode) {
  if (mode == ThemeMode.light) {
    final _lightTheme = getIt.get<AppTheme>(instanceName: 'lightTheme');

    return _lightTheme;
  }

  final _darkTheme = getIt.get<AppTheme>(instanceName: 'darkTheme');

  return _darkTheme;
}

/// Returns [ThemeData] from [ThemeData]
ThemeData getAppThemeData(ThemeMode mode) {
  return getAppTheme(mode).themeData;
}

/// Returns [ThemePalette] from [ThemeData]
ThemePalette getPalette(BuildContext context) {
  final _mode = isDarkMode(context) ? ThemeMode.dark : ThemeMode.light;

  return getAppTheme(_mode).palette;
}
