import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:squash_archiver/services/crashes_service.dart';
import 'package:squash_archiver/utils/alerts/alerts_model.dart';
import 'package:squash_archiver/utils/error_handling/handle_exception.dart';
import 'package:squash_archiver/utils/log/log.dart';

@LazySingleton()
class AlertsHelper {
  final CrashesService crashesService;

  AlertsHelper(this.crashesService);

  AlertsModel getAlert(
    BuildContext context,
    String? body, {
    Exception? exception,
    String? title,
    AlertsTypes? type,
    AlertsPopupTypes? popupType,
    StackTrace? stackTrace,
    Duration? duration,
    bool? allowLogging,
  }) {
    String _title;
    final _type = type ?? AlertsTypes.ERROR;
    final _popupType = popupType ?? AlertsPopupTypes.FLUSHBAR;
    final _exception = exception ?? body;
    final _allowLogging = allowLogging ?? true;

    switch (_type) {
      case AlertsTypes.INFO:
        _title = 'Info!';

        if (_allowLogging) {
          log.info(title: _title, error: _exception, stackTrace: stackTrace);
        }
        break;

      case AlertsTypes.WARNING:
        _title = 'Warning!';

        if (_allowLogging) {
          log.warn(title: _title, error: _exception, stackTrace: stackTrace);
        }
        break;

      case AlertsTypes.SUCCESS:
        _title = 'Great!';
        break;

      case AlertsTypes.ERROR:
      default:
        _title = 'Oops... Some error occured!';

        if (_allowLogging) {
          log.error(title: _title, error: _exception, stackTrace: stackTrace);
        }
        break;
    }

    return AlertsModel(
      context: context,
      body: body,
      title: _title,
      type: type,
      popupType: _popupType,
      duration: duration,
    );
  }

  AlertsModel getException(
    BuildContext context,
    Exception exception, {
    required StackTrace? stackTrace,
  }) {
    ///
    ///   todo Implement UserUnauthenticatedException redirect logic
    ///   if (exception is UserUnauthenticatedException) {
    ///      navigateToLogin(context, routeArgs: LoginScreenArguments());
    ///   }

    final exceptionData = handleException(
      exception,
      stackTrace: stackTrace,
      allowLogging: false,
    );

    return getAlert(
      context,
      exceptionData.body,
      exception: exceptionData.exception,
      stackTrace: exceptionData.stackTrace,
      allowLogging: false,
    );
  }
}
