import 'package:flutter/material.dart';
import 'package:squash_archiver/widgets/button/button.dart';
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
                  variant: TextVariant.body1,
                ),
          content: Textography(
            content,
            variant: TextVariant.body1,
          ),
          actions: <Widget>[
            Button(
              text: 'Ok',
              onPressed: () => Navigator.of(context).pop(),
              textVariant: TextVariant.body1,
              buttonType: ButtonType.FLAT,
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
                  variant: TextVariant.body1,
                ),
          content: Textography(
            content,
            variant: TextVariant.body1,
          ),
          actions: <Widget>[
            Button(
              text: 'No',
              onPressed: () => Navigator.of(context).pop(),
              buttonType: ButtonType.FLAT,
            ),
            Button(
              text: 'Yes',
              onPressed: () {
                Navigator.of(context).pop();
                onYes();
              },
              buttonType: ButtonType.FLAT,
            ),
          ],
        );
      },
    );
  }
}
