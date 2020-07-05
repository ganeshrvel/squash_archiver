import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/themes/theme_helper.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(colorToInt(hexColor));
}
