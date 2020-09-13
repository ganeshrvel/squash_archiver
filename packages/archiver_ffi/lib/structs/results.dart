import 'dart:ffi';

import 'package:ffi/ffi.dart';

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
