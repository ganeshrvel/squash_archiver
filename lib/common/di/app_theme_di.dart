import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/common/themes/app_theme.dart';

@module
abstract class AppThemeDi {
  @Named('lightTheme')
  @LazySingleton()
  AppTheme get lightTheme => AppTheme(mode: ThemeMode.light);

  @Named('darkTheme')
  @LazySingleton()
  AppTheme get darkTheme => AppTheme(mode: ThemeMode.dark);
}
