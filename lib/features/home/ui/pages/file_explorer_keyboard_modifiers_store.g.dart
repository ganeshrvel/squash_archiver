// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_explorer_keyboard_modifiers_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileExplorerKeyboardModifiersStore
    on _FileExplorerKeyboardModifiersStoreBase, Store {
  Computed<bool>? _$isSelectAllPressedComputed;

  @override
  bool get isSelectAllPressed => (_$isSelectAllPressedComputed ??=
          Computed<bool>(() => super.isSelectAllPressed,
              name:
                  '_FileExplorerKeyboardModifiersStoreBase.isSelectAllPressed'))
      .value;

  final _$activeKeyboardModifierIntentAtom = Atom(
      name:
          '_FileExplorerKeyboardModifiersStoreBase.activeKeyboardModifierIntent');

  @override
  KeyboardModifierIntent get activeKeyboardModifierIntent {
    _$activeKeyboardModifierIntentAtom.reportRead();
    return super.activeKeyboardModifierIntent;
  }

  @override
  set activeKeyboardModifierIntent(KeyboardModifierIntent value) {
    _$activeKeyboardModifierIntentAtom
        .reportWrite(value, super.activeKeyboardModifierIntent, () {
      super.activeKeyboardModifierIntent = value;
    });
  }

  final _$_FileExplorerKeyboardModifiersStoreBaseActionController =
      ActionController(name: '_FileExplorerKeyboardModifiersStoreBase');

  @override
  void setActiveKeyboardModifierIntent(KeyboardModifierIntent intent) {
    final _$actionInfo =
        _$_FileExplorerKeyboardModifiersStoreBaseActionController.startAction(
            name:
                '_FileExplorerKeyboardModifiersStoreBase.setActiveKeyboardModifierIntent');
    try {
      return super.setActiveKeyboardModifierIntent(intent);
    } finally {
      _$_FileExplorerKeyboardModifiersStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void resetActiveKeyboardModifierIntent() {
    final _$actionInfo =
        _$_FileExplorerKeyboardModifiersStoreBaseActionController.startAction(
            name:
                '_FileExplorerKeyboardModifiersStoreBase.resetActiveKeyboardModifierIntent');
    try {
      return super.resetActiveKeyboardModifierIntent();
    } finally {
      _$_FileExplorerKeyboardModifiersStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
activeKeyboardModifierIntent: ${activeKeyboardModifierIntent},
isSelectAllPressed: ${isSelectAllPressed}
    ''';
  }
}
