import 'dart:ffi';

import 'package:archiver_ffi/src/structs/common.dart';
import 'package:ffi/ffi.dart';

class IsArchiveEncryptedResultStruct extends Struct {
  @Int8()
  external int isEncrypted;

  @Int8()
  external int isValidPassword;

  external Pointer<ResultErrorStruct> error;

  factory IsArchiveEncryptedResultStruct.allocate(
    int isEncrypted,
    int isValidPassword,
    Pointer<ResultErrorStruct> error,
  ) =>
      malloc<IsArchiveEncryptedResultStruct>().ref
        ..isEncrypted = isEncrypted
        ..isValidPassword = isValidPassword
        ..error = error;
}
