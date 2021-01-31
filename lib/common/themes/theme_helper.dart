import 'package:flutter/material.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/themes/app_theme.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';

ThemeModel getDefaultAppTheme() {
  return const ThemeModel(mode: ThemeMode.light);
}

ThemeData getAppThemeData(ThemeMode mode) {
  if (mode == ThemeMode.light) {
    final _lightTheme = getIt.get<AppTheme>(instanceName: 'lightTheme');

    return _lightTheme.themeData;
  }

  final _darkTheme = getIt.get<AppTheme>(instanceName: 'darkTheme');

  return _darkTheme.themeData;
}

bool isDarkMode(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;

  return brightness == Brightness.dark;
}
