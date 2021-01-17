import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

/// headline1: Font size 24.0
///
/// headline3: Font size 22.0
///
/// headline6: Font size 20.0
///
/// subtitle1: Font size 16.0
///
/// subtitle2: Font size 18.0
///
/// body1: Font size 16.0
///
/// body2: Font size 13.0
///
/// body3: Font size 14.0
///
/// caption: Font size 12.0
///
/// small1: Font size 11.0
///
/// small2: Font size 10.0
///
///  button: Font size 16.0
///
enum TextVariant {
  /// Font size 24.0
  headline1,

  /// Font size 22.0
  headline3,

  /// Font size 20.0
  headline6,

  /// Font size 16.0
  subtitle1,

  /// Font size 18.0
  subtitle2,

  /// Font size 16.0
  body1,

  /// Font size 13.0
  body2,

  /// Font size 14.0
  body3,

  /// Font size 12.0
  caption,

  /// Font size 11.0
  small1,

  /// Font size 10.0
  small2,

  /// Font size 15.0
  button,

  ///
  none
}

class Textography extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final Color color;
  final Color backgroundColor;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final double fontSize;
  final TextDecoration decoration;
  final bool capitalize;
  final TextOverflow overflow;

  const Textography(
    this.text, {
    Key key,
    this.variant,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.decoration,
    this.backgroundColor,
    this.fontSize,
    this.capitalize = false,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _variant = variant ?? TextVariant.body1;
    var _fontWeight = FontWeight.normal;
    var _child = text ?? '';
    double _fontSize;

    const _corrector = 1;

    switch (_variant) {
      case TextVariant.headline1:
        _fontWeight = FontWeight.w800;
        _fontSize = 24.0;
        break;
      case TextVariant.headline3:
        _fontWeight = FontWeight.bold;
        _fontSize = 22.0;
        break;
      case TextVariant.headline6:
        _fontWeight = FontWeight.w800;
        _fontSize = 20.0;
        break;
      case TextVariant.subtitle1:
        _fontWeight = FontWeight.w800;
        _fontSize = 16.0;
        break;
      case TextVariant.subtitle2:
        _fontWeight = FontWeight.normal;
        _fontSize = 18.0;
        break;
      case TextVariant.caption:
        _fontWeight = FontWeight.w700;
        _fontSize = 12.0;
        break;
      case TextVariant.small1:
        _fontWeight = FontWeight.w500;
        _fontSize = 11.0;
        break;
      case TextVariant.small2:
        _fontWeight = FontWeight.w500;
        _fontSize = 12.0;
        break;
      case TextVariant.button:
        _fontWeight = FontWeight.w900;
        _fontSize = 15.0;
        break;
      case TextVariant.body2:
        _fontWeight = FontWeight.normal;
        _fontSize = 13.0;
        break;
      case TextVariant.body3:
        _fontWeight = FontWeight.normal;
        _fontSize = 14.0;
        break;
      case TextVariant.body1:
        _fontWeight = FontWeight.normal;
        _fontSize = 16.0;
        break;
      case TextVariant.none:
      default:
        _fontWeight = null;
        _fontSize = null;
        break;
    }

    if ((capitalize ?? false) && isNotNullOrEmpty(_child)) {
      _child = _child.toUpperCase();
    }

    var _correctedFontWeight = fontSize ?? _fontSize;

    if (isNotNull(_correctedFontWeight)) {
      _correctedFontWeight += _corrector;
    }

    return Text(
      _child,
      style: TextStyle(
        fontSize: fontSize ?? _fontSize,
        fontWeight: fontWeight ?? _fontWeight,
        color: color,
        backgroundColor: backgroundColor,
        decoration: decoration,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
