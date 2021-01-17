import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';
import 'package:squash_archiver/widgets/progress/progress_bar.dart';

class ProgressDialog extends AlertDialog {
  static void show(
    BuildContext context, {
    String title,
    String content,
    Widget body1,
    Widget body2,
    IconData iconData,
    bool barrierDismissible,
    DialogSize size,
  }) {
    final _barrierDismissible = barrierDismissible ?? true;
    final _size = size ?? DialogSize.md;
    final _body1 = body1 ?? Container();
    final _body2 = body2 ?? Container();

    showDialog(
      context: context,
      barrierDismissible: _barrierDismissible,
      builder: (BuildContext context) {
        return AppDialog(
          title: title,
          body: content,
          iconData: iconData,
          size: _size,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _body1,
              const ProgressBar(
                value: .5,
              ),
              _body2,
            ],
          ),
        );
      },
    );
  }
}
