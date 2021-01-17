import 'dart:ffi';

import 'package:archiver_ffi/src/structs/common.dart';
import 'package:ffi/ffi.dart';

class IsArchiveEncryptedResultStruct extends Struct {
  @Int8()
  int isEncrypted;

  @Int8()
  int isValidPassword;

  Pointer<ResultErrorStruct> error;

  factory IsArchiveEncryptedResultStruct.allocate(
    int isEncrypted,
    int isValidPassword,
    Pointer<ResultErrorStruct> error,
  ) =>
      allocate<IsArchiveEncryptedResultStruct>().ref
        ..isEncrypted = isEncrypted
        ..isValidPassword = isValidPassword
        ..error = error;
}
