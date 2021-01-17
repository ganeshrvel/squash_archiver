import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class AppDialog extends StatelessWidget {
  final String title;

  final String content;

  final Widget actionContainer;

  final IconData iconData;

  const AppDialog({
    this.iconData,
    this.title,
    this.content,
    this.actionContainer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
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
                  if (isNotNullOrEmpty(content))
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Textography(
                          content,
                          variant: TextVariant.small1,
                          fontWeight: FontWeight.w300,
                          textAlign: TextAlign.center,
                        ),
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
                )
            ],
          ),
        ),
      ),
    );
  }
}
