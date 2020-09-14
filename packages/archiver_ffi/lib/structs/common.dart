import 'dart:ffi';

import 'package:ffi/ffi.dart';

class StringList extends Struct {
  Pointer<Pointer<Utf8>> list;

  @Int64()
  int size;

  Pointer<StringList> fromList(List<String> arr) {
    final utfPtrs = arr.map(Utf8.toUtf8).toList();

    // ignore: omit_local_variable_types
    final Pointer<Pointer<Utf8>> list = allocate(count: arr.length);

    for (var i = 0; i < arr.length; i++) {
      list[i] = utfPtrs[i];
    }

    final pStrList = allocate<StringList>().ref;
    pStrList.list = list;
    pStrList.size = arr.length;

    return pStrList.addressOf;
  }
}

class ResultErrors extends Struct {
  Pointer<Utf8> error;

  Pointer<Utf8> errorType;

  factory ResultErrors.allocate(
    Pointer<Utf8> error,
    Pointer<Utf8> errorType,
  ) =>
      allocate<ResultErrors>().ref
        ..error = error
        ..errorType = errorType;
}
