import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:squash_archiver/constants/app_default_values.dart';
import 'package:squash_archiver/features/app/data/models/theme_model.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/material.dart';

ThemeModel getDefaultAppTheme() {
  return const ThemeModel(mode: ThemeMode.system);
}

/// returns the platform [Brightness];
/// if 'follow system theme' is false then null is returned
/// if [context] is null then use [SchedulerBinding]
Brightness? getPlatformBrightness(BuildContext? context) {
  if (context != null) {
    return MediaQuery.of(context).platformBrightness;
  } else {
    return PlatformDispatcher
        .instance.views.first.platformDispatcher.platformBrightness;
  }
}

/// returns the platform [ThemeMode];
/// if 'follow system theme' is false then null is returned
/// if [context] is null then use [SchedulerBinding]
ThemeMode getPlatformThemeMode(BuildContext? context) {
  if (AppDefaultValues.FOLLOW_SYSTEM_THEME) {
    return ThemeMode.system;
  }

  final _brightness = getPlatformBrightness(context);
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
