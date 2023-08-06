import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';
import 'package:squash_archiver/widget_extends/material.dart';

// todo convert the snackbar into macos style notifications
@LazySingleton()
class FlushbarHelper {
  Flushbar buildSnackbar({
    BuildContext? context,
    required String title,
    required String message,
    bool? isDismissible,
    Duration? duration,
  }) {
    final _isDismissible = isDismissible ?? true;
    final _duration = duration ?? const Duration(seconds: 4);
    final brightness = getPlatformBrightness(context);

    Color? backgroundColor;
    Color? bodyColor;

    switch (brightness) {
      case Brightness.dark:
        backgroundColor = MacosColors.controlBackgroundColor.darkColor;
        bodyColor = MacosColors.textColor;
        break;
      case Brightness.light:
      case null:
        backgroundColor = CupertinoColors.systemGrey6.color;
        bodyColor = MacosColors.labelColor;
        break;
    }

    final _flushbarInstance = Flushbar(
      title: title,
      message: message,
      messageColor: bodyColor,
      titleColor: bodyColor,
      messageSize: 12,
      endOffset: const Offset(0, 0.23),
      titleSize: 13,
      barBlur: 1,
      maxWidth: 400,
      backgroundColor: backgroundColor.withOpacity(0.9),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      margin: const EdgeInsets.only(right: 10),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      boxShadows: const [
        BoxShadow(
          color: Colors.black38,
          offset: Offset(1.0, 1.0),
          blurRadius: 3.0,
        ),
      ],
      isDismissible: _isDismissible,
      duration: _duration,
    );

    if (context == null) {
      return _flushbarInstance;
    }

    return _flushbarInstance..show(context);
  }

  Flushbar buildErrorSnackbar({
    BuildContext? context,
    required String title,
    required String message,
    required Duration? duration,
  }) {
    return buildSnackbar(
      context: context,
      title: title,
      message: message,
      duration: duration,
    );
  }
}
