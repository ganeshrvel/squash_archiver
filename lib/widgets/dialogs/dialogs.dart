import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';

class DialogConfirm extends AlertDialog {
  static void show(
    BuildContext context, {
    String title,
    String content,
    String okText,
    String cancelText,
    VoidCallback onOk,
    VoidCallback onCancel,
    IconData iconData,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppDialog(
          title: title,
          content: content,
          iconData: iconData,
          actionContainer: Row(
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

                    Navigator.of(context).pop();
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

                    Navigator.of(context).pop();
                  },
                  buttonType: ButtonType.FLAT,
                  disableAutoBoxConstraints: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
