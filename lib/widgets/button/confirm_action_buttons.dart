import 'package:flutter/widgets.dart';
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
    Key? key,
    this.okText,
    this.cancelText,
    required this.onOk,
    required this.onCancel,
    required this.shouldPopOnButtonClick,
  })  :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Button(
            text: cancelText ?? 'Cancel',
            onPressed: () {
              if (isNotNull(onCancel)) {
                onCancel();
              }

              if (shouldPopOnButtonClick) {
                Navigator.of(context).pop();
              }
            },
            buttonType: ButtonType.FLAT,
            buttonColor: ButtonColorType.WHITE,
            disableAutoBoxConstraints: true,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Button(
            text: okText ?? 'Ok',
            onPressed: () {
              if (isNotNull(onOk)) {
                onOk();
              }

              if (shouldPopOnButtonClick) {
                Navigator.of(context).pop();
              }
            },
            buttonType: ButtonType.FLAT,
            disableAutoBoxConstraints: true,
          ),
        ),
      ],
    );
  }
}
