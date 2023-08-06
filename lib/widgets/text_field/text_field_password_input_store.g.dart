// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_field_password_input_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TextFieldPasswordInputStore on _TextFieldPasswordInputStoreBase, Store {
  late final _$enableShowPasswordAtom = Atom(
      name: '_TextFieldPasswordInputStoreBase.enableShowPassword',
      context: context);

  @override
  bool get enableShowPassword {
    _$enableShowPasswordAtom.reportRead();
    return super.enableShowPassword;
  }

  @override
  set enableShowPassword(bool value) {
    _$enableShowPasswordAtom.reportWrite(value, super.enableShowPassword, () {
      super.enableShowPassword = value;
    });
  }

  late final _$_TextFieldPasswordInputStoreBaseActionController =
      ActionController(
          name: '_TextFieldPasswordInputStoreBase', context: context);

  @override
  void setEnableShowPassword(bool value) {
    final _$actionInfo =
        _$_TextFieldPasswordInputStoreBaseActionController.startAction(
            name: '_TextFieldPasswordInputStoreBase.setEnableShowPassword');
    try {
      return super.setEnableShowPassword(value);
    } finally {
      _$_TextFieldPasswordInputStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void toggleEnableShowPassword() {
    final _$actionInfo =
        _$_TextFieldPasswordInputStoreBaseActionController.startAction(
            name: '_TextFieldPasswordInputStoreBase.toggleEnableShowPassword');
    try {
      return super.toggleEnableShowPassword();
    } finally {
      _$_TextFieldPasswordInputStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
enableShowPassword: ${enableShowPassword}
    ''';
  }
}
