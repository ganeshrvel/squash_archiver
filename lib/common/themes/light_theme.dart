import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/constants/colors.dart';

class LightTheme {
  static final TextTheme originalTextTheme = ThemeData.light().textTheme;
  static final IconThemeData originalIconTheme = ThemeData.light().iconTheme;
  static final TextStyle originalBody1 = LightTheme.originalTextTheme.bodyText1;

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
    textTheme: TextTheme(
      subtitle1: originalBody1.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        color: AppColors.black,
      ),
      button: originalBody1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w900,
        color: AppColors.black,
      ),
      headline3: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      headline4: originalBody1.copyWith(
        fontSize: 21.0,
        color: AppColors.black,
      ),
      headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      bodyText1: originalBody1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: originalBody1.copyWith(
        fontSize: 13.0,
        color: AppColors.black,
      ),
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
    fontFamily: 'HKGrotesk',
    backgroundColor: AppColors.white,
    unselectedWidgetColor: AppColors.white,
    textTheme: originalTextTheme.copyWith(
      headline1: originalBody1.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w800,
        color: AppColors.black,
      ),
      headline6: originalBody1.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      subtitle1: originalBody1.copyWith(
        fontSize: 16.0,
        color: AppColors.black,
      ),
      subtitle2: originalBody1.copyWith(
        fontSize: 18.0,
        color: AppColors.black,
      ),
      bodyText1: originalBody1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      bodyText2: originalBody1.copyWith(
        fontSize: 13.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      caption: originalBody1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      button: originalBody1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w900,
        color: AppColors.black,
      ),
    ),
  );
}
