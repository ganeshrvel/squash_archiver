import 'package:archiver_ffi/exceptions/common_exception.dart';
import 'package:archiver_ffi/exceptions/file_not_found_exception.dart';
import 'package:archiver_ffi/exceptions/filter_path_not_found_exception.dart';
import 'package:data_channel/data_channel.dart';
import 'package:meta/meta.dart';

DC<Exception, T> handleError<T>({
  @required String errorType,
  @required String error,
}) {
  Exception _exception;

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

  return DC.error(_exception);
}
