import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:squash_archiver/common/themes/hex_color.dart';

class AppColors {
  AppColors._();

  static const Color transparent = Colors.transparent;

  /// primary color in light theme mode
  /// primarily used for light theme scaffold background
  static const Color white = Colors.white;

  /// primary color in dark theme mode
  /// black shade, primarily used for dark theme scaffold background
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/242024)
  static final Color color242024 = HexColor('242024');

  /// primary and accent color
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/017AFF)
  static final Color blue = HexColor('017AFF');

  /// second shade of blue
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/2365D8)
  static final Color darkBlue = HexColor('2365D8');

  /// black shade, primarily used for text
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/232526)
  static final Color color232526 = HexColor('232526');

  static final Color lightDisabled = Colors.black.withOpacity(0.2);
  static final Color darkDisabled = Colors.white.withOpacity(0.2);

  static final Color lightSplash = Colors.black.withOpacity(0.02);
  static final Color darkSplash = Colors.white.withOpacity(0.02);

  static final Color lightHover = Colors.black.withOpacity(0.05);
  static final Color darkHover = Colors.white.withOpacity(0.05);

  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/F96057)
  static final Color error = HexColor('F96057');

  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/F8A34D)
  static final Color warn = HexColor('F8A34D');

  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/488EF7)
  static final Color info = HexColor('488EF7');

  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/5FCF65)
  static final Color success = HexColor('5FCF65');

  /// brighter shade of white
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/F1F1F1)
  static final Color colorF1F = HexColor('F1F1F1');

  /// dim white shade 1
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/F5F5F5)
  static final Color colorF5F = HexColor('F5F5F5');

  /// pink shade
  /// used for sidebar and cells separator
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/E6E3E3)
  static final Color colorE6E3E3 = HexColor('E6E3E3');

  /// secondary dark shade
  /// used for sidebar and cells separator
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/252125)
  static final Color color252125 = HexColor('252125');

  /// light gray shade 1
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/E5E5E5)
  static final Color colorE5E = HexColor('E5E5E5');

  /// light black shade 1
  /// Used for captions, overlays
  ///
  /// [Open color-hex.com](https://www.color-hex.com/color/797979)
  static final Color color797 = HexColor('797979');
}
