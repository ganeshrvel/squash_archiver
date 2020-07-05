import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/services/crashes_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:squash_archiver/common/di/di.dart';

@lazySingleton
class Log {
  final Logger _logger;
  final CrashesService _crashesService;

  Log(this._logger, this._crashesService);

  void _doReport(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    final _doReport = report ?? true;

    if (!_doReport) {
      return;
    }

    _crashesService.capture(error, stackTrace);
  }

  /// Log a message at level [Level.verbose].
  void verbose(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    _doReport(
      message,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.v(message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  void debug(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    _doReport(
      message,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.d(message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void info(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    _doReport(
      message,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.i(message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void warn(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    _doReport(
      message,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.w(message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void error(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    _doReport(
      message,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.e(message, error, stackTrace);
  }

  /// Log a message at level [Level.wtf].
  void wtf(
    dynamic message, {
    dynamic error,
    StackTrace stackTrace,
    bool report,
  }) {
    _doReport(
      message,
      error: error,
      stackTrace: stackTrace,
      report: report,
    );

    if (!env.config.showDebugLogs) {
      return;
    }

    _logger.wtf(message, error, stackTrace);
  }
}

final Log log = getIt<Log>();
