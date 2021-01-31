import 'package:flutter/material.dart';
import 'package:squash_archiver/common/themes/colors.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

class TextFieldRegularInput extends StatelessWidget {
  final int maxLength;
  final int minLines;
  final int maxLines;
  final bool disabled;
  final bool autofocus;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String errorText;
  final String hintText;
  final String labelText;
  final String prefixText;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const TextFieldRegularInput({
    Key key,
    @required this.onChanged,
    @required this.controller,
    this.maxLength,
    this.disabled = false,
    this.errorText,
    this.hintText,
    this.prefixText,
    this.labelText,
    this.autofocus = false,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
  })  : assert(controller != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        prefixText: prefixText,
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(
          fontSize: 16.0,
        ),
        prefixStyle: const TextStyle(
          fontSize: 16.0,
        ),
        labelStyle: const TextStyle(
          fontSize: 16.0,
        ),
        errorStyle: const TextStyle(
          fontSize: 13.0,
        ),
        prefixIcon: isNotNull(prefixIcon)
            ? Icon(
                prefixIcon,
                color: AppColors.color232526,
                size: 20,
              )
            : null,
        fillColor: AppColors.white,
        counterText: '',
        errorText: errorText,
      ),
      autofocus: autofocus,
      controller: controller,
      onChanged: (String value) {
        if (isNotNull(maxLength) && value.length > maxLength) {
          return;
        }

        if (isNotNull(onChanged)) {
          onChanged(value);
        }
      },
      enabled: !disabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
    );
  }
}
