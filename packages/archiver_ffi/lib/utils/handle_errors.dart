import 'dart:ffi';

import 'package:archiver_ffi/exceptions/archiver_exception.dart';
import 'package:archiver_ffi/exceptions/file_not_found_exception.dart';
import 'package:archiver_ffi/exceptions/file_not_found_to_pack_exception.dart';
import 'package:archiver_ffi/exceptions/file_unsupported_file_format_exception.dart';
import 'package:archiver_ffi/exceptions/filter_path_not_found_exception.dart';
import 'package:archiver_ffi/exceptions/invalid_password_exception.dart';
import 'package:archiver_ffi/exceptions/operation_not_permitted_exception.dart';
import 'package:archiver_ffi/structs/common.dart';
import 'package:data_channel/data_channel.dart';

DC<ArchiverException, T> handleError<T>(Pointer<ResultErrorStruct> errorPtr, {T data}) {
  ArchiverException _exception;

  final error = errorPtr.ref.error.ref.toString();
  final errorType = errorPtr.ref.errorType.ref.toString();

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

  return DC(error: _exception, data: data);
}
