import 'dart:ffi';

import 'package:archiver_ffi/structs/common.dart';
import 'package:ffi/ffi.dart';

int ffiBool(bool value) {
  return value ? 1 : 0;
}

Pointer<Int8> ffiString(String value, List<Pointer<NativeType>> ptrList) {
  final _value = Utf8.toUtf8(value);
  final _ptr = _value.cast<Int8>();

  ptrList.add(_ptr);

  return _ptr;
}

Pointer<StringList> ffiStringList(
    List<String> values, List<Pointer<NativeType>> ptrList) {
  final pStrList = allocate<StringList>().ref;
  final _ptr = pStrList.fromList(values, ptrList);

  ptrList.add(_ptr);

  return _ptr;
}
