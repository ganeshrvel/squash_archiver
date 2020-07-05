import 'package:flutter/material.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class DialogAlert extends AlertDialog {
  static void show(BuildContext context, String content, {String title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == null
              ? null
              : Textography(
                  title,
                  variant: TextVariants.body1,
                ),
          content: Textography(
            content,
            variant: TextVariants.body1,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Textography(
                'Ok',
                variant: TextVariants.body1,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DialogConfirm extends AlertDialog {
  static void show(
    BuildContext context,
    String content,
    Function() onYes, {
    String title,
    String yes,
    String no,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == null
              ? null
              : Textography(
                  title,
                  variant: TextVariants.body1,
                ),
          content: Textography(
            content,
            variant: TextVariants.body1,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Textography(
                'No',
                variant: TextVariants.body1,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                onYes();
              },
              child: const Textography(
                'Yes',
                variant: TextVariants.body1,
              ),
            ),
          ],
        );
      },
    );
  }
}
