import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/img/img.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum ButtonTypes {
  FLAT,
  RAISED,
  ICON,
  TEXT,
  TILE,
  IMAGE,
}

enum ButtonColorTypes {
  WHITE,
  BLACK,
  BLUE,
  INFO,
  TRANSPARENT,
  ColorF1F,
}

enum ButtonSizeTypes {
  SMALL,
  LARGE,
}

class Button extends StatelessWidget {
  final String text;
  final bool loading;
  final String loadingText;
  final bool disabled;
  final bool fullWidth;
  final IconData icon;
  final TextDirection iconTextDirection;
  final EdgeInsetsGeometry iconButtonPadding;
  final EdgeInsetsGeometry imageButtonPadding;
  final EdgeInsetsGeometry textButtonPadding;
  final VoidCallback onPressed;
  final ButtonTypes buttonType;
  final double height;
  final double width;
  final ButtonColorTypes buttonColor;
  final double elevation;
  final double iconButtonIconSize;
  final Color iconColor;
  final ButtonColorTypes buttonTextColor;
  final bool roundedEdge;
  final double radius;
  final ButtonSizeTypes buttonSize;
  final bool textAutoCapitalize;
  final bool underline;
  final TextVariants textVariant;
  final FontWeight fontWeight;
  final bool disableAutoBoxConstraints;
  final Color splashColor;
  final Color highlightColor;
  final Img image;

  const Button({
    @required this.text,
    @required this.onPressed,
    this.loading = false,
    this.loadingText,
    this.disabled = false,
    this.icon,
    this.iconTextDirection,
    this.iconButtonPadding,
    this.imageButtonPadding,
    this.textButtonPadding,
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
    this.iconButtonIconSize = 30.0,
    this.underline = true,
    this.textVariant,
    this.fontWeight,
    this.iconColor,
    this.disableAutoBoxConstraints,
    this.splashColor,
    this.image,
    this.highlightColor,
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

  // add new ButtonColorTypes colors here
  Color _buttonColorMapping(ButtonColorTypes _colorType) {
    switch (_colorType) {
      case ButtonColorTypes.WHITE:
        return AppColors.white;

      case ButtonColorTypes.BLACK:
        return AppColors.black;

      case ButtonColorTypes.ColorF1F:
        return AppColors.colorF1F;

      case ButtonColorTypes.INFO:
        return AppColors.info;

      case ButtonColorTypes.TRANSPARENT:
        return Colors.transparent;

      case ButtonColorTypes.BLUE:
      default:
        return AppColors.blue;
    }
  }

  Color getButtonBgColor() {
    if (isNotNull(buttonColor)) {
      return _buttonColorMapping(buttonColor);
    } else if (buttonType == ButtonTypes.ICON ||
        buttonType == ButtonTypes.TEXT ||
        buttonType == ButtonTypes.IMAGE) {
      return Colors.transparent;
    }

    if (isNotNull(buttonTextColor)) {
      switch (buttonTextColor) {
        case ButtonColorTypes.WHITE:
          return AppColors.blue;

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
    switch (buttonType) {
      case ButtonTypes.TEXT:
      case ButtonTypes.ICON:
      case ButtonTypes.TILE:
        if (isButtonDisabled()) {
          return AppColors.disabled;
        }
        break;

      default:
        break;
    }

    if (isNotNull(buttonTextColor)) {
      return _buttonColorMapping(buttonTextColor);
    }

    if (buttonType == ButtonTypes.ICON) {
      return AppColors.black;
    }

    if (isNotNull(buttonColor)) {
      switch (buttonColor) {
        case ButtonColorTypes.WHITE:
          return AppColors.blue;

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
    final _roundedEdge = roundedEdge ?? false;

    if (!_roundedEdge) {
      return const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      );
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
                splashColor: splashColor,
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
                  textDirection: iconTextDirection,
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
                textColor: iconColor ?? getButtonTextColor(),
              );
        break;

      case ButtonTypes.ICON:
        if (isNull(icon)) {
          throw 'icon cannot be empty';
        }

        return ClipOval(
          child: Material(
            color: getButtonBgColor(),
            child: InkWell(
              splashColor: AppColors.splash,
              onTap: isButtonDisabled() ? null : onPressed,
              child: SizedBox(
                width: width,
                height: height,
                child: Padding(
                  padding: iconButtonPadding ?? const EdgeInsets.all(0),
                  child: Icon(
                    icon,
                    textDirection: iconTextDirection,
                    color: iconColor ?? getButtonTextColor(),
                    size: iconButtonIconSize,
                  ),
                ),
              ),
            ),
          ),
        );

      case ButtonTypes.IMAGE:
        if (isNull(image)) {
          throw 'image cannot be empty';
        }

        return ClipOval(
          child: Material(
            color: getButtonBgColor(),
            child: InkWell(
              splashColor: splashColor ?? AppColors.splash,
              highlightColor: highlightColor,
              onTap: isButtonDisabled() ? null : onPressed,
              child: SizedBox(
                width: width,
                height: height,
                child: Padding(
                  padding: imageButtonPadding ?? EdgeInsets.zero,
                  child: image,
                ),
              ),
            ),
          ),
        );

      case ButtonTypes.TILE:
        if (isNull(icon)) {
          throw 'icon cannot be empty';
        }

        return Center(
          child: Container(
            color: getButtonBgColor(),
            child: Material(
              color: getButtonBgColor(),
              child: InkWell(
                splashColor: AppColors.splash,
                onTap: isButtonDisabled() ? null : onPressed,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        textDirection: iconTextDirection,
                        color: iconColor ?? getButtonTextColor(),
                        size: iconButtonIconSize,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          5,
                          0,
                          (iconButtonIconSize ?? 0) / 10,
                        ),
                        child: Textography(
                          getButtonText(),
                          variant: isNotNull(textVariant) ? textVariant : null,
                          fontWeight: buttonStyle.fontWeight,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

      case ButtonTypes.TEXT:
        final _textButtonPadding = textButtonPadding ?? EdgeInsets.zero;

        return InkWell(
          onTap: isButtonDisabled() ? null : onPressed,
          splashColor: splashColor ?? Colors.transparent,
          highlightColor: highlightColor ?? Colors.transparent,
          child: Padding(
            padding: _textButtonPadding,
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
                  textDirection: iconTextDirection,
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
                textColor: iconColor ?? getButtonTextColor(),
              );
    }
  }

  _ButtonHeight getButtonHeight() {
    var _minHeight = 28.0;
    var _maxHeight = 28.0;

    if (buttonSize == ButtonSizeTypes.SMALL) {
      _minHeight = 20;
      _maxHeight = 20;
    } else if (buttonSize == ButtonSizeTypes.LARGE) {
      _minHeight = 28;
      _maxHeight = 28;
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

    switch (buttonType) {
      case ButtonTypes.TEXT:
      case ButtonTypes.ICON:
      case ButtonTypes.TILE:
        return getButton();

      default:
        break;
    }

    if (disableAutoBoxConstraints == true ||
        buttonType == ButtonTypes.TEXT ||
        buttonType == ButtonTypes.ICON ||
        buttonType == ButtonTypes.TILE ||
        buttonType == ButtonTypes.IMAGE) {
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
