import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum ButtonTypes {
  FLAT,
  RAISED,
  ICON,
  TEXT,
}

enum ButtonColorTypes {
  BLUE,
  WHITE,
  BLACK,
}

enum ButtonSizeTypes {
  SMALL,
  MEDIUM,
  LARGE,
}

class Button extends StatelessWidget {
  final String text;
  final bool loading;
  final String loadingText;
  final bool disabled;
  final bool fullWidth;
  final IconData icon;
  final VoidCallback onPressed;
  final ButtonTypes buttonType;
  final double height;
  final double width;
  final ButtonColorTypes buttonColor;
  final double elevation;
  final double iconButtonSize;
  final ButtonColorTypes buttonTextColor;
  final bool roundedEdge;
  final double radius;
  final ButtonSizeTypes buttonSize;
  final bool textAutoCapitalize;
  final bool underline;
  final TextVariants textVariant;
  final FontWeight fontWeight;

  const Button({
    @required this.text,
    @required this.onPressed,
    this.loading = false,
    this.loadingText,
    this.disabled = false,
    this.icon,
    this.buttonType = ButtonTypes.RAISED,
    this.height,
    this.width,
    this.fullWidth = false,
    this.buttonColor,
    this.buttonTextColor,
    this.elevation = 2,
    this.roundedEdge = false,
    this.radius = 8.0,
    this.buttonSize = ButtonSizeTypes.LARGE,
    this.textAutoCapitalize = true,
    this.iconButtonSize = 30.0,
    this.underline = true,
    this.textVariant,
    this.fontWeight,
  });

  String getButtonText() {
    if (loading && isNotNullOrEmpty(loadingText)) {
      return textAutoCapitalize ? loadingText.toUpperCase() : loadingText;
    }

    return textAutoCapitalize ? text.toUpperCase() : text;
  }

  bool isButtonDisabled() {
    if (disabled) {
      return true;
    }

    if (loading) {
      return true;
    }

    return false;
  }

  Color getButtonBgColor() {
    if (isNotNull(buttonColor)) {
      switch (buttonColor) {
        case ButtonColorTypes.WHITE:
          return AppColors.white;

        case ButtonColorTypes.BLACK:
          return AppColors.black;

        case ButtonColorTypes.BLUE:
        default:
          return AppColors.blue;
      }
    }

    if (isNotNull(buttonTextColor)) {
      switch (buttonTextColor) {
        case ButtonColorTypes.WHITE:
          return AppColors.blue;

        case ButtonColorTypes.BLACK:
        case ButtonColorTypes.BLUE:
        default:
          return AppColors.white;
      }
    }

    if (buttonType == ButtonTypes.TEXT) {
      return AppColors.white;
    }

    return AppColors.blue;
  }

  Color getButtonTextColor() {
    if (buttonType == ButtonTypes.ICON || buttonType == ButtonTypes.TEXT) {
      if (isButtonDisabled()) {
        return AppColors.disabled;
      }
    }

    if (isNotNull(buttonTextColor)) {
      switch (buttonTextColor) {
        case ButtonColorTypes.WHITE:
          return AppColors.white;

        case ButtonColorTypes.BLACK:
          return AppColors.black;
        case ButtonColorTypes.BLUE:
        default:
          return AppColors.blue;
      }
    }

    if (buttonType == ButtonTypes.ICON) {
      return AppColors.black;
    }

    if (isNotNull(buttonColor)) {
      switch (buttonColor) {
        case ButtonColorTypes.WHITE:
          return AppColors.blue;

        case ButtonColorTypes.BLACK:
        case ButtonColorTypes.BLUE:
        default:
          return AppColors.white;
      }
    }

    if (buttonType == ButtonTypes.TEXT) {
      return AppColors.blue;
    }

    return AppColors.white;
  }

  ShapeBorder getBtnShape() {
    if (isNull(roundedEdge)) {
      return const RoundedRectangleBorder();
    }

    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
  }

  TextStyle getButtonTextStyle() {
    var _fontWeight = FontWeight.w900;

    if (isNotNull(fontWeight)) {
      _fontWeight = fontWeight;
    } else if (isNotNull(textVariant)) {
      _fontWeight = null;
    }

    return TextStyle(
      fontWeight: _fontWeight,
      color: getButtonTextColor(),
    );
  }

  Widget getButton() {
    final buttonStyle = getButtonTextStyle();
    final _textVariant = textVariant ?? TextVariants.button;

    switch (buttonType) {
      case ButtonTypes.FLAT:
        const highlightColor = Color.fromRGBO(0, 0, 0, 0.05);

        return isNull(icon)
            ? FlatButton(
                highlightColor: highlightColor,
                color: getButtonBgColor(),
                onPressed: isButtonDisabled() ? null : onPressed,
                shape: getBtnShape(),
                child: Textography(
                  getButtonText(),
                  variant: _textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              )
            : FlatButton.icon(
                highlightColor: highlightColor,
                icon: Icon(
                  icon,
                ),
                color: getButtonBgColor(),
                shape: getBtnShape(),
                onPressed: isButtonDisabled() ? null : onPressed,
                label: Textography(
                  getButtonText(),
                  variant: textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              );
        break;

      case ButtonTypes.ICON:
        if (isNull(icon)) {
          throw 'icon cannot be empty';
        }

        return SizedBox(
          child: IconButton(
            icon: Icon(
              icon,
            ),
            color: getButtonTextColor(),
            onPressed: isButtonDisabled() ? null : onPressed,
            tooltip: getButtonText(),
            iconSize: iconButtonSize,
          ),
        );

      case ButtonTypes.TEXT:
        return InkWell(
          onTap: isButtonDisabled() ? null : onPressed,
          child: Textography(
            getButtonText(),
            variant: isNotNull(textVariant) ? textVariant : null,
            color: getButtonTextColor(),
            decoration: underline ? TextDecoration.underline : null,
            backgroundColor: getButtonBgColor(),
            fontWeight: isNotNull(textVariant)
                ? buttonStyle.fontWeight
                : FontWeight.bold,
          ),
        );

      case ButtonTypes.RAISED:
      default:
        return isNull(icon)
            ? RaisedButton(
                elevation: elevation,
                color: getButtonBgColor(),
                onPressed: isButtonDisabled() ? null : onPressed,
                shape: getBtnShape(),
                child: Textography(
                  getButtonText(),
                  variant: textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              )
            : RaisedButton.icon(
                elevation: elevation,
                icon: Icon(
                  icon,
                ),
                color: getButtonBgColor(),
                shape: getBtnShape(),
                onPressed: isButtonDisabled() ? null : onPressed,
                label: Textography(
                  getButtonText(),
                  variant: textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              );
    }
  }

  _ButtonHeight getButtonHeight() {
    var _minHeight = 40.0;
    var _maxHeight = 40.0;

    if (buttonSize == ButtonSizeTypes.SMALL) {
      _minHeight = 40;
      _maxHeight = 40;
    } else if (buttonSize == ButtonSizeTypes.MEDIUM) {
      _minHeight = 50;
      _maxHeight = 50;
    } else if (buttonSize == ButtonSizeTypes.LARGE) {
      _minHeight = 60;
      _maxHeight = 60;
    }

    _minHeight = height ?? _minHeight;
    _maxHeight = height ?? _maxHeight;

    return _ButtonHeight(min: _minHeight, max: _maxHeight);
  }

  @override
  Widget build(BuildContext context) {
    var _minWidth = 300.0;
    var _maxWidth = double.infinity;

    if (buttonType == ButtonTypes.ICON) {
      _minWidth = 0.0;
    }

    final buttonHeight = getButtonHeight();

    if (fullWidth) {
      _minWidth = double.infinity;
      _maxWidth = double.infinity;
    } else if (isNotNull(width)) {
      _minWidth = width;
      _maxWidth = width;
    }

    if (buttonType == ButtonTypes.TEXT || buttonType == ButtonTypes.ICON) {
      return getButton();
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: _minWidth,
        maxWidth: _maxWidth,
        minHeight: buttonHeight.min,
        maxHeight: buttonHeight.max,
      ),
      child: getButton(),
    );
  }
}

class _ButtonHeight {
  final double min;
  final double max;

  _ButtonHeight({
    @required this.min,
    @required this.max,
  });
}
