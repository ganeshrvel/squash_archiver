import 'package:flutter/cupertino.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/widgets/overlays/app_dialog_body.dart';

class AppOverlay extends StatelessWidget {
  /// should overlay be visible
  final bool visible;

  /// child widget or the main content
  final Widget? content;

  /// bottom most action part. commonly used for action buttons like Ok and Cancel
  final Widget? actionContainer;

  /// setting this value as true will hide dialog background
  final bool? hideDialogBackground;

  AppOverlay({
    super.key,
    required this.visible,
    this.content,
    this.actionContainer,
    this.hideDialogBackground = false,
  }) {
    if (_hideDialogBackground) {
      assert(content != null,
          "When 'hideDialogBackground' is true 'content' should not be null.");
    }
  }

  bool get _hideDialogBackground => hideDialogBackground ?? false;

  Widget _buildBody() {
    if (_hideDialogBackground) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              return content ?? const SizedBox.shrink();
            },
          ),
        ],
      );
    }

    return AppDialogBody(
      actionContainer: actionContainer,
      content: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final barrierColor = MacosDynamicColor.resolve(
      MacosColors.controlBackgroundColor,
      context,
    ).withOpacity(0.6);

    return PortalTarget(
      visible: visible,
      portalFollower: ColoredBox(
        color: barrierColor,
        child: Center(
          child: _buildBody(),
        ),
      ),
      child: Container(),
    );
  }
}
