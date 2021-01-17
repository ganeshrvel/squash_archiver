import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/strings.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class TruncatedText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final Color color;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final TextDecoration decoration;
  final double fontSize;
  final TextAlign textAlign;
  final TextOverflow overflow;

  const TruncatedText(
    this.text, {
    Key key,
    this.variant,
    this.color,
    this.fontWeight,
    this.backgroundColor,
    this.decoration,
    this.fontSize,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _text = text ?? '';
    final _truncatedText = truncatedString(text: _text);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            _truncatedText.firstChunk,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
              backgroundColor: backgroundColor,
              decoration: decoration,
            ),
            maxLines: 1,
            textAlign: textAlign,
            overflow: overflow ?? TextOverflow.ellipsis,
          ),
        ),
        Text(
          _truncatedText.lastChunk,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            backgroundColor: backgroundColor,
            decoration: decoration,
          ),
          textAlign: textAlign,
        )
      ],
    );
  }
}
