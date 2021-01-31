import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squash_archiver/common/models/theme_palette.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/constants/colors.dart';

class AppTheme {
  final ThemeMode mode;

  AppTheme({
    @required this.mode,
  });

  TextStyle get _originalBodyText1 => GoogleFonts.openSans();

  MaterialColor get _primarySwatch =>
      hexColor2MaterialColor(color: AppColors.blue);

  TextTheme get _originalTextTheme {
    if (mode == ThemeMode.dark) {
      return ThemeData.dark().textTheme;
    }

    return ThemeData.light().textTheme;
  }

  IconThemeData get _originalIconTheme {
    if (mode == ThemeMode.dark) {
      return ThemeData.dark().iconTheme;
    }

    return ThemeData.light().iconTheme;
  }

  /// theme palatte. Use [palette] to pick colors use across the app.
  ThemePalette get palette {
    if (mode == ThemeMode.dark) {
      return ThemePalette(
        accentColor: AppColors.blue,
        scaffoldBackgroundColor: AppColors.black,
        primaryColor: AppColors.black,
      );
    }

    return ThemePalette(
      accentColor: AppColors.blue,
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.white,
    );
  }

  /// AppBar theme
  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      color: AppColors.white,
      elevation: 2,
      brightness: Brightness.light,
      iconTheme: _originalIconTheme.copyWith(color: AppColors.color797),
      actionsIconTheme: _originalIconTheme.copyWith(color: AppColors.color797),
      textTheme: GoogleFonts.openSansTextTheme(_originalTextTheme).copyWith(
        subtitle1: _originalBodyText1.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
        ),
        button: _originalBodyText1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w900,
          color: AppColors.black,
        ),
        headline3: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        headline4: _originalBodyText1.copyWith(
          fontSize: 21.0,
          color: AppColors.black,
        ),
        headline6: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        bodyText1: _originalBodyText1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: _originalBodyText1.copyWith(
          fontSize: 13.0,
          color: AppColors.black,
        ),
        headline1: _originalBodyText1.copyWith(),
        headline2: _originalBodyText1.copyWith(),
        headline5: _originalBodyText1.copyWith(),
        subtitle2: _originalBodyText1.copyWith(),
        caption: _originalBodyText1.copyWith(
          fontSize: 12.0,
          color: AppColors.color797,
        ),
        overline: _originalBodyText1.copyWith(),
      ),
    );
  }

  /// ButtonTheme
  ButtonThemeData get _buttonTheme {
    return ButtonThemeData(
      splashColor: AppColors.splash,
      buttonColor: AppColors.blue,
      textTheme: ButtonTextTheme.primary,
      disabledColor: AppColors.disabled,
    );
  }

  /// ThemeData
  ThemeData get themeData {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: _originalIconTheme,
      brightness: Brightness.light,
      primarySwatch: _primarySwatch,
      primaryColor: palette.primaryColor,
      accentColor: palette.accentColor,
      appBarTheme: _appBarTheme,
      buttonTheme: _buttonTheme,
      indicatorColor: AppColors.blue,
      scaffoldBackgroundColor: palette.scaffoldBackgroundColor,
      fontFamily: 'Open Sans',
      backgroundColor: AppColors.white,
      unselectedWidgetColor: AppColors.white,
      textTheme: GoogleFonts.openSansTextTheme(_originalTextTheme).copyWith(
        headline1: _originalBodyText1.copyWith(
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
        ),
        headline6: _originalBodyText1.copyWith(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: AppColors.black,
        ),
        subtitle1: _originalBodyText1.copyWith(
          fontSize: 16.0,
          color: AppColors.black,
        ),
        subtitle2: _originalBodyText1.copyWith(
          fontSize: 18.0,
          color: AppColors.black,
        ),
        bodyText1: _originalBodyText1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: AppColors.black,
        ),
        bodyText2: _originalBodyText1.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.normal,
          color: AppColors.black,
        ),
        caption: _originalBodyText1.copyWith(
          fontSize: 12.0,
          color: AppColors.color797,
          fontWeight: FontWeight.w700,
        ),
        button: _originalBodyText1.copyWith(
          fontSize: 15.0,
          fontWeight: FontWeight.w900,
          color: AppColors.black,
        ),
        headline2: _originalBodyText1.copyWith(),
        headline5: _originalBodyText1.copyWith(),
        overline: _originalBodyText1.copyWith(),
        headline4: _originalBodyText1.copyWith(),
        headline3: _originalBodyText1.copyWith(),
      ),
    );
  }
}
