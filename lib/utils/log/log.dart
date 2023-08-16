import 'package:flutter/foundation.dart' show debugPrint;
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'package:squash_archiver/common/di/di.dart';
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/services/crashes_service.dart';

@LazySingleton()
class Log {
  final Logger _logger;
  final CrashesService _crashesService;

  Log(this._logger, this._crashesService);

  void _doReport({
    String? title,
    dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    final _doReport = report ?? true;

    if (!_doReport) {
      return;
    }

    _crashesService.capture(
      title: title,
      error: error,
      stackTrace: stackTrace,
      fullStackTrace: StackTrace.current,
    );
  }

  /// Log a message at level [Level.verbose].
  void verbose({
    String? title,
    dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    _doReport(
      title: title,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.v(title, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  void debug({
    String? title,
    dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    _doReport(
      title: title,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.d(title, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void info({
    String? title,
    dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    _doReport(
      title: title,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.i(title, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void warn({
    String? title,
    dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    _doReport(
      title: title,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.w(title, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void error({
    required String? title,
    required dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    _doReport(
      title: title,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.e(title, error, stackTrace);
  }

  /// Log a message at level [Level.wtf].
  void wtf({
    required String title,
    dynamic error,
    StackTrace? stackTrace,
    bool? report,
  }) {
    _doReport(
      title: title,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.wtf(title, error, stackTrace);
  }

  /// Log a message at level [debugPrint].
  void print(String title, String message) {
    if (!env.config.showDebugLogs) {
      return;
    }

    debugPrint('━━━━ $title => $message ━━━━');
  }
}

final Log log = getIt<Log>();
