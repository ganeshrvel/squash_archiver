import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

enum TextVariants {
  headline1,
  headline3,
  headline6,
  subtitle1,
  subtitle2,
  body1,
  body2,
  caption,
  button,
  none
}

class Textography extends StatelessWidget {
  final String child;
  final TextVariants variant;
  final Color color;
  final Color backgroundColor;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final double fontSize;
  final TextDecoration decoration;
  final bool capitalize;

  const Textography(
    this.child, {
    Key key,
    this.variant,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.decoration,
    this.backgroundColor,
    this.fontSize,
    this.capitalize = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _variant = variant ?? TextVariants.body1;
    var _fontWeight = FontWeight.normal;
    var _child = child;
    double _fontSize;

    switch (_variant) {
      case TextVariants.headline1:
        _fontWeight = FontWeight.w800;
        _fontSize = 24.0;
        break;
      case TextVariants.headline3:
        _fontWeight = FontWeight.bold;
        _fontSize = 22.0;
        break;
      case TextVariants.headline6:
        _fontWeight = FontWeight.w800;
        _fontSize = 20.0;
        break;
      case TextVariants.subtitle1:
        _fontWeight = FontWeight.w800;
        _fontSize = 16.0;
        break;
      case TextVariants.subtitle2:
        _fontWeight = FontWeight.normal;
        _fontSize = 18.0;
        break;
      case TextVariants.caption:
        _fontWeight = FontWeight.normal;
        _fontSize = 12.0;
        break;
      case TextVariants.button:
        _fontWeight = FontWeight.w900;
        _fontSize = 16.0;
        break;
      case TextVariants.body2:
        _fontWeight = FontWeight.normal;
        _fontSize = 13.0;
        break;
      case TextVariants.body1:
        _fontWeight = FontWeight.normal;
        _fontSize = 16.0;
        break;
      case TextVariants.none:
      default:
        _fontWeight = null;
        _fontSize = null;
        break;
    }

    if ((capitalize ?? false) && isNotNullOrEmpty(_child)) {
      _child = _child.toUpperCase();
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
    );
  }
}
