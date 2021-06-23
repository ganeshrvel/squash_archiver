import 'dart:ffi';

import 'package:ffi/ffi.dart';

class StringListStruct extends Struct {
  Pointer<Pointer<Utf8>>? list;

  @Int64()
  int? size;

  Pointer<StringListStruct> fromList(
    List<String> arr,
    List<Pointer<NativeType>> ptrList,
  ) {
    final pUtf = arr.map((e) => e.toNativeUtf8()).toList();

    // ignore: omit_local_variable_types
    final Pointer<Pointer<Utf8>> ppList = malloc();

    for (var i = 0; i < arr.length; i++) {
      ppList[i] = pUtf[i];
    }

    ptrList.add(ppList);
    ptrList.addAll(pUtf);

    final pStrList = malloc<StringListStruct>();
    pStrList.ref.list = ppList;
    pStrList.ref.size = arr.length;

    ptrList.add(pStrList);

    return pStrList;
  }
}

class ResultErrorStruct extends Struct {
  external Pointer<Utf8> errorType;

  external Pointer<Utf8> error;

  factory ResultErrorStruct.allocate(
    Pointer<Utf8> error,
    Pointer<Utf8> errorType,
  ) =>
      malloc<ResultErrorStruct>().ref
        ..errorType = errorType
        ..error = error;
}
