import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/overlays/app_overlay.dart';
import 'package:squash_archiver/widgets/progress/progress_bar.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class ProgressOverlay extends StatelessWidget {
  /// should overlay be visible
  final bool visible;

  /// progress value
  final double value;

  /// loading text
  final String loadingText;

  const ProgressOverlay({
    Key key,
    @required this.visible,
    this.value,
    this.loadingText,
  })  : assert(visible != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _palette = getPalette(context);

    return AppOverlay(
      visible: visible,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNotNullOrEmpty(loadingText))
            Textography(
              loadingText,
              color: _palette.captionColor,
              variant: TextVariant.small1,
              fontWeight: FontWeight.bold,
            ),
          ProgressBar(
            value: value,
          ),
        ],
      ),
    );
  }
}
