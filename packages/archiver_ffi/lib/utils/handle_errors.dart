import 'dart:ffi';

import 'package:archiver_ffi/exceptions/common_exception.dart';
import 'package:archiver_ffi/exceptions/file_not_found_exception.dart';
import 'package:archiver_ffi/exceptions/filter_path_not_found_exception.dart';
import 'package:archiver_ffi/structs/common.dart';
import 'package:data_channel/data_channel.dart';

DC<Exception, T> handleError<T>(Pointer<ResultErrorStruct> errorPtr, {T data}) {
  Exception _exception;

  final error = errorPtr.ref.error.ref.toString();
  final errorType = errorPtr.ref.errorType.ref.toString();

  switch (errorType) {
    case 'ErrorFileNotFound':
      _exception = FileNotFoundException(error);

      break;
    case 'ErrorFilterPathNotFound':
      _exception = FilterPathNotFoundException(error);

      break;
    case 'ErrorOthers':
    default:
      _exception = CommonException(error);

      break;
  }

  return DC(error: _exception, data: data);
}
