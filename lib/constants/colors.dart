import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:squash_archiver/common/themes/hex_color.dart';

class AppColors {
  AppColors._();

  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static final Color blue = HexColor('017AFF');
  static final Color darkBlue = HexColor('2365d8');
  static final Color black = HexColor('232526');

  //// todo remove these 3 dep.
  static final Color disabled = Colors.black.withOpacity(0.2);
  static final Color splash = Colors.black.withOpacity(0.02);
  static final Color hover = Colors.black.withOpacity(0.05);

  static final Color error = HexColor('F96057');
  static final Color warn = HexColor('F8A34D');
  static final Color info = HexColor('488EF7');
  static final Color success = HexColor('5FCF65');
  static final Color colorF5F = HexColor('F5F5F5');
  static final Color colorE6E3E3 = HexColor('E6E3E3');
  static final Color colorE5E = HexColor('E5E5E5');
  static final Color color797 = HexColor('797979');
  static final Color colorF1F = HexColor('F1F1F1');
}
