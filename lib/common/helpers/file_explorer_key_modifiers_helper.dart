import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/models/key_modifier.dart';
import 'package:squash_archiver/features/app/data/models/keyboard_modifier_intent.dart';
import 'package:squash_archiver/utils/utils/functs.dart';

/// the key modifiers mapping
const KeyModifiersMapping = <KeyModifierActionType, KeyModifier>{
  KeyModifierActionType.ALT: KeyModifier(
    actionType: KeyModifierActionType.ALT,
    keys: [
      LogicalKeyboardKey.alt,
    ],
    label: 'Alt',
  ),
  KeyModifierActionType.SHIFT: KeyModifier(
    actionType: KeyModifierActionType.SHIFT,
    keys: [
      LogicalKeyboardKey.shift,
    ],
    label: 'Shift',
  ),
  KeyModifierActionType.CONTROL: KeyModifier(
    actionType: KeyModifierActionType.CONTROL,
    keys: [
      LogicalKeyboardKey.control,
    ],
    label: 'Control',
  ),
  KeyModifierActionType.META: KeyModifier(
    actionType: KeyModifierActionType.META,
    keys: [
      LogicalKeyboardKey.meta,
    ],
    label: 'Command',
  ),
  KeyModifierActionType.SELECT_ALL: KeyModifier(
    actionType: KeyModifierActionType.SELECT_ALL,
    keys: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyA,
    ],
    label: 'Select All',
  ),
};

/// Returns the key modifiers shortcut
/// This is used by the [Shortcut] widget to map the keyboard actions
Map<LogicalKeySet, Intent> getKeyModifiersShortcut() {
  final _keyMaps = <LogicalKeySet, Intent>{};

  for (final keyMap in KeyModifiersMapping.values) {
    if (keyMap.keys.isEmpty) {
      continue;
    }

    if (keyMap.keys.length == 1) {
      _keyMaps.putIfAbsent(
        LogicalKeySet(keyMap.keys[0]),
        () => KeyboardModifierIntent(
          keys: keyMap.keys,
        ),
      );
    } else if (keyMap.keys.length == 2) {
      _keyMaps.putIfAbsent(
        LogicalKeySet(keyMap.keys[0], keyMap.keys[1]),
        () => KeyboardModifierIntent(
          keys: keyMap.keys,
        ),
      );
    } else if (keyMap.keys.length == 3) {
      _keyMaps.putIfAbsent(
        LogicalKeySet(keyMap.keys[0], keyMap.keys[1], keyMap.keys[2]),
        () => KeyboardModifierIntent(
          keys: keyMap.keys,
        ),
      );
    } else if (keyMap.keys.length == 4) {
      _keyMaps.putIfAbsent(
        LogicalKeySet(
            keyMap.keys[0], keyMap.keys[1], keyMap.keys[2], keyMap.keys[3]),
        () => KeyboardModifierIntent(
          keys: keyMap.keys,
        ),
      );
    }
  }

  return _keyMaps;
}

/// returns the [KeyModifier] of the input key combination
KeyModifier? getKeyModifierFromKeys(
  List<LogicalKeyboardKey> keys,
) {
  final _deepEq = const DeepCollectionEquality().equals;

  for (final keyModifier in KeyModifiersMapping.values) {
    if (_deepEq(keyModifier.keys, keys)) {
      return keyModifier;
    }
  }

  return null;
}

/// returns [true] if the [keys] matches the [KeyModifierActionType]
bool isKeyModifierMatching({
  required List<LogicalKeyboardKey>? keys,
  required KeyModifierActionType actionType,
}) {
  if (isNull(KeyModifiersMapping[actionType])) {
    throw "Invalid 'actionType' argument in isKeyModifier";
  }

  final _deepEq = const DeepCollectionEquality().equals;
  final _keyMap = KeyModifiersMapping[actionType]!;

  return _deepEq(_keyMap.keys, keys);
}
