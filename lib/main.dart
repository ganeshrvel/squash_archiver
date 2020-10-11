import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart' show getItInit;
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/features/app/ui/pages/app_screen.dart';
import 'package:squash_archiver/utils/log/log.dart';

Future<void> _logFlutterOnError(FlutterErrorDetails details) async {
  Zone.current.handleUncaughtError(details.exception, details.stack);

  // todo add firebase
  // FirebaseCrashlytics.instance.recordFlutterError(details);

  log.error(
    title: 'A crash was captured by main._logFlutterOnError',
    error: details.exception,
    stackTrace: details.stack,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // register all dependecy injection
  await getItInit(Environment.dev);

  // todo add firebase
  // await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
  //   env.config.enableCrashAnalyticsInDevMode,
  // );

  FlutterError.onError = _logFlutterOnError;

  HttpClient.enableTimelineLogging = env.config.enableHttpTimelineLogging;

  runZonedGuarded(() {
    runApp(
      AppScreen(),
    );
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    log.error(
      title: 'A crash was captured by main.runZonedGuarded',
      error: error,
      stackTrace: stackTrace,
    );
  });

  mainContext.onReactionError((_, rxn) {
    log.error(
      title: 'A mobx reaction error occured.',
      error: rxn.errorValue.exception,
      stackTrace: rxn.errorValue.stackTrace,
    );
  });

  runZonedGuarded(() {
    runApp(AppScreen());
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    log.error(
      title:
          'A Flutter crash occured and it was captured by main.runZonedGuarded',
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
