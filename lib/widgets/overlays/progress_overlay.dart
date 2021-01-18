import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';
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
    return PortalEntry(
      visible: visible,
      portal: Container(
        color: AppColors.white.withOpacity(0.1),
        child: Center(
          child: AppDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNotNullOrEmpty(loadingText))
                  Textography(
                    loadingText,
                    color: AppColors.color797,
                    variant: TextVariant.small1,
                    fontWeight: FontWeight.bold,
                  ),
                ProgressBar(
                  value: value,
                ),
              ],
            ),
          ),
        ),
      ),
      child: Container(),
    );
  }
}
