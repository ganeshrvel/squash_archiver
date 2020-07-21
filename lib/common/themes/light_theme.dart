import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/constants/colors.dart';

class LightTheme {
  static final TextTheme originalTextTheme = ThemeData.light().textTheme;
  static final IconThemeData originalIconTheme = ThemeData.light().iconTheme;
  static final TextStyle originalBodyText1 = GoogleFonts.raleway();

  static final MaterialColor _primarySwatch =
      hexColor2MaterialColor(color: AppColors.black);
  static final Color primaryColor = AppColors.black;
  static final Color accentColor = AppColors.blue;
  static const Color _scaffoldBackgroundColor = AppColors.white;
  static final Color _hintColor = AppColors.black;

  static final AppBarTheme _appBarTheme = AppBarTheme(
    color: AppColors.white,
    elevation: 2,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: AppColors.black),
    actionsIconTheme: IconThemeData(color: AppColors.black),
    textTheme: GoogleFonts.ralewayTextTheme(originalTextTheme).copyWith(
      subtitle1: originalBodyText1.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        color: AppColors.black,
      ),
      button: originalBodyText1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w900,
        color: AppColors.black,
      ),
      headline3: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      headline4: originalBodyText1.copyWith(
        fontSize: 21.0,
        color: AppColors.black,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      bodyText1: originalBodyText1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: originalBodyText1.copyWith(
        fontSize: 13.0,
        color: AppColors.black,
      ),
      headline1: originalBodyText1.copyWith(),
      headline2: originalBodyText1.copyWith(),
      headline5: originalBodyText1.copyWith(),
      subtitle2: originalBodyText1.copyWith(),
      caption: originalBodyText1.copyWith(),
      overline: originalBodyText1.copyWith(),
    ),
  );

  static final ButtonThemeData _buttonTheme = ButtonThemeData(
    splashColor: AppColors.splash,
    buttonColor: AppColors.blue,
    textTheme: ButtonTextTheme.primary,
    disabledColor: AppColors.disabled,
  );

  static final ThemeData themeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primarySwatch: _primarySwatch,
    primaryColor: primaryColor,
    accentColor: accentColor,
    appBarTheme: _appBarTheme,
    buttonTheme: _buttonTheme,
    hintColor: _hintColor,
    indicatorColor: AppColors.blue,
    scaffoldBackgroundColor: _scaffoldBackgroundColor,
    fontFamily: 'Raleway',
    backgroundColor: AppColors.white,
    unselectedWidgetColor: AppColors.white,
    textTheme: GoogleFonts.ralewayTextTheme(originalTextTheme).copyWith(
      headline1: originalBodyText1.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w800,
        color: AppColors.black,
      ),
      headline6: originalBodyText1.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      subtitle1: originalBodyText1.copyWith(
        fontSize: 16.0,
        color: AppColors.black,
      ),
      subtitle2: originalBodyText1.copyWith(
        fontSize: 18.0,
        color: AppColors.black,
      ),
      bodyText1: originalBodyText1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      bodyText2: originalBodyText1.copyWith(
        fontSize: 13.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      caption: originalBodyText1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      button: originalBodyText1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w900,
        color: AppColors.black,
      ),
      headline2: originalBodyText1.copyWith(),
      headline5: originalBodyText1.copyWith(),
      overline: originalBodyText1.copyWith(),
      headline4: originalBodyText1.copyWith(),
      headline3: originalBodyText1.copyWith(),
    ),
  );
}
