import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/common/exceptions/api_error_message_exceptions.dart';
import 'package:squash_archiver/common/exceptions/bad_network_exception.dart';
import 'package:squash_archiver/common/exceptions/cache_exception.dart';
import 'package:squash_archiver/common/exceptions/dio_exception.dart';
import 'package:squash_archiver/common/exceptions/internal_server_exception.dart';
import 'package:squash_archiver/common/exceptions/network_404_exception.dart';
import 'package:squash_archiver/common/exceptions/user_unauthenticated_exception.dart';
import 'package:squash_archiver/common/models/handle_exception_model.dart';
import 'package:squash_archiver/constants/errors.dart';
import 'package:squash_archiver/services/crashes_service.dart';
import 'package:squash_archiver/utils/log/log.dart';
import 'package:meta/meta.dart';

final _crashesService = getIt<CrashesService>();

HandleExceptionModel handleException(
  Exception exception, {
  @required bool allowLogging,
  @required StackTrace stackTrace,
}) {
  var _reportCrash = true;
  var _stackTrace = stackTrace;
  var _exception = exception;
  final _allowLogging = allowLogging ?? true;
  String _body;

  if (exception is Network404Exception) {
    _body = Errors.NETWORK_404_MESSAGE;
    _stackTrace = exception.stackTrace;
    _exception = exception;
  } else if (exception is BadNetworkException) {
    _body = Errors.BAD_NETWORK_MESSAGE;
    _stackTrace = exception.stackTrace;
    _exception = exception.error;

    _reportCrash = false;
  } else if (exception is UserUnauthenticatedException) {
    _body = Errors.INVALID_UNAUTHENTICATED_MESSAGE;

    _reportCrash = false;
  } else if (exception is DioException) {
    _body = Errors.DIO_EXCEPTION_MESSAGE;
    _stackTrace = exception.stackTrace;
    _exception = exception.error;
  } else if (exception is CacheException) {
    _body = Errors.CACHE_FAILURE_MESSAGE;
    _stackTrace = exception.stackTrace;
    _exception = exception.error;
  }
  if (exception is ApiErrorMessageException && exception.errorMessage != null) {
    _body = exception.errorMessage;
    _stackTrace = exception.stackTrace;
    _exception = exception;
  } else if (exception is InternalServerException) {
    _body = Errors.INTERNAL_SERVER_MESSAGE;
    _stackTrace = exception.stackTrace;
    _exception = exception.error;
  } else {
    _body = Errors.UNKNOWN_FAILURE_MESSAGE;
  }

  if (_allowLogging) {
    const _title = 'An exception was thrown';

    log.error(
      _title,
      error: _exception,
      stackTrace: stackTrace,
      report: _reportCrash,
    );
  }

  return HandleExceptionModel(
    body: _body,
    stackTrace: _stackTrace,
    exception: _exception,
  );
}
