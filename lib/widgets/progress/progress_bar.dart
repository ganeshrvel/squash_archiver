import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';

class ProgressBar extends StatelessWidget {
  final double? value;

  const ProgressBar({
    Key? key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _palette = getPalette(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 5,
          backgroundColor: _palette.progressBackgroundColor,
        ),
      ),
    );
  }
}
