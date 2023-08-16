import 'dart:ffi';

import 'package:archiver_ffi/src/structs/common.dart';
import 'package:ffi/ffi.dart';

// ignore: avoid_positional_boolean_parameters
int toFfiBool(bool value) {
  return value ? 1 : 0;
}

Pointer<Char> toFfiString(String value, List<Pointer<NativeType>> ptrList) {
  final _value = value.toNativeUtf8();
  final _ptr = _value.cast<Char>();

  ptrList.add(_value);

  return _ptr;
}

int toFfiStringList(
  List<String> values,
  List<Pointer<NativeType>> ptrList,
) {
  final _ptr = StringListStruct.fromList(values, ptrList);

  return _ptr.address;
}

bool fromFfiBool(int value) {
  return value > 0;
}
