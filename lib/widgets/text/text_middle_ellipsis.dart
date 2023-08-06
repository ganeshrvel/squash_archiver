import 'package:flutter/cupertino.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

extension _AppStringExtension on String {
  String get fixOverflowEllipsis => Characters(this)
      .replaceAll(Characters(''), Characters('\u{200B}'))
      .toString();
}

class TextMiddleEllipsis extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle textStyle;

  const TextMiddleEllipsis(
    this.text, {
    required this.textStyle,
    this.textAlign,
  });

  static const textDirection = TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth <= _textSize(text, textStyle).width &&
            text.length > 10) {
          final endPart = text.trim().substring(text.length - 10);
          return Row(
            children: [
              Flexible(
                child: Textography(
                  text.fixOverflowEllipsis,
                  textAlign: textAlign,
                  overflow: TextOverflow.ellipsis,
                  textDirection: textDirection,
                  textStyle: textStyle,
                ),
              ),
              Textography(
                endPart,
                textAlign: textAlign,
                textDirection: textDirection,
                textStyle: textStyle,
              ),
            ],
          );
        }
        return Textography(
          text,
          textAlign: textAlign,
          maxLines: 1,
          textDirection: textDirection,
          textStyle: textStyle,
        );
      },
    );
  }

  Size _textSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 1,
      textDirection: textDirection,
    )..layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );
    return textPainter.size;
  }
}
