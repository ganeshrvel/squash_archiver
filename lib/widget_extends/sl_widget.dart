import 'package:flutter/widgets.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/utils/alerts/alerts_model.dart';
import 'package:squash_archiver/utils/alerts/alerts.dart';

abstract class SlWidget<S extends StatelessWidget> {
  Alerts get _alerts => getIt<Alerts>();

  @protected
  @mustCallSuper
  void throwException(
    BuildContext context,
    Exception exception, {
    StackTrace stackTrace,
  }) =>
      _alerts.setException(
        context,
        exception,
        stackTrace: stackTrace,
      );

  @protected
  @mustCallSuper
  void throwAlert(
    BuildContext context,
    String message, {
    String title,
    AlertsTypes type,
    AlertsPopupTypes popupType,
    StackTrace stackTrace,
    Duration duration,
  }) =>
      _alerts.setAlert(
        context,
        message,
        title: title,
        type: type,
        stackTrace: stackTrace,
        popupType: popupType,
        duration: duration,
      );
}
