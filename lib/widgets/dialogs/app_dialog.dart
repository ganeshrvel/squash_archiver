import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum DialogSize {
  sm,
  md,
  lg,
}

class AppDialog extends StatelessWidget {
  /// title value
  final String title;

  /// body value
  final String body;

  /// child widget or the main content
  final Widget content;

  /// bottom most action part. commonly used for action buttons like Ok and Cancel
  final Widget actionContainer;

  final IconData iconData;

  final DialogSize size;

  const AppDialog({
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                                title,
                                variant: TextVariant.body2,
                                fontWeight: FontWeight.bold,
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
                            body,
                            variant: TextVariant.small1,
                            fontWeight: FontWeight.w300,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    if (isNotNull(content))
                      Column(
                        children: [
                          content,
                        ],
                      ),
                  ],
                ),
                if (isNotNull(actionContainer))
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      actionContainer,
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
