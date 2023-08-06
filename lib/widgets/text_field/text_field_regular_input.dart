import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/widgets/text/textography.dart';

class TextFieldRegularInput extends StatelessWidget {
  final ScrollController scrollController;
  final int? maxLength;
  final int? minLines;
  final int maxLines;
  final bool disabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final String? placeholder;
  final Widget? suffix;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;

  const TextFieldRegularInput({
    super.key,
    required this.onChanged,
    required this.scrollController,
    required this.controller,
    this.onSubmitted,
    this.maxLength,
    this.disabled = false,
    this.errorText,
    this.placeholder,
    this.suffix,
    this.focusNode,
    this.autofocus = false,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
    this.obscureText = false,
    this.autocorrect = false,
    this.enableSuggestions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MacosTextField(
          scrollController: scrollController,
          suffix: suffix,
          prefix: isNotNull(prefixIcon) ? MacosIcon(prefixIcon) : null,
          placeholder: placeholder,
          enabled: !disabled,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          autofocus: autofocus,
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {
            if (onSubmitted != null) {
              onSubmitted?.call(value);
            }
          },
          onChanged: (String value) {
            if (isNotNull(maxLength) && value.length > maxLength!) {
              return;
            }

            if (isNotNull(onChanged)) {
              onChanged(value);
            }
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Textography(
            errorText ?? '',
            textAlign: TextAlign.left,
            color: MacosColors.systemRedColor,
          ),
        ),
      ],
    );
  }
}
