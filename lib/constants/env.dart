import 'package:flutter/foundation.dart' as foundation;
import 'package:squash_archiver/common/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

@lazySingleton
class Env {
  final bool IS_RELEASE = foundation.kReleaseMode;

  final bool IS_DEBUG = !foundation.kReleaseMode;

  _EnvData get config => IS_RELEASE ? prod : dev;

  final _EnvData dev = _EnvData(
    debugShowCheckedModeBanner: false,
    debugShowMaterialGrid: false,
    logApiClient: true,
    apiBaseUrl: null,
    reportCrashAnalytics: false,
    enableHttpTimelineLogging: false,
    showDebugLogs: true,
  );

  final _EnvData prod = _EnvData(
    debugShowCheckedModeBanner: false,
    debugShowMaterialGrid: false,
    logApiClient: false,
    apiBaseUrl: null,
    reportCrashAnalytics: true,
    enableHttpTimelineLogging: true,
    showDebugLogs: false,
  );
}

class _EnvData {
  final String apiBaseUrl;
  final bool debugShowCheckedModeBanner;
  final bool debugShowMaterialGrid;
  final bool logApiClient;
  final bool reportCrashAnalytics;
  final bool enableHttpTimelineLogging;
  final bool showDebugLogs;

  _EnvData({
    @required this.debugShowCheckedModeBanner,
    @required this.debugShowMaterialGrid,
    @required this.logApiClient,
    @required this.apiBaseUrl,
    @required this.reportCrashAnalytics,
    @required this.enableHttpTimelineLogging,
    @required this.showDebugLogs,
  });
}

final Env env = getIt<Env>();