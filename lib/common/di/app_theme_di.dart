import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/themes/app_theme.dart';

@module
abstract class AppThemeDi {
  @Named('lightTheme')
  @lazySingleton
  AppTheme get lightTheme => AppTheme(mode: ThemeMode.light);

  @Named('darkTheme')
  @lazySingleton
  AppTheme get darkTheme => AppTheme(mode: ThemeMode.dark);
}
