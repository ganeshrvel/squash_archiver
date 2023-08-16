import 'package:flutter/services.dart';

class KeyboardActivators {
  static bool isKeyPressed(List<LogicalKeyboardKey> keyList) {
    return RawKeyboard.instance.keysPressed.any((key) => keyList.contains(key));
  }

  static bool isShiftPressed() => isKeyPressed([
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.shiftRight,
      ]);

  static bool isMetaPressed() => isKeyPressed([
        LogicalKeyboardKey.metaLeft,
        LogicalKeyboardKey.metaRight,
      ]);

  static bool isCtrlPressed() => isKeyPressed([
        LogicalKeyboardKey.controlLeft,
        LogicalKeyboardKey.controlRight,
      ]);

  static bool isAltPressed() => isKeyPressed([
        LogicalKeyboardKey.altLeft,
        LogicalKeyboardKey.altRight,
      ]);
}
