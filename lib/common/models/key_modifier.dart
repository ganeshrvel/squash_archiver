import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

/// Key modifier action type enum
enum KeyModifierActionType {
  /// select all activated
  SELECT_ALL,

  /// just the shift key is activated
  SHIFT,

  /// just the meta key is activated
  META,

  /// just the alt key is activated
  ALT,

  /// just the control key is activated
  CONTROL,
}

/// Key modifier model
class KeyModifier extends Equatable {
  /// list of keys
  final List<LogicalKeyboardKey> keys;

  /// [KeyModifierActionType] enums
  final KeyModifierActionType actionType;

  /// label for the key modifier
  final String label;

  const KeyModifier({
    required this.keys,
    required this.actionType,
    required this.label,
  });

  @override
  List<Object> get props => [
        keys,
        actionType,
        label,
      ];
}
