import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mobx/mobx.dart';
import 'package:squash_archiver/common/di/di.dart' show getIt, getItInit;
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/features/app/ui/pages/app_screen.dart';
import 'package:squash_archiver/features/app/ui/store/app_store.dart';
import 'package:squash_archiver/utils/device_details/app_meta_info.dart';
import 'package:squash_archiver/utils/log/log.dart';

GetIt? getItRegister;

Future<void> _logFlutterOnError(FlutterErrorDetails details) async {
  Zone.current.handleUncaughtError(
    details.exception,
    details.stack ?? StackTrace.empty,
  );

  // todo add firebase
  // FirebaseCrashlytics.instance.recordFlutterError(details);

  log.error(
    title: 'An error was captured by main._logFlutterOnError',
    error: details.exception,
    stackTrace: details.stack,
  );
}

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  final config = MacosWindowUtilsConfig(
    onWindowDidBecomeMain: () {
      if (getItRegister == null) {
        return;
      }

      final _appStore = getIt<AppStore>();

      _appStore.setWindowState(WindowState.Focused);
    },
    onWindowDidResignMain: () {
      if (getItRegister == null) {
        return;
      }

      final _appStore = getIt<AppStore>();

      _appStore.setWindowState(WindowState.Blurred);
    },
  );
  await config.apply();
}

Future<void> main() async {
  // no need of WidgetsFlutterBinding.ensureInitialized(); here since MacosWindowUtilsConfig already takes care of it
  //WidgetsFlutterBinding.ensureInitialized();

  //todo new builder.yaml
  //todo add sentry
  // await SentryFlutter.init(
  //   (options) {
  //     options
  //       ..dsn = ServiceKeys.SENTRY_DSN
  //       ..environment = enumToString(env.config.environment)
  //       ..release = _appMetaInfo.release
  //       ..attachStacktrace = true
  //       ..useNativeBreadcrumbTracking();
  //   },
  // );

  // todo add firebase
  // await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
  //   env.config.enableCrashAnalyticsInDevMode,
  // );

  // runZonedGuarded(() {
  //   runApp(
  //     AppScreen(),
  //   );
  // }, (Object error, StackTrace stackTrace) {
  //   // Whenever an error occurs, call the `_reportError` function. This sends
  //   // Dart errors to the dev console or Sentry depending on the environment.
  //   log.error(
  //     title: 'An error was captured by main.runZonedGuarded',
  //     error: error,
  //     stackTrace: stackTrace,
  //   );
  // });

  _configureMacosWindowUtils();

  mainContext.onReactionError((_, rxn) {
    log.error(
      title: 'A mobx reaction error occured.',
      error: rxn.errorValue!.exception,
      stackTrace: rxn.errorValue!.stackTrace,
    );
  });

  //todo remove these lines

  // register all dependecy injection
  getItRegister = await getItInit(env: Environment.dev);
  final _appMetaInfo = getIt<AppMetaInfo>();
  await _appMetaInfo.init();

  print('todo new builder.yaml');
  FlutterError.onError = _logFlutterOnError;

  HttpClient.enableTimelineLogging = env.config.enableHttpTimelineLogging;

  runApp(AppScreen());
  //todo remove these lines

  runZonedGuarded(() async {
    //todo uncomment these lines
    // _configureMacosWindowUtils();
    //
    // WidgetsFlutterBinding.ensureInitialized();
    //
    // // register all dependecy injection
    // await getItInit(env: Environment.dev);
    // final _appMetaInfo = getIt<AppMetaInfo>();
    // await _appMetaInfo.init();
    //
    // print('todo new builder.yaml');
    // FlutterError.onError = _logFlutterOnError;
    //
    // HttpClient.enableTimelineLogging = env.config.enableHttpTimelineLogging;
    //
    // runApp(AppScreen());
    //todo uncomment these lines
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    log.error(
      title:
          'A Flutter error occured and it was captured by main.runZonedGuarded',
      error: error,
      stackTrace: stackTrace,
    );
  });

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final errorAndStacktrace = pair as List;

    log.error(
      title: 'An error was captured by main.Isolate.current.addErrorListener',
      error: errorAndStacktrace.first,
      stackTrace: errorAndStacktrace.last as StackTrace,
    );
  }).sendPort);
}
