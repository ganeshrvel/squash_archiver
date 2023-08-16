import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/overlays/app_overlay.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum ProgressType {
  Circular,
  Linear,
}

class ProgressOverlay extends StatelessWidget {
  /// should overlay be visible
  final bool visible;

  /// progress value
  final double? value;

  /// loading text
  final String? loadingText;

  /// progress loader type
  final ProgressType? type;

  ProgressOverlay({
    super.key,
    required this.visible,
    this.value,
    this.loadingText,
    this.type,
  }) {
    if (type == ProgressType.Linear) {
      assert(value != null, "'value' cannot be null when 'type' is Linear");
    }
  }

  Widget _buildProgress() {
    return switch (type) {
      null || ProgressType.Circular => ProgressCircle(value: value),
      ProgressType.Linear => ProgressBar(
          value: value ?? 0,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      visible: visible,
      hideDialogBackground: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProgress(),
          if (isNotNullOrEmpty(loadingText))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Textography(
                loadingText!,
                typographyVariant: TypographyVariant.Tertiary,
                variant: TextVariant.Caption2,
                fontWeight: MacosFontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
