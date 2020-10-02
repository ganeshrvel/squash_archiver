import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomColors() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}
