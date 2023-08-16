import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:squash_archiver/widget_extends/material.dart';

/// Get a random color
Color getRandomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

/// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
String colorToHex(Color color, {bool leadingHashSign = false}) {
  final r = color.red;
  final g = color.green;
  final b = color.blue;
  final a = color.alpha;

  return '${leadingHashSign ? '#' : ''}'
      '${a.toRadixString(16).padLeft(2, '0')}'
      '${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}

int colorToInt(String hexColor) {
  var _hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (_hexColor.length == 6) {
    _hexColor = 'FF$_hexColor';
  }

  return int.parse(_hexColor, radix: 16);
}
