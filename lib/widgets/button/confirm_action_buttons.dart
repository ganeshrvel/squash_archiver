import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/button/button.dart';

class ConfirmActionButtons extends StatelessWidget {
  final String? okText;
  final String? cancelText;
  final VoidCallback onOk;
  final VoidCallback onCancel;

  /// should the navigation stack pop on ok or cancel button click
  /// set this as false for overlays and true for modals
  final bool shouldPopOnButtonClick;

  const ConfirmActionButtons({
    super.key,
    this.okText,
    this.cancelText,
    required this.onOk,
    required this.onCancel,
    required this.shouldPopOnButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Button(
            text: cancelText ?? 'Cancel',
            controlSize: ControlSize.large,
            onPressed: () {
              if (isNotNull(onCancel)) {
                onCancel();
              }

              if (shouldPopOnButtonClick) {
                Navigator.of(context).pop();
              }
            },
            type: ButtonType.Push,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Button(
            controlSize: ControlSize.large,
            text: okText ?? 'Ok',
            onPressed: () {
              if (isNotNull(onOk)) {
                onOk();
              }

              if (shouldPopOnButtonClick) {
                Navigator.of(context).pop();
              }
            },
            secondary: false,
          ),
        ),
      ],
    );
  }
}
