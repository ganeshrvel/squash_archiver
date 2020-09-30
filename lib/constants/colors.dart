import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:squash_archiver/common/themes/hex_color.dart';

class AppColors {
  AppColors._();

  static const Color white = Colors.white;
  static final Color blue = HexColor('2262c6');
  static final Color black = HexColor('000000');
  static final Color disabled = HexColor('CBCBCB');
  static final Color splash = Colors.white10;
  static final Color error = Colors.red.shade500;
  static final Color warn = Colors.orange.shade500;
  static final Color info = Colors.blue.shade500;
  static final Color success = Colors.green.shade500;
  static final Color colorF1F = HexColor('F1F1F1');
}
