import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:squash_archiver/common/di/di.dart' show getItInit;
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/features/app/ui/pages/app_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:squash_archiver/utils/log/log.dart';

Future<void> _logFlutterOnError(FlutterErrorDetails details) async {
  Zone.current.handleUncaughtError(details.exception, details.stack);

  Crashlytics.instance.recordFlutterError(details);

  log.error(
    title: 'A crash was captured by main._logFlutterOnError',
    error: details.exception,
    stackTrace: details.stack,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // register all dependecy injection
  await getItInit();

  Crashlytics.instance.enableInDevMode =
      env.config.enableCrashAnalyticsInDevMode;

  FlutterError.onError = _logFlutterOnError;

  HttpClient.enableTimelineLogging = env.config.enableHttpTimelineLogging;

  runZonedGuarded(() {
    runApp(AppScreen());
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    log.error(
      title: 'A crash was captured by main.runZonedGuarded',
      error: error,
      stackTrace: stackTrace,
    );
  });

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final errorAndStacktrace = pair as List;

    log.error(
      title: 'A crash was captured by main.Isolate.current.addErrorListener',
      error: errorAndStacktrace.first,
      stackTrace: errorAndStacktrace.last as StackTrace,
    );
  }).sendPort);
}
