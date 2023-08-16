import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/material.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppConfirmDialog extends AlertDialog {
  static void show(
    BuildContext context, {
    String? title,
    String? content,
    String? okText,
    String? cancelText,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    IconData? iconData,
    bool? barrierDismissible,
  }) {
    final _barrierDismissible = barrierDismissible ?? true;
    final _content = content ?? 'Info';
    final _iconData = iconData ?? CupertinoIcons.info;

    showMacosAlertDialog(
      context: context,
      barrierDismissible: _barrierDismissible,
      builder: (BuildContext context) {
        return MacosAlertDialog(
          horizontalActions: true,
          title: isNotNullOrEmpty(title)
              ? Textography(title!)
              : const SizedBox.shrink(),
          appIcon: MacosIcon(_iconData),
          message: Textography(
            _content,
            textAlign: TextAlign.center,
          ),
          primaryButton: PushButton(
            onPressed: () {
              if (isNotNull(onOk)) {
                onOk!();
              }

              Navigator.of(context).pop();
            },
            controlSize: ControlSize.large,
            child: Textography(
              okText ?? 'Ok',
              preventAutoTextStyling: true,
            ),
          ),
          secondaryButton: PushButton(
            secondary: true,
            onPressed: () {
              if (isNotNull(onOk)) {
                onCancel!();
              }

              Navigator.of(context).pop();
            },
            controlSize: ControlSize.large,
            child: Textography(
              okText ?? 'Cancel',
              preventAutoTextStyling: true,
            ),
          ),
        );
      },
    );
  }
}
