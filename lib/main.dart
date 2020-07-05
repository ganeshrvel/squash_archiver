import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squash_archiver/common/di/di.dart' as di;
import 'package:squash_archiver/constants/env.dart';
import 'package:squash_archiver/features/app/ui/pages/app_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:squash_archiver/services/crashes_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // register all dependecy injection
  await di.init();

  if (env.config.reportCrashAnalytics) {
    Crashlytics.instance.enableInDevMode = true;

    FlutterError.onError = Crashlytics.instance.recordFlutterError;
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  HttpClient.enableTimelineLogging = env.config.enableHttpTimelineLogging;

  runZonedGuarded(() {
    runApp(AppScreen());
  }, (Object error, StackTrace stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    final _crashesService = di.getIt<CrashesService>();

    _crashesService.capture(error, stackTrace);
  });
}
