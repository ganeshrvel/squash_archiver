import 'package:flutter/material.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/img/img.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum ButtonType {
  FLAT,
  RAISED,
  ICON,
  TEXT,
  TILE,
  IMAGE,
}

enum ButtonColorType {
  WHITE,
  BLACK,
  BLUE,
  INFO,
  TRANSPARENT,
  ColorF1F,
}

enum ButtonSizeType {
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
  final ButtonType buttonType;
  final double height;
  final double width;
  final ButtonColorType buttonColor;
  final double elevation;
  final double iconButtonIconSize;
  final Color iconColor;
  final ButtonColorType buttonTextColor;
  final bool roundedEdge;
  final double radius;
  final ButtonSizeType buttonSize;
  final bool textAutoCapitalize;
  final bool underline;
  final TextVariant textVariant;
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
    this.buttonType = ButtonType.RAISED,
    this.height,
    this.width,
    this.fullWidth = false,
    this.buttonColor,
    this.buttonTextColor,
    this.elevation = 1,
    this.roundedEdge = true,
    this.radius = 6.0,
    this.buttonSize = ButtonSizeType.LARGE,
    this.textAutoCapitalize = false,
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
  Color _buttonColorMapping(ButtonColorType _colorType) {
    switch (_colorType) {
      case ButtonColorType.WHITE:
        return AppColors.white;

      case ButtonColorType.BLACK:
        return AppColors.black;

      case ButtonColorType.ColorF1F:
        return AppColors.colorF1F;

      case ButtonColorType.INFO:
        return AppColors.info;

      case ButtonColorType.TRANSPARENT:
        return Colors.transparent;

      case ButtonColorType.BLUE:
      default:
        return AppColors.blue;
    }
  }

  Color getButtonBgColor() {
    if (isNotNull(buttonColor)) {
      return _buttonColorMapping(buttonColor);
    } else if (buttonType == ButtonType.ICON ||
        buttonType == ButtonType.TEXT ||
        buttonType == ButtonType.IMAGE) {
      return Colors.transparent;
    }

    if (isNotNull(buttonTextColor)) {
      switch (buttonTextColor) {
        case ButtonColorType.WHITE:
          return AppColors.black;

        default:
          return AppColors.white;
      }
    }

    if (buttonType == ButtonType.TEXT) {
      return AppColors.white;
    }

    return AppColors.blue;
  }

  Color getButtonTextColor() {
    switch (buttonType) {
      case ButtonType.TEXT:
      case ButtonType.ICON:
      case ButtonType.TILE:
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

    if (buttonType == ButtonType.ICON) {
      return AppColors.black;
    }

    if (isNotNull(buttonColor)) {
      switch (buttonColor) {
        case ButtonColorType.WHITE:
          return AppColors.black;

        default:
          return AppColors.white;
      }
    }

    if (buttonType == ButtonType.TEXT) {
      return AppColors.blue;
    }

    return AppColors.white;
  }

  OutlinedBorder getBtnShape() {
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
    final _textVariant = textVariant ?? TextVariant.button;

    switch (buttonType) {
      case ButtonType.FLAT:
        return isNull(icon)
            ? TextButton(
                style: ElevatedButton.styleFrom(
                  elevation: elevation,
                  primary: getButtonBgColor(),
                  shape: getBtnShape(),
                ),
                onPressed: isButtonDisabled() ? null : onPressed,
                child: Textography(
                  getButtonText(),
                  variant: _textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              )
            : TextButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: elevation,
                  primary: iconColor ?? getButtonTextColor(),
                  shape: getBtnShape(),
                  textStyle:
                      TextStyle(color: iconColor ?? getButtonTextColor()),
                ),
                icon: Icon(
                  icon,
                  textDirection: iconTextDirection,
                ),
                onPressed: isButtonDisabled() ? null : onPressed,
                label: Textography(
                  getButtonText(),
                  variant: textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              );
        break;

      case ButtonType.ICON:
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

      case ButtonType.IMAGE:
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

      case ButtonType.TILE:
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

      case ButtonType.TEXT:
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

      case ButtonType.RAISED:
      default:
        return isNull(icon)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: elevation,
                  primary: getButtonBgColor(),
                  shape: getBtnShape(),
                ),
                onPressed: isButtonDisabled() ? null : onPressed,
                child: Textography(
                  getButtonText(),
                  variant: _textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              )
            : ElevatedButton.icon(
                icon: Icon(
                  icon,
                  textDirection: iconTextDirection,
                ),
                style: ElevatedButton.styleFrom(
                    elevation: elevation,
                    primary: getButtonBgColor(),
                    shape: getBtnShape(),
                    enableFeedback: true,
                    textStyle:
                        TextStyle(color: iconColor ?? getButtonTextColor())),
                onPressed: isButtonDisabled() ? null : onPressed,
                label: Textography(
                  getButtonText(),
                  variant: _textVariant,
                  color: buttonStyle.color,
                  fontWeight: buttonStyle.fontWeight,
                ),
              );
    }
  }

  _ButtonHeight getButtonHeight() {
    var _minHeight = 30.0;
    var _maxHeight = 30.0;

    if (buttonSize == ButtonSizeType.SMALL) {
      _minHeight = 24;
      _maxHeight = 24;
    }

    _minHeight = height ?? _minHeight;
    _maxHeight = height ?? _maxHeight;

    return _ButtonHeight(min: _minHeight, max: _maxHeight);
  }

  @override
  Widget build(BuildContext context) {
    var _minWidth = 200.0;
    var _maxWidth = double.infinity;

    if (buttonType == ButtonType.ICON) {
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
      case ButtonType.TEXT:
      case ButtonType.ICON:
      case ButtonType.TILE:
        return getButton();

      default:
        break;
    }

    if (disableAutoBoxConstraints == true ||
        buttonType == ButtonType.TEXT ||
        buttonType == ButtonType.ICON ||
        buttonType == ButtonType.TILE ||
        buttonType == ButtonType.IMAGE) {
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
