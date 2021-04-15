import 'package:flutter/material.dart';
import 'package:squash_archiver/common/di/di.dart';
import 'package:after_layout/after_layout.dart';
import 'package:squash_archiver/utils/alerts/alerts_model.dart';
import 'package:squash_archiver/utils/alerts/alerts.dart';
import 'package:squash_archiver/utils/log/log.dart';

abstract class SfWidget<S extends StatefulWidget> extends State<S>
    with AfterLayoutMixin<S> {
  final Alerts _alerts = getIt<Alerts>();

  @protected
  @override
  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onWidgetUpdate();
    });
  }

  @protected
  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    onInitApp();
  }

  @protected
  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }

  @protected
  @mustCallSuper
  void throwException(
    BuildContext context,
    Exception exception, {
    StackTrace? stackTrace,
  }) {
    _alerts.setException(
      context,
      exception,
      stackTrace: stackTrace,
    );
  }

  @protected
  @mustCallSuper
  void throwAlert(
    BuildContext context,
    String message, {
    String? title,
    AlertsTypes? type,
    AlertsPopupTypes? popupType,
    StackTrace? stackTrace,
    Duration? duration,
  }) {
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

  @protected
  @mustCallSuper
  void logError(
    dynamic message, {
    String? title,
    BuildContext? context,
    StackTrace? stackTrace,
    bool? reportCrash,
  }) {
    final _reportCrash = reportCrash ?? true;

    log.error(
      title: title,
      error: message,
      stackTrace: stackTrace,
      report: _reportCrash,
    );
  }

  void onInitApp() {}

  void onWidgetUpdate() {}
}
