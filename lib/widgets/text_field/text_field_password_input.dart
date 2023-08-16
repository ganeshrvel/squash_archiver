import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:squash_archiver/widget_extends/material.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';
import 'package:squash_archiver/widgets/text_field/text_field_password_input_store.dart';
import 'package:squash_archiver/widgets/text_field/text_field_regular_input.dart';

class TextFieldPasswordInput extends StatefulWidget {
  final ScrollController scrollController;
  final int? maxLength;
  final int? minLines;
  final int maxLines;
  final bool disabled;
  final bool autofocus;
  final bool enableShowPassword;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final String? placeholder;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;

  const TextFieldPasswordInput({
    required this.onChanged,
    required this.controller,
    required this.scrollController,
    this.onSubmitted,
    this.maxLength,
    this.disabled = false,
    this.errorText,
    this.placeholder,
    this.focusNode,
    this.autofocus = true,
    this.enableShowPassword = true,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
    super.key,
  });

  @override
  _TextFieldPasswordInputState createState() => _TextFieldPasswordInputState();
}

class _TextFieldPasswordInputState extends SfWidget<TextFieldPasswordInput> {
  late final TextFieldPasswordInputStore _textFieldPasswordInputStore =
      TextFieldPasswordInputStore(widget.enableShowPassword);

  late final FocusNode _thisFocusNode = FocusNode();

  FocusNode get _focusNode => widget.focusNode ?? _thisFocusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _thisFocusNode.dispose();

    super.dispose();
  }

  Widget? _togglePasswordVisibilityPlaceholderWidget() {
    return const SizedBox(
      height: 0,
      width: 22,
    );
  }

  Widget _togglePasswordVisibility(bool showPassword) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        focusColor: MacosColors.transparent,
        highlightColor: MacosColors.transparent,
        splashColor: MacosColors.transparent,
        onTap: () {
          _focusNode.unfocus();
          FocusScope.of(context).requestFocus(FocusNode());

          _textFieldPasswordInputStore.toggleEnableShowPassword();
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: MacosIcon(
            showPassword
                ? CupertinoIcons.eye_slash_fill
                : CupertinoIcons.eye_fill,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final _enableShowPassword =
            _textFieldPasswordInputStore.enableShowPassword;

        return Stack(
          children: [
            TextFieldRegularInput(
              controller: widget.controller,
              scrollController: widget.scrollController,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              suffix: _togglePasswordVisibilityPlaceholderWidget(),
              autofocus: widget.autofocus,
              disabled: widget.disabled,
              errorText: widget.errorText,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              minLines: widget.maxLines,
              placeholder: widget.placeholder,
              prefixIcon: widget.prefixIcon,
              autocorrect: false,
              enableSuggestions: false,
              obscureText: _enableShowPassword,
            ),
            _togglePasswordVisibility(_enableShowPassword),
          ],
        );
      },
    );
  }
}
