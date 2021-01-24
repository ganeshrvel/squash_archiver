import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/widgets/button/confirm_action_buttons.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';

class AppConfirmDialog extends AlertDialog {
  static void show(
    BuildContext context, {
    String title,
    String content,
    String okText,
    String cancelText,
    VoidCallback onOk,
    VoidCallback onCancel,
    IconData iconData,
    bool barrierDismissible,
  }) {
    final _barrierDismissible = barrierDismissible ?? true;

    showDialog(
      context: context,
      barrierDismissible: _barrierDismissible,
      builder: (BuildContext context) {
        return AppDialog(
          title: title,
          body: content,
          iconData: iconData,
          size: DialogSize.sm,
          actionContainer: ConfirmActionButtons(
            onOk: onOk,
            onCancel: onCancel,
            shouldPopOnButtonClick: true,
            cancelText: cancelText,
            okText: okText,
          ),
        );
      },
    );
  }
}
