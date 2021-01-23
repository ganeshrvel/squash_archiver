import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import 'package:mobx/mobx.dart';
import 'package:squash_archiver/features/app/data/models/keyboard_modifier_intent.dart';

part 'file_explorer_keyboard_modifiers_store.g.dart';

class FileExplorerKeyboardModifiersStore = _FileExplorerKeyboardModifiersStoreBase
    with _$FileExplorerKeyboardModifiersStore;

abstract class _FileExplorerKeyboardModifiersStoreBase with Store {
  ///todo move [activeKeyboardModifierIntent] into a different store
  /// keyboard events
  @observable
  KeyboardModifierIntent activeKeyboardModifierIntent;

  /// returns [true] if meta+a is pressed in the keyboard
  @computed
  bool get isSelectAllPressed {
    final deepEq = const DeepCollectionEquality().equals;

    return deepEq(activeKeyboardModifierIntent?.keys ?? [], [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyA,
    ]);
  }

  /// todo write tests
  @action
  void setActiveKeyboardModifierIntent(KeyboardModifierIntent intent) {
    activeKeyboardModifierIntent = intent;
  }

  /// todo write tests
  @action
  void resetActiveKeyboardModifierIntent() {
    activeKeyboardModifierIntent = null;
  }
}
