import 'package:flutter/widgets.dart';

void setDefaultTextFieldValue(
  TextEditingController _controller,
  String value,
) {
  final _value = value;

  _controller.value = _controller.value.copyWith(
    text: _value,
    selection: TextSelection.fromPosition(
      TextPosition(
        offset: _value.length,
      ),
    ),
  );
}
