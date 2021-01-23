import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/helpers/file_explorer_key_modifiers_helper.dart';
import 'package:squash_archiver/common/models/key_modifier.dart';
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
  ///  /// todo write tests
  @computed
  bool get isSelectAllPressed {
    final _keyModifier =
        getKeyModifierFromKeys(activeKeyboardModifierIntent?.keys);

    return _keyModifier.actionType == KeyModifierActionType.SELECT_ALL;
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
