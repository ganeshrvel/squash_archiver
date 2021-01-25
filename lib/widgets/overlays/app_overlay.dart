import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:squash_archiver/widgets/dialogs/app_dialog.dart';

class AppOverlay extends StatelessWidget {
  /// should overlay be visible
  final bool visible;

  /// child widget or the main content
  final Widget content;

  /// bottom most action part. commonly used for action buttons like Ok and Cancel
  final Widget actionContainer;

  const AppOverlay({
    Key key,
    @required this.visible,
    this.content,
    this.actionContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalEntry(
      visible: visible,
      portal: Container(
        color: Colors.black.withOpacity(0.25),
        child: Center(
          child: AppDialog(
            actionContainer: actionContainer,
            content: content,
          ),
        ),
      ),
      child: Container(),
    );
  }
}
