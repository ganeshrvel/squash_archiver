import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

enum TextVariant {
  LargeTitle,
  Title1,
  Title2,
  Title3,
  Headline,
  Body,
  Callout,
  Subheadline,
  Footnote,
  Caption1,
  Caption2,
}

enum TypographyVariant {
  Primary,
  Secondary,
  Tertiary,
}

class Textography extends StatelessWidget {
  final String text;
  final TextVariant? variant;
  final TypographyVariant? typographyVariant;
  final Color? color;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final MacosFontWeight? fontWeight;
  final double? fontSize;
  final TextDecoration? decoration;
  final bool capitalize;
  final bool emphasized;
  final TextOverflow? overflow;
  final bool? preventAutoTextStyling;
  final int? maxLines;
  final TextDirection? textDirection;
  final TextStyle? textStyle;

  const Textography(
    this.text, {
    super.key,
    this.variant,
    this.typographyVariant,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.decoration,
    this.backgroundColor,
    this.fontSize,
    this.capitalize = false,
    this.emphasized = false,
    this.overflow,
    this.preventAutoTextStyling = false,
    this.maxLines,
    this.textDirection,
    this.textStyle,
  });

  TypographyVariant get _typographyVariant =>
      typographyVariant ?? TypographyVariant.Primary;

  bool get _preventAutoTextStyling => preventAutoTextStyling ?? false;

  // Define the function to get the style for each TextVariant
  TextStyle _getTextStyleForVariant({required BuildContext context}) {
    final typography = MacosTypography.of(context);
    switch (variant) {
      case TextVariant.LargeTitle:
        return typography.largeTitle.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w700 : MacosFontWeight.normal);
      case TextVariant.Title1:
        return typography.title1.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w700 : MacosFontWeight.normal);
      case TextVariant.Title2:
        return typography.title2.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w700 : MacosFontWeight.normal);
      case TextVariant.Title3:
        return typography.title3.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w600 : MacosFontWeight.normal);
      case TextVariant.Headline:
        return typography.headline.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w860 : MacosFontWeight.normal);
      case TextVariant.Body:
      case null:
        return typography.body.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w590 : MacosFontWeight.normal);
      case TextVariant.Callout:
        return typography.callout.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w590 : MacosFontWeight.normal);
      case TextVariant.Subheadline:
        return typography.subheadline.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w590 : MacosFontWeight.normal);
      case TextVariant.Footnote:
        return typography.footnote.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w590 : MacosFontWeight.normal);
      case TextVariant.Caption1:
        return typography.caption1.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w510 : MacosFontWeight.normal);
      case TextVariant.Caption2:
        return typography.caption2.copyWith(
            fontWeight:
                emphasized ? MacosFontWeight.w590 : MacosFontWeight.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (textStyle != null && variant != null) {
      throw "When 'textStyle' is available, 'variant' should be null";
    }

    var _text = text;
    if (capitalize) {
      _text = _text.toUpperCase();
    }

    var customTextStyle = textStyle;

    if (!_preventAutoTextStyling && textStyle == null) {
      customTextStyle = _getTextStyleForVariant(context: context);
    }

    if (customTextStyle != null) {
      customTextStyle = customTextStyle.copyWith(
        fontSize: fontSize ?? customTextStyle.fontSize,
        color: color ?? customTextStyle.color,
        fontWeight: fontWeight ?? customTextStyle.fontWeight,
        decoration: decoration ?? customTextStyle.decoration,
      );
    }

    return Text(
      text,
      style: customTextStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      textDirection: textDirection,
    );
  }
}
