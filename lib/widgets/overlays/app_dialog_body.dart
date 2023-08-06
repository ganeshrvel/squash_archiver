import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/material.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum DialogSize {
  sm,
  md,
  lg,
}

class AppDialogBody extends StatelessWidget {
  /// title value
  final String? title;

  /// body value
  final String? body;

  /// child widget or the main content
  final Widget? content;

  /// bottom most action part. commonly used for action buttons like Ok and Cancel
  final Widget? actionContainer;

  final IconData? iconData;

  final DialogSize? size;

  const AppDialogBody({
    this.iconData,
    this.title,
    this.body,
    this.content,
    this.actionContainer,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    var _maxWidth = 0.0;

    switch (size) {
      case DialogSize.lg:
        _maxWidth = 800;
        break;

      case DialogSize.md:
        _maxWidth = 700;
        break;

      case DialogSize.sm:
      default:
        _maxWidth = 300;
        break;
    }

    final _dialogConstraints = BoxConstraints(
      maxWidth: _maxWidth,
    );

    const _borderRadius = BorderRadius.all(Radius.circular(12.0));
    final brightness = MacosTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      Colors.black.withOpacity(0.23),
      Colors.black.withOpacity(0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withOpacity(0.45),
      Colors.white.withOpacity(0.15),
    );

    return Dialog(
      backgroundColor: brightness.resolve(
        CupertinoColors.systemGrey6.color,
        MacosColors.controlBackgroundColor.darkColor,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: innerBorderColor,
          ),
          borderRadius: _borderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: outerBorderColor,
          ),
          borderRadius: _borderRadius,
        ),
        child: ConstrainedBox(
          constraints: _dialogConstraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isNotNullOrEmpty(iconData))
                    Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Icon(
                          iconData,
                          size: 45,
                        ),
                      ],
                    ),
                  if (isNotNullOrEmpty(title))
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 400,
                            ),
                            child: Textography(
                              title!,
                              variant: TextVariant.Body,
                              fontWeight: MacosFontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (isNotNullOrEmpty(body))
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Textography(
                          body!,
                          variant: TextVariant.Caption2,
                          fontWeight: MacosFontWeight.w300,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  if (isNotNull(content))
                    Column(
                      children: [
                        content!,
                      ],
                    ),
                ],
              ),
              if (isNotNull(actionContainer))
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    actionContainer!,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
