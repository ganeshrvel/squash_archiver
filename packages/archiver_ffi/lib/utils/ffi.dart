import 'dart:ffi';

import 'package:ffi/ffi.dart';

int ffiBool(bool value) {
  return value ? 1 : 0;
}

Pointer<Int8> ffiString(String value, List<Pointer<Int8>> ptrList) {
  final _value = Utf8.toUtf8(value);
  final _ptr = _value.cast<Int8>();

  ptrList.add(_ptr);

  return _ptr;
}
