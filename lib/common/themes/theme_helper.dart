import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/models/theme_palette.dart';
import 'package:squash_archiver/common/themes/app_theme.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

ThemeModel getDefaultAppTheme() {
  return const ThemeModel(mode: ThemeMode.light);
}

/// returns the platform [ThemeMode];
/// if 'follow system theme' is false then null is returned
/// if [context] is null then use [SchedulerBinding]
ThemeMode? getPlatformThemeMode(BuildContext? context) {
  if (!AppDefaultValues.FOLLOW_SYSTEM_THEME) {
    return null;
  }

  Brightness _brightness;

  if (isNotNull(context)) {
    _brightness = MediaQuery.of(context!).platformBrightness;
  } else {
    _brightness = SchedulerBinding.instance!.window.platformBrightness;
  }

  return _brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
}

/// returns true if dark theme mode is activated (by the user or by the platform)
bool isDarkMode(BuildContext context) {
  final _platformTheme = getPlatformThemeMode(context);

  if (isNotNull(_platformTheme)) {
    return _platformTheme == ThemeMode.dark;
  }

  return Theme.of(context).brightness == Brightness.dark;
}

/// Get app theme [AppTheme]
AppTheme getAppTheme(ThemeMode? mode) {
  if (mode == ThemeMode.light) {
    final _lightTheme = getIt.get<AppTheme>(instanceName: 'lightTheme');

    return _lightTheme;
  }

  final _darkTheme = getIt.get<AppTheme>(instanceName: 'darkTheme');

  return _darkTheme;
}

/// Returns [ThemeData] from [ThemeData]
ThemeData getAppThemeData(ThemeMode mode) {
  ThemeMode? _themeMode = mode;

  final _platformThemeMode = getPlatformThemeMode(null);

  /// if [platformThemeMode] is not null then follow that
  if (isNotNull(_platformThemeMode)) {
    _themeMode = _platformThemeMode;
  }

  return getAppTheme(_themeMode).themeData;
}

/// Returns [ThemePalette] from [ThemeData]
ThemePalette getPalette(BuildContext context) {
  final _mode = isDarkMode(context) ? ThemeMode.dark : ThemeMode.light;

  return getAppTheme(_mode).palette;
}
