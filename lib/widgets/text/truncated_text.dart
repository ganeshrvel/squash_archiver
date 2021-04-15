import 'package:flutter/material.dart';
import 'package:squash_archiver/common/models/truncated_string.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/strings.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class TruncatedText extends StatelessWidget {
  /// original string
  final String? originalText;

  /// truncated string
  /// Either [originalText] or [truncatedText] is required
  /// [truncatedText] will be given priority
  final TruncatedString? truncatedText;

  final TextVariant? variant;
  final Color? color;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const TruncatedText({
    Key? key,
    this.originalText,
    this.truncatedText,
    this.variant,
    this.color,
    this.fontWeight,
    this.backgroundColor,
    this.decoration,
    this.fontSize,
    this.textAlign,
    this.overflow,
  })  : assert(originalText != null || truncatedText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _originalText = originalText ?? '';
    var _truncatedText = truncatedText;

    /// if [truncatedText] is null then truncate [originalText]
    if (isNull(truncatedText)) {
      _truncatedText = truncatedString(text: _originalText);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            Characters(_truncatedText!.firstChunk).toList().join('\u{200B}'),
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
            softWrap: true,
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
