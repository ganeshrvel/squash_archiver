import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// ignore: avoid_implementing_value_types
class KeyboardModifierIntent extends Intent implements Equatable {
  /// list of all currently pressed keyboard modifiers
  final List<LogicalKeyboardKey> keys;

  const KeyboardModifierIntent({
    this.keys = const [],
  }) : assert(keys != null);

  /// [bool] shift key pressed
  bool get isShiftPressed => keys.contains(LogicalKeyboardKey.shift);

  /// [bool] control key pressed
  bool get isControlPressed => keys.contains(LogicalKeyboardKey.control);

  /// [bool] meta key pressed
  bool get isMetaPressed => keys.contains(LogicalKeyboardKey.meta);

  /// [bool] alt key pressed
  bool get isAltPressed => keys.contains(LogicalKeyboardKey.alt);

  /// [DateTime] latest keymodifier pressed time
  DateTime get lastPressedTime => DateTime.now();

  @override
  List<Object> get props => [
        keys,
        isShiftPressed,
        isControlPressed,
        isMetaPressed,
        isAltPressed,
        lastPressedTime,
      ];

  @override
  bool get stringify => true;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '''
    keys: ${keys.toString()}
    isShiftPressed: ${isShiftPressed.toString()}
    isControlPressed: ${isControlPressed.toString()}
    isMetaPressed: ${isMetaPressed.toString()}
    isAltPressed: ${isAltPressed.toString()}
    lastPressedTime: ${lastPressedTime.toString()}
    ''';
  }
}
