import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widget_extends/material.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

enum ButtonType {
  Push,
  Icon,
}

class Button extends StatelessWidget {
  final String? text;
  final ButtonType? type;
  final ControlSize? controlSize;
  final bool loading;
  final String? loadingText;
  final bool disabled;
  final bool secondary;
  final Color? color;
  final VoidCallback? onPressed;
  final Widget? macosIcon;
  final BorderRadius? borderRadius;
  final BoxShape? shape;
  final BoxConstraints? iconButtonBoxConstraints;

  Button({
    required this.onPressed,
    this.text,
    this.controlSize = ControlSize.regular,
    this.type = ButtonType.Push,
    this.loading = false,
    this.loadingText,
    this.color,
    this.disabled = false,
    this.secondary = true,
    this.macosIcon,
    this.borderRadius,
    this.shape,
    this.iconButtonBoxConstraints,
  })  : assert(
          !(type == ButtonType.Push && isNullOrEmpty(text)),
          'If the type is ButtonType.PUSH, the text must not be null.',
        ),
        assert(
          !(type == ButtonType.Icon && macosIcon == null),
          'If the type is ButtonType.ICON, the macosIcon must not be null.',
        );

  String getButtonText() {
    if (loading && isNotNullOrEmpty(loadingText)) {
      return loadingText!;
    }

    return text ?? '';
  }

  bool isButtonDisabled() {
    if (disabled) {
      return true;
    }

    if (loading) {
      return true;
    }

    return false;
  }

  void _onPressed() {
    return isButtonDisabled() ? null : onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final _type = isNotNull(type) ? type : ButtonType.Push;

    switch (_type!) {
      case ButtonType.Push:
        return PushButton(
          controlSize: controlSize!,
          onPressed: _onPressed,
          secondary: secondary,
          color: color,
          borderRadius: borderRadius,
          child: Textography(
            getButtonText(),
            preventAutoTextStyling: true,
          ),
        );
      case ButtonType.Icon:
        return MacosIconButton(
          icon: macosIcon!,
          shape: shape ?? BoxShape.rectangle,
          borderRadius: borderRadius ?? BorderRadius.circular(7),
          onPressed: _onPressed,
          backgroundColor: Colors.transparent,
          boxConstraints: iconButtonBoxConstraints ??
              const BoxConstraints(
                minHeight: 20,
                minWidth: 20,
                maxWidth: 30,
                maxHeight: 30,
              ),
        );
    }
  }
}
