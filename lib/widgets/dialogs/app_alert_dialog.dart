import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/button/button.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';

class AppAlertDialog extends AlertDialog {
  static void show(
    BuildContext context, {
    String title,
    String content,
    String okText,
    VoidCallback onOk,
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
          actionContainer: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
