import 'package:flutter/widgets.dart';
import 'package:squash_archiver/utils/utils/colors.dart';

class HexColor extends Color {
  HexColor(String hexColor) : super(colorToInt(hexColor));
}
