import 'package:mobx/mobx.dart';

part 'text_field_password_input_store.g.dart';

class TextFieldPasswordInputStore = _TextFieldPasswordInputStoreBase
    with _$TextFieldPasswordInputStore;

abstract class _TextFieldPasswordInputStoreBase with Store {
  @observable
  late bool enableShowPassword = true;

  _TextFieldPasswordInputStoreBase(bool value) {
    enableShowPassword = value;
  }

  @action
  void setEnableShowPassword(bool value) {
    enableShowPassword = value;
  }

  @action
  void toggleEnableShowPassword() {
    enableShowPassword = !enableShowPassword;
  }
}
