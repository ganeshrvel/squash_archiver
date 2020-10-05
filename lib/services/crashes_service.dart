import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry/sentry.dart';
import 'package:squash_archiver/utils/utils/error.dart';

@lazySingleton
class CrashesService {
  final SentryClient _sentry;

  CrashesService(this._sentry);

  void capture({
    @required String title,
    @required dynamic error,
    @required StackTrace stackTrace,
    @required StackTrace fullStackTrace,
    BuildContext context,
  }) {
    if (!env.config.reportCrashAnalytics) {
      return;
    }

    final _errorBody = getErrorBody({
      'Title': title,
      'Error': error.toString(),
      'StackTrace': stackTrace.toString(),
    });

    _sentry.captureException(
      exception: _errorBody,
      stackTrace: stackTrace,
    );

    Crashlytics.instance.recordError(
      _errorBody,
      stackTrace,
      context: context,
    );
  }
}
