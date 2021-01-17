import 'dart:ffi';

import 'package:ffi/ffi.dart';

class StringListStruct extends Struct {
  Pointer<Pointer<Utf8>> list;

  @Int64()
  int size;

  Pointer<StringListStruct> fromList(
    List<String> arr,
    List<Pointer<NativeType>> ptrList,
  ) {
    final pUtf = arr.map(Utf8.toUtf8).toList();

    // ignore: omit_local_variable_types
    final Pointer<Pointer<Utf8>> ppList = allocate(count: arr.length);

    for (var i = 0; i < arr.length; i++) {
      ppList[i] = pUtf[i];
    }

    ptrList.add(ppList);
    ptrList.addAll(pUtf);

    final pStrList = allocate<StringListStruct>().ref;
    pStrList.list = ppList;
    pStrList.size = arr.length;

    return pStrList.addressOf;
  }
}

class ResultErrorStruct extends Struct {
  Pointer<Utf8> errorType;
  Pointer<Utf8> error;

  factory ResultErrorStruct.allocate(
    Pointer<Utf8> error,
    Pointer<Utf8> errorType,
  ) =>
      allocate<ResultErrorStruct>().ref
        ..errorType = errorType
        ..error = error;
}
