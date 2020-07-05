import 'package:flutter/widgets.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry/sentry.dart';

@lazySingleton
class CrashesService {
  final SentryClient _sentry;

  CrashesService(this._sentry);

  void capture(
    dynamic exception,
    StackTrace stackTrace, {
    BuildContext context,
  }) {
    if (!env.config.reportCrashAnalytics) {
      return;
    }

    _sentry.captureException(
      exception: exception,
      stackTrace: stackTrace,
    );
  }
}
