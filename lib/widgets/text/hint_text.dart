import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/colors.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum HintTextTypes {
  ERROR,
  SUCCESS,
  WARN,
  INFO,
  REGULAR,
}

class HintText extends StatelessWidget {
  final String text;
  final HintTextTypes type;

  const HintText({
    Key key,
    this.text,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _text = text ?? '';
    Color _color;

    switch (type) {
      case HintTextTypes.ERROR:
        _color = AppColors.error;
        break;
      case HintTextTypes.SUCCESS:
        _color = AppColors.success;
        break;
      case HintTextTypes.WARN:
        _color = AppColors.warn;
        break;
      case HintTextTypes.INFO:
        _color = AppColors.info;
        break;
      case HintTextTypes.REGULAR:
      default:
        _color = AppColors.color232526;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 1,
      ),
      child: Textography(
        _text,
        color: _color,
        fontSize: 13.0,
        textAlign: TextAlign.left,
      ),
    );
  }
}
