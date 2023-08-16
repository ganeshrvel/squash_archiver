import 'dart:ffi';

import 'package:archiver_ffi/src/exceptions/exceptions.dart';
import 'package:archiver_ffi/src/structs/common.dart';
import 'package:data_channel/data_channel.dart';
import 'package:ffi/ffi.dart';

DC<ArchiverException, T> handleError<T>(Pointer<ResultErrorStruct> errorPtr,
    {T? data}) {
  ArchiverException _exception;

  try {
    final error = errorPtr.ref.error.toDartString();
    final errorType = errorPtr.ref.errorType.toDartString();

    switch (errorType) {
      case 'ErrorFileNotFound':
        _exception = FileNotFoundException(error);

        break;
      case 'ErrorFileNotFoundToPack':
        _exception = FileNotFoundToPackException(error);

        break;
      case 'ErrorFilterPathNotFound':
        _exception = FilterPathNotFoundException(error);

        break;
      case 'ErrorUnsupportedFileFormat':
        _exception = UnsupportedFileFormatException(error);

        break;
      case 'ErrorPasswordRequired':
        _exception = PasswordRequiredException(error);

        break;
      case 'ErrorInvalidPassword':
        _exception = InvalidPasswordException(error);

        break;
      case 'ErrorOperationNotPermitted':
        _exception = OperationNotPermittedException(error);

        break;
      case 'ErrorOthers':
      default:
        _exception = ArchiverException(error);

        break;
    }
  } catch (e) {
    _exception = FfiException(e.toString());
  }

  return DC(error: _exception, data: data);
}
